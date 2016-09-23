#!/bin/sh
set -e
set -x

# Ensure the main and testing repros are present. Needed for runit
#echo "http://alpine.gliderlabs.com/alpine/edge/testing" >> /etc/apk/repositories

# These packages make it into the final image.
#apk -U add runit python py-setuptools libffi ip6tables ipset iputils-* net-tools iproute2 yajl
apt-get update
apt-get -y install runit python python-setuptools libffi6 libffi-dev ipset iputils-* net-tools iproute2 ruby-yajl git
# These packages are only used for building and get removed.
#apk add --virtual temp python-dev libffi-dev py-pip alpine-sdk curl
apt-get -y install build-essential git python-pip python-dev libffi-dev curl
# Install Confd
curl -L https://github.com/projectcalico/confd/releases/download/v0.10.0-scale/confd.static -o /sbin/confd

# Copy patched BIRD daemon with tunnel support.
curl -L https://github.com/projectcalico/calico-bird/releases/download/v0.1.0/bird -o /sbin/bird
curl -L https://github.com/projectcalico/calico-bird/releases/download/v0.1.0/bird6 -o /sbin/bird6
curl -L https://github.com/projectcalico/calico-bird/releases/download/v0.1.0/birdcl -o /sbin/birdcl
chmod +x /sbin/*

# Install Felix and libcalico
pip install git+https://github.com/projectcalico/calico.git@1.4.0b1
pip install git+https://github.com/projectcalico/libcalico.git@v0.13.0
# Output the python library list
pip list > libraries.txt

