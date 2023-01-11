#! /bin/sh

# install repo tool
mkdir -p $HOME/bin
export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> $HOME/.bashrc
curl https://storage.googleapis.com/git-repo-downloads/repo > $HOME/bin/repo
chmod a+x $HOME/bin/repo

mkdir layers
cd layers
repo init -u https://github.com/nenadilic84/meta-aws-iot-rpi-distro -m conf/manifest.xml
repo sync