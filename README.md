## meta-aws-iot-rpi-distro

**rpi-iot-distro** is an AWS IoT Device Client demonstration running
on the rapberry pi board.

**KNOW THIS BEFORE YOU DO ANYTHING**

- Setup the cloud-side prior to building and running the image. The
demonstration will fail without cloud-side provisioning.
- It is expected that you have AWS CLI installed and configured for
  the target region where you want to operate.

#### Cloud configuration

Setup fleet provisioning to prepare for device first boot provisioning.

Please look at the scripts to understand the options.  The usage of
the script in step 3 is a bit rough at this point.

1. Create a fleet provisioning role as defined here. You will need
   this role ARN for step 3.
   1. Navigate to
      https://docs.aws.amazon.com/iot/latest/developerguide/provision-wo-cert.html
   2. Create role as defined in step 4, in section **Provisioning by
      claim**.

   Or use the aws-cli
   ```
   aws iam create-role --role-name IoTProvisioningRole --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"iot.amazonaws.com\"]},\"Action\":[\"sts:AssumeRole\"]}]}"

   aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/service-role/AWSIoTThingsRegistration --role-name IoTProvisioningRole
   ```

2. Generate credentials with `scripts/create-credential.sh` using the
   policy at `scripts/fleet-provisioning/fp-policy.json`.
   ```
   cd scripts
   ./create-credential.sh -t "unicorn-demo" -n "fp-plicy" -f "fleet-provisioning/fp-policy.json" -F
   mv ../../volatile/unicorn-demo/unicorn-demo.crt.pem ../recipes-iot/aws-iot-device-client/files/cert.pem 
   mv ../../volatile/unicorn-demo/unicorn-demo.key.prv.pem ../recipes-iot/aws-iot-device-client/files/key.pem 
   ```

3. Create the fleet provisioning template using the script `scripts/fleet-provisioning/setup.sh`.
   ```
   cd fleet-provisioning
   export ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
   ./setup.sh arn:aws:iam::$ACCOUNT:role/IoTProvisioningRole
   ```

#### Device image


Initialize the environment.

```bash
curl
https://raw.githubusercontent.com/nenadilic84/meta-aws-iot-rpi-distro/main/scripts/env/aws-iot-rpi.sh | \
  bash
```

Set in local.conf

```text
DEMO_IOT_ENDPOINT = "<ENDPOINT>"`
DEMO_THING_NAME="<thing name used for provisioning>"
```

Where `<ENDPOINT>` is the value output from the following:


```bash
aws --output text --query endpointAddress iot describe-endpoint --endpoint-type iot:data-ats
```

Initialize the environment.

```bash
cd $HOME/aws-iot-rpi-distro
. ./layers/openembedded-core/oe-init-build-env
MACHINE=raspberrypi4 bitbake unicorn-image
MACHINE=raspberrypi4 bitbake update-image
```

In case you are building this on an EC2 you can send it to s3 and download it on a PC from there.

```
aws s3 cp $BBPATH/tmp/deploy/images/raspberrypi4/unicorn-image-raspberrypi4.wic.bz2 s3://<yocto image bucket>/unicorn-image-raspberrypi4.wic.bz2
```

Write the image to sd card.

```bash

wic=$BBPATH/tmp/deploy/images/raspberrypi4/unicorn-image-raspberrypi4.wic.bz2

sudo dd if=$wic of=/dev/sda \
         bs=1M iflag=fullblock oflag=direct \
         conv=fsync status=progress
```
or in case this is done on a MAC OS

```
sudo gdd if=unicorn-image-raspberrypi4.wic.bz2 of=/dev/disk4 bs=1M iflag=fullblock conv=fsync status=progress
```


# AWS IoT Jobs

Create an AWS IoT Job that will update the system using a template:

```
jq -r '.steps[0].action.input.args[1] |= <presigned url>' jobs/swupdate-job-template.json > swupdate-job.json
jq -r '.steps[0].action.input.args[5] |= <parititon>' jobs/swupdate-job-template.json > swupdate-job.json

aws iot create-job --job-id board_info --document file://swupdate-job.json --targets arn:aws:iot:<region>:<account>:thing/<thing name>
            
```

Describe job execution:

```
aws iot describe-job-execution --job-id board_info --thing-name <thing name>
```

