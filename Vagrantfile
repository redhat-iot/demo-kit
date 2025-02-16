# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

demo_config = YAML.load_file(File.join(ENV['HOME'], '.vagrant.d', 'redhat-iot-demo.yml'))

# This variable is ignored for Hyper-V provider.
PRIVATE_ADDRESS="10.1.2.2"

# Number of virtualized CPUs
VM_CPU = ENV['VM_CPU'] || 1

# Amount of available RAM
VM_MEMORY = ENV['VM_MEMORY'] || 2048

# Validate required plugins
# REQUIRED_PLUGINS = %w(vagrant-sshfs)
errors = []

def message(name)
  "#{name} plugin is not installed, run `vagrant plugin install #{name}` to install it."
end
# Validate and collect error message if plugin is not installed
#REQUIRED_PLUGINS.each { |plugin| errors << message(plugin) unless Vagrant.has_plugin?(plugin) }
unless errors.empty?
  msg = errors.size > 1 ? "Errors: \n* #{errors.join("\n* ")}" : "Error: #{errors.first}"
  fail Vagrant::Errors::VagrantError.new, msg
end

# Remove any stale camelLock files from file watcher component
# Probably needs to be in a cleanup or post provision event
Dir.glob(File.expand_path File.dirname(__FILE__) + '/files/*.camelLock').each { |file| File.delete(file)}

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-registration") then
    config.registration.skip = true
  end
  config.vm.box = 'rhel-7.2'
  config.vm.box_url = 'https://rawgit.com/redhat-iot/demo-tooling/master/atlas/rhel-7.2-box.json'
  config.vm.define "redhat-iot-demo" do |foohost| end
  # config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v, override|
    v.memory = VM_MEMORY
    v.cpus   = VM_CPU
    #v.gui = true
    v.customize ['modifyvm', :id, '--usb', 'on']
    v.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'Broadcom Corp BCM20702A0 [0112]', '--vendorid', '0x0A5C', '--productid', '0x21EC']
    v.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'Broadcom Corp BCM20702A0 [0112]', '--vendorid', '0x0A5C', '--productid', '0x21E8']
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--cableconnected1", "on"]
    v.customize ["modifyvm", :id, "--cableconnected2", "on"]
  end

  config.vm.provider "libvirt" do |v, override|
    v.memory = VM_MEMORY
    v.cpus   = VM_CPU
    v.driver = "kvm"
    v.suspend_mode = "managedsave"
  end

  config.vm.network "private_network", ip: "#{PRIVATE_ADDRESS}" 
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8180, host: 8081
  config.vm.network "forwarded_port", guest: 8280, host: 8082
  config.vm.network "forwarded_port", guest: 10090, host: 10090
  config.vm.network "forwarded_port", guest: 10190, host: 10190
  config.vm.network "forwarded_port", guest: 11411, host: 11411  

  # config.vm.synced_folder demo_config['kura']['location'] + '/kura/distrib/target', '/kura'
  
  # Proxy Information
  # config.registration.proxy = PROXY = (ENV['PROXY'] || '')
  # config.registration.proxyUser = PROXY_USER = (ENV['PROXY_USER'] || '')
  # config.registration.proxyPassword = PROXY_PASSWORD = (ENV['PROXY_PASSWORD'] || '')
  config.vm.post_up_message = "
    Successfully started and provisioned VM with #{VM_CPU} cores and #{VM_MEMORY} MB of memory.
    To modify the number of cores and/or available memory set the environment variables
    VM_CPU and/or VM_MEMORY respectively.
    
    Next Steps
    ==========
    1). Deploy the Red Hat Demo Package
    Kura console: http://localhost:8080 (Default login is admin/admin)
    Go to Packages -> Install and pick the file vagrant/files/com.redhat.iot.demo.package-1.0.2-SNAPSHOT.dp

    2). Open Red Hat IoT Cargo Demo: http://localhost:8081
    Click on a shipment to start data graphing

    3). Everyware Cloud: https://console-sandbox.everyware-cloud.com

  "
  config.vm.provision "kura", type: :shell, name: "Kura Installation", run: "once", env: {"KURA_INSTALLER" => demo_config['kura']['installer']}, inline: <<-SHELL
    echo "Installing Kura from $KURA_INSTALLER"
    sudo /vagrant/files/${KURA_INSTALLER}
    sudo cp /vagrant/files/snapshot_0.xml /opt/eclipse/kura/data/snapshots/
    sudo cp /vagrant/files/bluetooth.service /lib/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl restart bluetooth
    sudo systemctl start kura
  SHELL

  config.vm.provision "eap", type: :shell, name: "JBoss EAP Installation", run: "once", inline: <<-SHELL
    echo "Installing JBoss EAP 7"
    sudo systemctl stop iptables
    cd /opt
    sudo unzip -qn /vagrant/files/jboss-eap-7.0.0.zip
    sudo ln -sf /opt/jboss-eap-7.0 /opt/jboss-eap
    sudo cp /vagrant/files/jboss-eap.conf /etc/default/
    sudo cp /vagrant/files/jbosseap7.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl start jbosseap7
    sleep 5
    echo "Removing welcome content"
    sudo /opt/jboss-eap/bin/jboss-cli.sh --connect --commands="/subsystem=undertow/server=default-server/host=default-host/location=\/:remove,:reload" --controller=127.0.0.1:10090
    sleep 5
  SHELL

#    echo "Deploy war files"
#    sudo /opt/jboss-eap/bin/jboss-cli.sh --connect --commands="deploy /vagrant/files/ROOT.war,deploy /vagrant/files/dgproxy.war" --controller=127.0.0.1:10090

  config.vm.provision 'webapp', type: :shell, name: "Deploy Web App", run: "once", inline: <<-SHELL
    echo "Redeploying the Webapp"
    sudo /opt/jboss-eap/bin/jboss-cli.sh --connect --commands="deploy --force /vagrant/files/ROOT.war,deploy --force /vagrant/files/dgproxy.war, :reload" --controller=127.0.0.1:10090
    sleep 10
  SHELL

  config.vm.provision "jdg", type: :shell, run: "once", inline: <<-SHELL
    echo "Installing JBoss Data Grid"
    cd /opt
    sudo unzip -qn /vagrant/files/jboss-datagrid-7.0.0-server.zip
    sudo ln -sf /opt/jboss-datagrid-7.0.0-server /opt/jboss-datagrid
    sudo mkdir /etc/infinispan-server
    sudo cp /vagrant/files/infinispan-server.conf /etc/infinispan-server/
    sudo cp /vagrant/files/jdg7.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl start jdg7
    until $(curl --output /dev/null --silent --head --fail http://localhost:8180/dgproxy/rest/rhiot/sensorConfig); do
        printf '.'
        sleep 1
    done
    curl --output /dev/null --silent -X PUT -d '@/vagrant/files/shipments.json' http://localhost:8180/dgproxy/rest/rhiot/sensorConfig -H 'Content-Type: application/json'
  SHELL


end
