Red Hat IoT Demo Kit
=
This project contains a vagrant VM configuration for running a RHEL based gateway with the Eclipse Kura intelligent gateway software. In addition, the packer directory 
contains a packer project to recreate the base RHEL box image used by the vagrant config.

Starting the Demo VM
==
```
vagrant up
```
More details in [these instructions](vagrant/README.md)

Creating base RHEL box
==
Follow [these instructions](packer/README.md)