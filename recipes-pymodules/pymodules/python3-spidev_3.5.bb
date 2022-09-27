
SUMMARY = "Python bindings for Linux SPI access through spidev"
HOMEPAGE = "http://github.com/doceme/py-spidev"
AUTHOR = "Volker Thoms <unconnected@gmx.de>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2077511c543a7c85245a516c47f4de78"

SRC_URI = "https://files.pythonhosted.org/packages/62/56/de649e7d95f9fcfaf965a6eb937b4a46bc77ef21487c99cde1a7a0546040/spidev-3.5.tar.gz"
SRC_URI[md5sum] = "7007e4fff2750025e233d8dfe46be670"
SRC_URI[sha256sum] = "8a7f5c289f161ea2ac4697fa8a10918232c990678dd0053084b3c43b1363910d"

S = "${WORKDIR}/spidev-3.5"

RDEPENDS_${PN} = ""

inherit setuptools3
