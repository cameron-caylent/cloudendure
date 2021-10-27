#!/bin/bash

sudo apt update
sudo apt upgrade -y

# install docker prereqs
sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
	git


#install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

sudo apt-key fingerprint 0EBFCD88
read -t 5 -p "pausing for five seconds"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

sudo apt install postgresql postgresql-contrib



