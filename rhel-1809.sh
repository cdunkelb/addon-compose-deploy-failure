#!/bin/bash
#Author: Carl Dunkelberger (cdunkelb)

#Test for existence for docker-ee-url argument

set -e

if [ -z "$1" ]
  then
    echo "No argument supplied"
    echo "Usage: $0 DOCKER_EE_URL"
    exit
fi

#uninstall old Docker Versions
sudo yum remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine

#Remove existing docker repositories
sudo rm /etc/yum.repos.d/docker*.repo
#Temporarily Store
export DOCKERURL=$1
sudo -E sh -c 'echo "$DOCKERURL/rhel" > /etc/yum/vars/dockerurl'
sudo sh -c 'echo "7" > /etc/yum/vars/dockerosversion'
# device-mapper-persistent-data and lvm2 are only required for the devicemapper storage driver
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager --enable rhel-7-server-extras-rpms
# Depending on cloud provider, you may also need to enable another repository:
# for AWS
sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
# for Azure
# sudo yum-config-manager --enable rhui-rhel-7-server-rhui-extras-rpms

# Add the Docker EE stable repository
sudo -E yum-config-manager \
    --add-repo \
    "$DOCKERURL/rhel/docker-ee.repo"

# To install a specific version of Docker EE (recommended in production), list versions and install
# sudo yum list docker-ee  --showduplicates | sort -r
# sudo yum -y install <FULLY-QUALIFIED-PACKAGE-NAME>
sudo yum-config-manager --enable docker-ee-stable-18.09

# Install the latest patch release
sudo yum -y install docker-ee

# Docker is installed but not started. The docker group is created, but no users are added to the group.

# Start the docker daemon
sudo systemctl start docker

#test installation with hello-world container
sudo docker run hello-world

#Next Steps: https://docs.docker.com/install/linux/linux-postinstall/
