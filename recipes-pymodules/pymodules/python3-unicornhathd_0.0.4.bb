
SUMMARY = "Python library for driving Pimoroni Unicorn HAT HD"
HOMEPAGE = "http://www.pimoroni.com"
AUTHOR = "Philip Howard <phil@pimoroni.com>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=3a38c674c32d7c68fe4283ed8587f7c5"

SRC_URI = "https://files.pythonhosted.org/packages/cf/47/3f61447cffe68e40232eca3b3f1ec69296b21c1ead1f03dc99d08fa140c7/unicornhathd-0.0.4.tar.gz"
SRC_URI[md5sum] = "04c44d5cdb3218f8835227b1b1f13a2f"
SRC_URI[sha256sum] = "41cbb1ca198f723e4b443522ee3b6d90aedac4bbc154d4e161afd349fe354615"

S = "${WORKDIR}/unicornhathd-0.0.4"

RDEPENDS_${PN} = "python3-spidev"

inherit setuptools3
