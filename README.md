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
Once the VM has started, the installed application will be available through these links:

|Application Links|
|-----------------|
|[Red Hat IoT Cargo Demo](http://localhost:8081)|
|[Kura Web Console](http://localhost:8080)|
|[Everyware Cloud](https://console-sandbox.everyware-cloud.com)|


To stop the VM and destroy it completely, run:
```
vagrant destroy
```

Installing components to Kura
==
Once you have the VM running, you can access the [Kura web console](http://localhost:8080) and login as admin/admin.

Download the Red Hat IoT demo package on your host machine:
```
$ curl -O https://s3.amazonaws.com/redhat-iot/com.redhat.iot.demo.package_1.0.1-SNAPSHOT.dp
```
Back in the Kura UI, click on the "Packages" menu and then select "Install/Upgrade". Select the com.redhat.iot.demo.package_1.0.1-SNAPSHOT.dp file that you downloaded above from the download location. This installs the main demo components.

Due to a bug in Kura, to reinstall new versions you must first manually Uninstall the package and then install the new version in two steps.



Troubleshooting
==
If the VM stops at the lines:
```
==> redhat-iot-demo: Waiting for machine to boot. This may take a few minutes...
    redhat-iot-demo: SSH address: 127.0.0.1:2222
    redhat-iot-demo: SSH username: vagrant
    redhat-iot-demo: SSH auth method: private key
```
for more than 3 minutes, you can use CTRL-C to cancel the build, and then run `vagrant destroy` to clean up. Run `vagrant up` to try the VM build again. This is a known issue, but if the VM doesn't start after trying 2-3 times, please open an issue. If you have a possible solution or input on the problem, please open an issue as well.


Additional commands to know are:

|Command|Function|
|-------|--------|
|vagrant up|Creates a new VM from the template|
|vagrant suspend|Suspends the VM without destroying it (resume with vagrant resume)|
|vagrant resume|Resume a suspended VM|
|vagrant destroy|Destroy the VM completely (Use if you want to create a new one|
|vagrant provision|Run the provisioners on the existing VM.|
|vagrant ssh|Uses the private keys installed in the VM to establish an ssh session|



More details in [these instructions](vagrant/README.md)

Creating base RHEL box
==
Follow [these instructions](packer/README.md)