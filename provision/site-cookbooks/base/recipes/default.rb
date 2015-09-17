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
include_recipe 'ssl_certificate'
include_recipe 'wp-cli'

#
#Apache setting
#
my_key_path   = '/etc/httpd/ssl/server.key'
my_cert_path  = '/etc/httpd/ssl/server.crt'

ssl_certificate 'ssl_site' do
  key_path my_key_path
  cert_path my_cert_path
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
  cookbook 'ssl_certificate'
  #web_app.conf.erb from templates of ssl_certificate
  port node['vcczw']['apache']['port-ssl']
  server_name node['vcczw']['apache']['server_name']
  docroot node['vcczw']['apache']['docroot_dir']
  allow_override node['vcczw']['apache']['allow_override']
  application_name node['vcczw']['apache']['name-ssl']
  ssl_key my_key_path
  ssl_cert my_cert_path
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
  cookbook 'ssl_certificate'
  #web_app.conf.erb from templates of ssl_certificate
  port node['vcczw']['apache']['phpmyadmin']['port-ssl']
  server_name node['vcczw']['apache']['phpmyadmin']['server_name']
  docroot node['vcczw']['apache']['phpmyadmin']['docroot_dir']
  allow_override node['vcczw']['apache']['phpmyadmin']['allow_override']
  application_name node['vcczw']['apache']['phpmyadmin']['name-ssl']
  ssl_key my_key_path
  ssl_cert my_cert_path
end

#maridb setting
gem_package 'mysql2' do
  gem_binary('/usr/local/rbenv/shims/gem')
  action :install
end

execute 'mysql-create-database' do
    command "/usr/bin/mysql -u root --password=\"#{node['mariadb']['server_root_password']}\"  < /tmp/create-database.sql"
    action :nothing
    not_if "/usr/bin/mysql -u root --password=\"#{node['mariadb']['server_root_password']}\" --database=\"#{node['vcczw']['mariadb']['database']}\""
end

template '/tmp/create-database.sql' do
    owner 'root'
    group 'root'
    mode '0644'
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
    mode '0644'
    source "create_user.sql.erb"
    variables(
        :user     => node['vcczw']['mariadb']['username'],
        :password => node['vcczw']['mariadb']['password'],
        :database => node['vcczw']['mariadb']['database'],
        :host     => node['mariadb']['bind_address']
    )
    notifies :run, 'execute[mysql-create-user]', :immediately
end

#wp-cli setting
wp_cli_command 'core download' do
  args(
    'path' => node['vcczw']['wpcli']['path'],
    'locale' => node['vcczw']['wpcli']['locale'],
    'version' => node['vcczw']['wpcli']['version'],
    'force' => '',
    'allow-root' => ''
  )
end
file '/var/www/wordpress/wp-config.php' do
  action :delete
  backup false
end
wp_cli_command 'core config' do
  args(
    'path' => node['vcczw']['wpcli']['path'],
    'dbname' => node['vcczw']['mariadb']['database'],
    'dbuser' => node['vcczw']['mariadb']['username'],
    'dbpass' => node['vcczw']['mariadb']['password'],
    'dbhost' => node['mariadb']['bind_address'],
    'dbprefix' => node['vcczw']['wpcli']['prefix'],
    'locale' => node['vcczw']['wpcli']['locale'],
    'allow-root' => ''
  )
  stdin " --extra-php <<PHP
define( 'WP_HOME', 'http://#{node['vcczw']['apache']['server_name']}/' );
PHP"
end
wp_cli_command 'core install' do
  args(
    'path' => node['vcczw']['wpcli']['path'],
    'url' => "http://#{node['vcczw']['apache']['server_name']}/",
    'title' => node['vcczw']['wpcli']['title'],
    'admin_user' => node['vcczw']['wpcli']['admin_user'],
    'admin_password' => node['vcczw']['wpcli']['admin_password'],
    'admin_email' => node['vcczw']['wpcli']['admin_email'],
    'allow-root' => ''
  )
end
node['vcczw']['wpcli']['plugins'].each do |plugin|
  wp_cli_command "plugin install #{plugin}" do
    args(
      'path' => node['vcczw']['wpcli']['path'],
      'activate' => '',
      'allow-root' => ''
    )
  end
end
wp_cli_command 'plugin activate wp-multibyte-patch' do
  args(
    'path' => node['vcczw']['wpcli']['path'],
    'allow-root' => ''
  )
end
wp_cli_command 'rewrite structure '+node['vcczw']['wpcli']['rewrite'] do
  args(
    'path' => node['vcczw']['wpcli']['path'],
    'allow-root' => ''
  )
end
options = {
  'blogdescription' => '"'+node['vcczw']['wpcli']['blogdescription']+'"',
  'show_admin_bar_fron' => false
}
options.each do |key, value|
  wp_cli_command "option update #{key.to_s} #{value.to_s}" do
    args(
      'path' => node['vcczw']['wpcli']['path'],
      'allow-root' => ''
    )
  end
end
wp_cli_command 'scaffold _s vcczw' do
  args(
    'path' => node['vcczw']['wpcli']['path'],
    'force' => '',
    'allow-root' => ''
  )
end
