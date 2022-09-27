FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

UNICORN_RPI_SSID ?= "xxx"
UNICORN_RPI_PSK ?= "xxx"

SRC_URI += "\    
    file://wpa_supplicant@wlan0.service \
    file://wlan-dhclient.service \
"

do_install:append () {

    install -D -m0644 ${WORKDIR}/wpa_supplicant@wlan0.service ${D}${systemd_unitdir}/system
    install -D -m0644 ${WORKDIR}/wlan-dhclient.service ${D}${systemd_system_unitdir}/wlan-dhclient.service

    install -D -m 600 /dev/null ${D}/etc/wpa_supplicant.conf

    echo 'ctrl_interface=DIR=/var/run/wpa_supplicant 
    update_config=1
    network={
        ssid="${UNICORN_RPI_SSID}"
        psk=${UNICORN_RPI_PSK}
    }
    ' > ${D}/etc/wpa_supplicant.conf

}

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "wpa_supplicant@wlan0.service wlan-dhclient.service"
