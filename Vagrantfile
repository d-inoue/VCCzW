# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

_conf = YAML.load_file('./config.yml')

Vagrant.configure(2) do |config|

  config.vm.box = _conf['vm_box']

  bridge_if = %x(VBoxManage list bridgedifs | grep '^Name:' | head -n 1).chomp.sub(/^Name: +/, "")

  config.vm.network :private_network, ip: _conf['private_ip']
  if _conf['public_ip'] != 0
    config.vm.network :public_network, ip: _conf['public_ip'], bridge: bridge_if
  end
  config.hostsupdater.aliases = _conf['domain_name']

  config.vm.hostname = _conf['host_name']

  config.omnibus.chef_version = :latest

  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = true
  end

  config.vm.synced_folder '.', '/vagrant', :mount_options => ['dmode=755', 'fmode=644']
  config.vm.synced_folder _conf['sync_folder'], _conf['document_root'], :create => 'true', :mount_options => ['dmode=755', 'fmode=644']

  config.vm.provider :virtualbox do |vb|
    vb.name = _conf['host_name']
    vb.memory = _conf['memory'].to_i
    vb.cpus = _conf['cpus'].to_i
  end

  config.ssh.forward_agent = true

  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = ['provision/cookbooks']
    chef.roles_path = 'provision/roles'
    chef.add_role 'config'
  end
end