Vagrant.configure(2) do |config|

  config.vm.box = "dinoue/vcczw"

  config.vm.network :private_network, ip: "192.168.33.12"
  config.hostsupdater.aliases = ["www.vcczw.dev","phpmyadmin.vcczw.dev"]

  config.vm.hostname = "vcczw.dev"

  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = true
  end

  config.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=755', 'fmode=644']
  config.vm.synced_folder "www/wordpress", "/var/www/wordpress", :create => "true", :mount_options => ['dmode=755', 'fmode=644']

  config.vm.provider :virtualbox do |vb|
    vb.name = "vcczw.dev"
    vb.memory = "512"
    vb.cpus = "1"
  end

  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = ["provision/cookbooks"]
    chef.roles_path = "provision/roles"
    chef.add_role "config"
  end
end