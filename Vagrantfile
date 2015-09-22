# -*- mode: ruby -*-
# vi: set ft=ruby :

#ymlファイルを使用する場合に宣言
require 'yaml'

_conf = YAML.load_file('./config.yml')

Vagrant.configure(2) do |config|

  config.vm.box = _conf['vm_box']
  #デバック用にデフォルトのboxを使用してテストする場合は以下のコメントを外す
  #config.vm.box_version = '< 3.0.1'

  #パブリックipを使用する場合にホストマシンで使用するブリッジを取得する
  bridge_if = %x(VBoxManage list bridgedifs | grep '^Name:' | head -n 1).chomp.sub(/^Name: +/, "")

  #ゲストOSのプライベートipを設定
  config.vm.network :private_network, ip: _conf['private_ip']
  #パブリックipを使用する場合の設定
  if _conf['public_ip'] != 0
    config.vm.network :public_network, ip: _conf['public_ip'], bridge: bridge_if
  end
  #ipではなくドメインでアクセスする場合の設定
  #require vagrant-hostsupdater
  config.hostsupdater.aliases = _conf['domain_name']

  config.vm.hostname = _conf['host_name']

  #require vagrant-omnibus
  #ゲストOSにシェフを自動でインストールする
  config.omnibus.chef_version = :latest

  #vagrant終了時に追加したhost名を消去するかどうか
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