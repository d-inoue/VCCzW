#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2015, dinoue
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
include_recipe 'firewalld'
include_recipe 'ssl_certificate'

#http&https setting
firewalld_service 'https' do
    action :add
    zone   'public'
end

my_key_path   = '/etc/httpd/ssl/server.key'
my_cert_path  = '/etc/httpd/ssl/server.crt'
my_chain_path = '/etc/httpd/ssl/server.cer'

ssl_certificate 'ssl_site' do
  key_path my_key_path
  cert_path my_cert_path
  chain_path my_chain_path
end

web_app 'vcczw' do
  cookbook 'apache2'
  #web_app.conf.erb from templates of apache2 and default config file is made.
  server_port node['vcczw']['apache']['port']
  server_name node['vcczw']['apache']['server_name']
  docroot node['vcczw']['apache']['docroot_dir']
  allow_override node['vcczw']['apache']['allow_override']
  application_name node['vcczw']['apache']['name']
end

web_app 'vcczw-ssl' do
  cookbook 'apache2'
  #web_app.conf.erb from templates of apache2 and default config file is made.
  server_port node['vcczw']['apache']['port-ssl']
  server_name node['vcczw']['apache']['server_name']
  docroot node['vcczw']['apache']['docroot_dir']
  allow_override node['vcczw']['apache']['allow_override']
  application_name node['vcczw']['apache']['name-ssl']
end

web_app 'vcczw-ssl' do
  cookbook 'ssl_certificate'
  #web_app.conf.erb from templates of ssl_certificate
  port node['vcczw']['apache']['port-ssl']
  server_name node['vcczw']['apache']['server_name']
  docroot node['vcczw']['apache']['docroot_dir']
  allow_override node['vcczw']['apache']['allow_override']
  application_name node['vcczw']['apache']['name-ssl']
  ssl_key my_key_path
  ssl_cert my_cert_path
  #ssl_chain my_chain_path
end

#phpmyadmin setting
package 'libmcrypt' do
  action :install
  options '--enablerepo=epel'
end

%w[php-mcrypt php-mysql phpMyAdmin].each do |pkg|
  package pkg do
      action :install
      options '--enablerepo=epel'
  end
end

web_app 'phpmyadmin' do
  cookbook 'apache2'
  #web_app.conf.erb from templates of apache2 and default config file is made.
  server_port node['vcczw']['apache']['phpmyadmin']['port']
  server_name node['vcczw']['apache']['phpmyadmin']['server_name']
  docroot node['vcczw']['apache']['phpmyadmin']['docroot_dir']
  allow_override node['vcczw']['apache']['phpmyadmin']['allow_override']
  application_name node['vcczw']['apache']['phpmyadmin']['name']
end

web_app 'phpmyadmin-ssl' do
  cookbook 'apache2'
  #web_app.conf.erb from templates of apache2 and default config file is made.
  server_port node['vcczw']['apache']['phpmyadmin']['port-ssl']
  server_name node['vcczw']['apache']['phpmyadmin']['server_name']
  docroot node['vcczw']['apache']['phpmyadmin']['docroot_dir']
  allow_override node['vcczw']['apache']['phpmyadmin']['allow_override']
  application_name node['vcczw']['apache']['phpmyadmin']['name-ssl']
end

web_app 'phpmyadmin-ssl' do
  cookbook 'ssl_certificate'
  #web_app.conf.erb from templates of ssl_certificate
  port node['vcczw']['apache']['phpmyadmin']['port-ssl']
  server_name node['vcczw']['apache']['phpmyadmin']['server_name']
  docroot node['vcczw']['apache']['phpmyadmin']['docroot_dir']
  allow_override node['vcczw']['apache']['phpmyadmin']['allow_override']
  application_name node['vcczw']['apache']['phpmyadmin']['name-ssl']
  ssl_key my_key_path
  ssl_cert my_cert_path
  #ssl_chain my_chain_path
end

#maridb setting
# gem_package 'mysql2' do
#   gem_binary('/usr/local/rbenv/shims/gem')
#   action :install
# end

execute 'mysql-create-database' do
    command "/usr/bin/mysql -u root --password=\"#{node['mariadb']['server_root_password']}\"  < /tmp/create-database.sql"
    action :nothing
    not_if "/usr/bin/mysql -u root --password=\"#{node['mariadb']['server_root_password']}\" --database=\"#{node['vcczw']['mariadb']['database']}\""
end

template '/tmp/create-database.sql' do
    owner 'root'
    group 'root'
    mode '0600'
    source "create-database.sql.erb"
    variables(
        :database => node['vcczw']['mariadb']['database']
    )
    notifies :run, 'execute[mysql-create-database]', :immediately
end

execute 'mysql-create-user' do
    command "/usr/bin/mysql -u root --password=\"#{node['mariadb']['server_root_password']}\"  < /tmp/create_user.sql"
    action :nothing
end

template '/tmp/create_user.sql' do
    owner 'root'
    group 'root'
    mode '0600'
    source "create_user.sql.erb"
    variables(
        :user     => node['vcczw']['mariadb']['username'],
        :password => node['vcczw']['mariadb']['password'],
        :database => node['vcczw']['mariadb']['database'],
        :host => node['mariadb']['bind_address']
    )
    notifies :run, 'execute[mysql-create-user]', :immediately
end
