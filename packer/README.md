## Packer templates for Red Hat Enterprise Linux 7.x x86_64

## Overview

This repository contains templates for [RHEL7](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/index.html)
x86_64 that creates [Vagrant](http://vagrantup.com) boxes using [Packer](http://packer.io).

The end result is a base RHEL 7.2 box file that can be added locally for Vagrant. The subscription manager credentials are only used 
during the build of the base box. They are used so that all of the additional installed packages and OS packages are the latest available
at the time of the base box build. If your Vagrant configuration requires additional packages, you will need to supply user private config
for a valid subscription as detailed in the README in the demo-kit/vagrant directory.

## Prerequisites

1. Packer 1.8.5+
2. Virtualbox
3. RHEL 7.2 server iso (rhel-server-7.2-x86_64-dvd.iso)

## Creating the box

1. Copy the RHEL iso to packer/iso/ directory
```
$ cp ~/Downloads/rhel-server-7.2-x86_64-dvd.iso demo-kit/packer/iso
```

1. Run packer with the following command and substitute your Red Hat Subscription Manager credentials
```
$ packer build -var 'rhsm_userid=<rhsm userid>' -var 'rhsm_password=<rhsm password>' rhel-7.2-vbox.json
```
This step takes several minutes so be patient. If it takes longer than 15 minutes it is probably hung at some step. 
If it appears hung, you can abort with CTRL-C and run again with the --force option to force overwriting any previous attempt.
```
packer build --force -var 'rhsm_userid=<rhsm userid>' -var 'rhsm_password=<rhsm password>' rhel-7.2-vbox.json
```
1. Add/update the box in Vagrant. If you have any existing VMs created with this base box by Vagrant, you will have to `vagrant destroy` and then
`vagrant up`.
```
$ vagrant box add rhel-7.2 rhel-7.2-vbox.box --force
```
4. Build VMs
```
$ cd ../vagrant
$ vagrant up
```
