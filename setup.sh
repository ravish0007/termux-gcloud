#!/bin/bash

# Install wget
apt update && apt install -y wget

# Install python 3.8 to install Google Cloud SDK
wget https://raw.githubusercontent.com/Termux-pod/termux-pod/main/arch64/python/python-3.8.6/python_3.8.6_aarch64.deb -O python_3.8.deb
apt remove -y python
dpkg -i python_3.8.deb

# Install Google Cloud SDK
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-360.0.0-linux-arm.tar.gz -O gcloud-sdk.tar.gz

tar xvf  gcloud-sdk.tar.gz
./google-cloud-sdk/install.sh --quiet --usage-reporting false --bash-completion true
./google-cloud-sdk/bin/gcloud init

# Fetch novnc_deploy
wget https://gist.githubusercontent.com/ravish0007/c9884cdd90e8cc2ffaacacd658cc05d8/raw/4b03be4070afc9e84a01288952c47023b2223f16/novnc_deploy.sh -O novnc_deploy.sh
chmod +x novnc_deploy.sh

# Copy novnc_deploy to the cloud shell
./google-cloud-sdk/bin/gcloud cloud-shell scp localhost:$(pwd)/novnc_deploy.sh cloudshell:~/novnc_deploy.sh

# Useful Aliases
echo  "alias cloud-ssh='gcloud cloud-shell ssh'" >> "$PWD/.bashrc"
echo  "alias cloud-vnc='gcloud cloud-shell ssh --command=~/novnc_deploy.sh'" >> "$PWD/.bashrc"

. ~/.bashrc

