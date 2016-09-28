Red Hat IoT Demo Kit
=
This project contains a vagrant VM configuration for running a RHEL based gateway with the Eclipse Kura intelligent gateway software. In addition, the packer directory 
contains a packer project to recreate the base RHEL box image used by the vagrant config.

Starting the Demo VM
==
```
vagrant up
```

Creating base RHEL box
==
```
$ cd packer
$ ISO_URL=file://<fully qualified path to iso> packer build --force -var 'rhsm_userid=<rhsm userid>' -var 'rhsm_password=<rhsm password>' rhel-7.2-vbox.json
```