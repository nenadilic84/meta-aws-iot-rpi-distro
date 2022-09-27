FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += "parted util-linux-sfdisk "

SRC_URI += " \
     file://swupdate.cfg \
     file://swupdate.service \
     "

do_install:append() {
    sed -i -e "s|\$UPDATE_TARGET|${MACHINE}|" ${WORKDIR}/swupdate.service

    install -d ${D}${sysconfdir}
    install -d ${D}${systemd_unitdir}/system

    install -m 644 ${WORKDIR}/swupdate.cfg ${D}${sysconfdir}
    install -m 644 ${WORKDIR}/swupdate.service ${D}${systemd_unitdir}/system

}

SYSTEMD_SERVICE_${PN}:remove = "swupdate-usb@.service swupdate-progress.service"

SYSTEMD_AUTO_ENABLE_${PN} = "enable"
