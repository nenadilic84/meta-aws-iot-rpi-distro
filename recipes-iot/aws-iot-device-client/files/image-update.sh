#!/bin/sh
set -e

args=$(getopt --name "$0" --options s:i:p: -- "$@")
eval set -- "$args"

while [[ $# -gt 0 ]]; do
	case "$1" in
		-s) S3_URL=$2; shift 2;;
		-i) IMAGE_FILE=$2; shift 2;;
		-p) PARTITION=$2; shift 2;;
		*)
			shift
			;;
	esac
done

echo "Running update-image.sh with: "
echo "S3_URL: $S3_URL"
echo "IMAGE_FILE: $IMAGE_FILE"
echo "PARTITION: $PARTITION"

# Check if we are updating the right partition
if [ $(mount | grep -c "/dev/mmcblk0p2 on / ") == 1 ];
then
	if [ "$PARTITION" == "main" ];
	then
		echo "We are already on the paritition main, nothing to do!"
		exit 0
	fi
elif [ $(mount | grep -c "/dev/mmcblk0p3 on / ") == 1 ];
then
	if [ "$PARTITION" == "alt" ];
	then
		echo "We are already on the paritition alt, nothing to do!"
		exit 0
	fi
fi

if command -v "wget" > /dev/null
then
	echo "Using wget for downloading user specified file"
	wget --quiet -O"$IMAGE_FILE" "$S3_URL"
else
	>&2 echo "Wget software package not installed on the device."
	exit 1
fi

echo "Calling swupdate"
if command -v "swupdate" > /dev/null
then
	echo "Using swupdate to update partition"
	swupdate -e stable,$PARTITION -i "$IMAGE_FILE" -H raspberrypi4:1.0 -v
else
	>&2 echo "swupdate software package not installed on the device."
	exit 1
fi