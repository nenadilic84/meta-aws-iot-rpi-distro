#! /bin/sh
curl https://storage.googleapis.com/git-repo-downloads/repo > /tmp/repo
chmod +x /tmp/repo
mkdir -p $HOME/aws-iot-rpi-distro/layers
cd $HOME/aws-iot-rpi-distro/layers
/tmp/repo init \
          -u https://github.com/nenadilic84/meta-aws-iot-rpi-distro \
          -m conf/distro/aws-iot-rpi.xml

/tmp/repo sync

cd $HOME/aws-iot-rpi-distro

cd $HOME/aws-iot-rpi-distro
. layers/openembedded-core/oe-init-build-env

bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-openembedded/meta-oe
bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-openembedded/meta-python
bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-openembedded/meta-filesystems
bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-openembedded/meta-networking
bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-swupdate
bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-aws
bitbake-layers add-layer $HOME/aws-iot-rpi-distro/layers/meta-aws-iot-rpi-distro

echo "NEXT STEP:"
echo "$ DISTRO=aws-iot-rpi MACHINE=raspberrypi3 bitbake update-image"
