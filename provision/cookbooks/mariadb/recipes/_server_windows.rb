require 'win32/service'

ENV['PATH'] += ";#{node['mariadb']['windows']['bin_dir']}"
package_file = Chef::Config[:file_cache_path] + File::ALT_SEPARATOR + node['mariadb']['windows']['package_file']
install_dir = win_friendly_path(node['mariadb']['windows']['basedir'])

windows_path node['mariadb']['windows']['bin_dir'] do
  action :add
end

remote_file package_file do
  source node['mariadb']['windows']['url']
  not_if { ::File.exist?(package_file) }
end

windows_package node['mariadb']['windows']['packages'].first do
  source package_file
  options "INSTALLDIR=\"#{install_dir}\""
  notifies :run, 'execute[install mysql service]', :immediately
end

template 'my.ini' do
  path "#{node['mariadb']['windows']['bin_dir']}\\my.ini"
  source 'my.ini.erb'
  notifies :restart, 'service[mysql]'
end

execute 'install mysql service' do
  command %("#{node['mariadb']['windows']['bin_dir']}\\mysqld.exe" --install "#{node['mariadb']['server']['service_name']}" --defaults-file="#{node['mariadb']['windows']['bin_dir']}\\my.ini")
  not_if { ::Win32::Service.exists?(node['mariadb']['server']['service_name']) }
end

service 'mariadb' do
  service_name node['mariadb']['server']['service_name']
  action       [:enable, :start]
end

execute 'assign-root-password' do
  command %("#{node['mariadb']['windows']['mysqladmin_bin']}" -u root password #{node['mariadb']['server_root_password']})
  action :run
  # only_if %Q["#{node['mariadb']['windows']['mysql_bin']}" -u root -e 'show databases;'] # unreliable due to CHEF-4783; always returns 0 when run in Chef
  not_if { node['mariadb']['root_password_set'] }
  notifies :run, 'ruby_block[root-password-set]', :immediately
end

ruby_block 'root-password-set' do
  block do
    node.set['mariadb']['root_password_set'] = true
  end
  action :nothing
end

grants_path = node['mariadb']['windows']['grants_path']

template grants_path do
  source 'grants.sql.erb'
  action :create
  notifies :run, 'execute[mysql-install-privileges]', :immediately
end

execute 'mysql-install-privileges' do
  command "\"#{node['mariadb']['windows']['mysql_bin']}\" -u root #{node['mariadb']['server_root_password'].empty? ? '' : '-p' }\"#{node['mariadb']['server_root_password']}\" < \"#{grants_path}\""
  action :nothing
end
