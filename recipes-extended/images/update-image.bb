DESCRIPTION = "Example image demonstrating how to build SWUpdate compound image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit swupdate

SRC_URI = "\
    file://emmcsetup.lua \
    file://sw-description \
"

# images to build before building swupdate image
IMAGE_DEPENDS = "unicorn-image"

# images and files that will be included in the .swu image
SWUPDATE_IMAGES = "unicorn-image"

SWUPDATE_IMAGES_FSTYPES[unicorn-image] = ".ext4.gz"

python do_swuimage:prepend () {

    imgfilename = "unicorn-image"
    fstype = ".ext4.gz" # IMAGE_FSTYPES
    
    workdir = d.getVar('WORKDIR', True)
    swdescpath = os.path.join(workdir, "sw-description")

    swdesc = ""
    with open(swdescpath) as f:
        swdesc = f.read()

    imgfilename = imgfilename + '-' + d.getVar('MACHINE', True)

    imgfilename = imgfilename + fstype

    swdesc = swdesc.replace('%%IMAGE_NAME_PLACEHOLDER%%', imgfilename)

    with open(swdescpath, "w") as f:
        f.write(swdesc)
}