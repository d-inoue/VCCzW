#
# Cookbook Name:: base
# Recipe:: wpcli
#
# Copyright 2015, dinoue
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'wp-cli'

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
# wp_cli_command 'theme install '+node['vcczw']['wpcli']['theme'] do
#   args(
#     'path' => node['vcczw']['wpcli']['path'],
#     #'activate' => '',
#     'allow-root' => ''
#   )
# end
