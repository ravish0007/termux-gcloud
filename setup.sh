#!/bin/bash

# Install wget and openssh
apt update && apt install -y wget openssh

#Install python along with dependency
apt install -y python
apt remove -y python   # gcloud requires 3.5-3.8 python

# Install python 3.8 to install Google Cloud SDK
wget https://raw.githubusercontent.com/Termux-pod/termux-pod/main/arch64/python/python-3.8.6/python_3.8.6_aarch64.deb -O python_3.8.deb
apt remove -y python
dpkg -i python_3.8.deb

# Install Google Cloud SDK
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-360.0.0-linux-arm.tar.gz -O gcloud-sdk.tar.gz

tar xvf  gcloud-sdk.tar.gz
./google-cloud-sdk/install.sh --quiet --usage-reporting false
./google-cloud-sdk/bin/gcloud init

# Useful Aliases
echo "alias gcloud='$(pwd)/google-cloud-sdk/bin/gcloud'" >> ~/.bashrc
echo "alias cloud-ssh='gcloud cloud-shell ssh'" >> ~/.bashrc
echo "alias cloud-vnc='gcloud cloud-shell ssh --command=~/novnc_deploy.sh'" >> ~/.bashrc
. ~/.bashrc

# Load config
. vnc.config
sed -i "s/vnc_password=.*/vnc_password=$vnc_password/g" novnc_deploy.sh
sed -i "s/resolution=.*/resolution=$vnc_resolution/g" novnc_deploy.sh

# Copy novnc_deploy to the cloud shell
chmod +x novnc_deploy.sh
./google-cloud-sdk/bin/gcloud cloud-shell scp localhost:$(pwd)/novnc_deploy.sh cloudshell:~/novnc_deploy.sh

