Red Hat IoT Demo Kit
=
This project contains a vagrant VM configuration for running a RHEL based gateway with the Eclipse Kura intelligent gateway software. In addition, the packer directory 
contains a packer project to recreate the base RHEL box image used by the vagrant config.

Pre-Requisites
==
* Clone this repository and change directories:
```
$ git clone https://github.com/redhat-iot/demo-kit.git
$ cd demo-kit/vagrant
```

* Download JBoss EAP 7 and JBoss Data Grid 7 to `files`
* Download Kura build
```
$ curl https://s3.amazonaws.com/redhat-iot/kura_2.1.0-SNAPSHOT_fedorapi_installer.sh -o files/kura_2.1.0-SNAPSHOT_fedorapi_installer.sh
```

* Create a private configuration file from template
```
$ mkdir $HOME/.vagrant.d
$ cp vagrant/redhat-iot-demo.yml $HOME/.vagrant.d/redhat-iot-demo.yml
```
Edit new file as needed (default should be ok unless you are doing Kura development).
Starting the Demo VM
==
```
vagrant up
```
More details in [these instructions](vagrant/README.md)

Creating base RHEL box
==
Follow [these instructions](packer/README.md)