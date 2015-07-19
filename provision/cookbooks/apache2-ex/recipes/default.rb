#
# Cookbook Name:: apache2-ex
# Recipe:: default
#
# Copyright 2015, dinoue
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

web_app "apache2-ex" do
  server_name node['apache-ex']['hostname']
  server_aliases [node['apache-ex']['hostname']]
  docroot node['apache-ex']['docroot_dir']
  allow_override node['apache-ex']['allow_override']
end