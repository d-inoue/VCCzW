#
# Cookbook Name:: phpmyadmin-ex
# Recipe:: default
#
# Copyright 2015, dinoue
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"

package "libmcrypt" do
  action :install
  options "--enablerepo=epel"
end

%w[php-mcrypt php-mysql phpMyAdmin].each do |pkg|
  package pkg do
      action :install
      options "--enablerepo=epel"
  end
end

web_app "phpmyadmin-ex" do
  server_name node['phpmyadmin-ex']['hostname']
  docroot node['phpmyadmin-ex']['docroot_dir']
  allow_override node['phpmyadmin-ex']['allow_override']
end

# template "phpMyAdmin.conf" do
#   path "/etc/httpd/conf.d/phpMyAdmin.conf"
#   source "phpMyAdmin.conf.erb"
#   mode "0777"
#   notifies :restart, "service[httpd]"
# end