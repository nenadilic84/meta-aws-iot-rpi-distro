SUMMARY = "Unicorn development image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

require recipes-core/images/core-image-minimal.bb

# python to run the examples
IMAGE_INSTALL:append = " python3 \
                         python3-requests \
                         python3-dev \
                         python3-spidev \ 
                         python3-unicornhathd \ 
                         python3-numpy"

IMAGE_INSTALL:append = " base-files \
                         vim \
                         ntp \
                         e2fsprogs-resize2fs \
                         openssh \
                         openssl \
                         openssh-sftp-server"

PREFERRED_PROVIDER:u-boot-fw-utils = "libubootenv"

IMAGE_INSTALL:append = " kernel-modules \
                         wireguard-tools \
                         linux-firmware-rpidistro-bcm43455 \
                         hostapd \
                         kea \
                         iptables \
                         gettext \
                         wpa-supplicant \
                         libubootenv \
                         swupdate swupdate-progress swupdate-tools \
                         aws-iot-device-client \
                         "

