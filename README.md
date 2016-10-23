Red Hat IoT Demo Kit
=
This project contains a vagrant VM configuration for running a RHEL based gateway with the Eclipse Kura intelligent gateway software. In addition, the packer directory 
contains a packer project to recreate the base RHEL box image used by the vagrant config.

Pre-Requisites
==
* Clone this repository and change to the project directory:
```
$ git clone https://github.com/redhat-iot/demo-kit.git
$ cd demo-kit/vagrant
```

* Download JBoss EAP 7 and JBoss Data Grid 7 to `vagrant/files`. (Files should be jboss-eap-7.0.0.zip and jboss-datagrid-7.0.0-server.zip)
* Download Kura build and make it executable
```
$ curl https://s3.amazonaws.com/redhat-iot/kura_2.1.0-SNAPSHOT_fedorapi_installer.sh -o files/kura_2.1.0-SNAPSHOT_fedorapi_installer.sh
$ chmod +x files/kura_2.1.0-SNAPSHOT_fedorapi_installer.sh 
```

* Create a private configuration file from template
```
$ mkdir $HOME/.vagrant.d
$ cp vagrant/redhat-iot-demo.yml $HOME/.vagrant.d/redhat-iot-demo.yml
```
Edit new file as needed (default should be ok unless you are doing Kura development).

Starting the Demo VM
==
To start the VM, run the following command:
```
vagrant up
```
To stop the VM and destroy it completely, run:
```
vagrant destroy
```


Troubleshooting
==
If the VM stops at the lines:
```
redhat-iot-demo: SSH address: 127.0.0.1:2222
redhat-iot-demo: SSH username: vagrant
redhat-iot-demo: SSH auth method: private key
```
for more than 3 minutes, you can use CTRL-C to cancel the build, and then run `vagrant destroy` to clean up. Run `vagrant up` to try the VM build again.


Additional commands to know are:

|Command|Function|
|-------|--------|
|vagrant up|Creates a new VM from the template|
|vagrant suspend|Suspends the VM without destroying it (resume with vagrant resume)|
|vagrant resume|Resume a suspended VM|
|vagrant destroy|Destroy the VM completely (Use if you want to create a new one|
|vagrant provision|Run the provisioners on the existing VM.|



More details in [these instructions](vagrant/README.md)

Creating base RHEL box
==
Follow [these instructions](packer/README.md)