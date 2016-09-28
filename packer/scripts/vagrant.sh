#!/usr/bin/env bash
set -x

echo "Adding the vagrant ssh public key..."

# mkdir /home/vagrant/.ssh
# curl -Lo /home/vagrant/.ssh/authorized_keys https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub
# chown -R vagrant /home/vagrant/.ssh
# chmod -R go-rwsx /home/vagrant/.ssh

mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh