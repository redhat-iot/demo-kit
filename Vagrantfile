# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

demo_config = YAML.load_file(File.join(ENV['HOME'], '.vagrant.d', 'redhat-iot-demo.yml'))

# The private network IP of the VM. You will use this IP to connect to OpenShift.
# This variable is ignored for Hyper-V provider.
PUBLIC_ADDRESS="10.1.2.2"

# Number of virtualized CPUs
VM_CPU = ENV['VM_CPU'] || 1

# Amount of available RAM
VM_MEMORY = ENV['VM_MEMORY'] || 2048

# Validate required plugins
REQUIRED_PLUGINS = %w(vagrant-sshfs)
# REQUIRED_PLUGINS = %w(vagrant-sshfs)
errors = []

def message(name)
  "#{name} plugin is not installed, run `vagrant plugin install #{name}` to install it."
end
# Validate and collect error message if plugin is not installed
REQUIRED_PLUGINS.each { |plugin| errors << message(plugin) unless Vagrant.has_plugin?(plugin) }
unless errors.empty?
  msg = errors.size > 1 ? "Errors: \n* #{errors.join("\n* ")}" : "Error: #{errors.first}"
  fail Vagrant::Errors::VagrantError.new, msg
end


Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-registration") then
    config.registration.skip = true
  end
  config.vm.box = 'rhel-7.2'
  # config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |v, override|
    v.memory = VM_MEMORY
    v.cpus   = VM_CPU
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provider "libvirt" do |v, override|
    v.memory = VM_MEMORY
    v.cpus   = VM_CPU
    v.driver = "kvm"
    v.suspend_mode = "managedsave"
  end

  config.vm.network "private_network", ip: "#{PUBLIC_ADDRESS}" 
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # config.vm.synced_folder demo_config['kura']['location'] + '/kura/distrib/target', '/kura'
  
  # Proxy Information
  # config.registration.proxy = PROXY = (ENV['PROXY'] || '')
  # config.registration.proxyUser = PROXY_USER = (ENV['PROXY_USER'] || '')
  # config.registration.proxyPassword = PROXY_PASSWORD = (ENV['PROXY_PASSWORD'] || '')

  config.vm.provision "shell", run: "always", env: {"KURA_INSTALLER" => demo_config['kura']['installer']}, inline: <<-SHELL
    echo "Installing Kura from $KURA_INSTALLER"
    sudo /vagrant/files/${KURA_INSTALLER}
    sudo systemctl start kura
    echo
    echo "Successfully started and provisioned VM with #{VM_CPU} cores and #{VM_MEMORY} MB of memory."
    echo "To modify the number of cores and/or available memory set the environment variables"
    echo "VM_CPU and/or VM_MEMORY respectively."
    echo
    echo "You can now access the Kura console on: http://localhost:8080"
    echo "Default login is admin/admin"
    echo
  SHELL
end
