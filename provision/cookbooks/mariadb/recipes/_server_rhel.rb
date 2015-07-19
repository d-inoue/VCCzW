# require 'pry'

node['mariadb']['server']['packages'].each do |name|
  package name do
    action :install
  end
end

#----
node['mariadb']['server']['directories'].each do |_key, value|
  directory value do
    owner     'mysql'
    group     'mysql'
    mode      '0755'
    action    :create
    recursive true
  end
end

directory node['mariadb']['data_dir'] do
  owner     'mysql'
  group     'mysql'
  action    :create
  recursive true
end

#----
template 'initial-my.cnf' do
  path '/etc/my.cnf'
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :start, 'service[mysql]', :immediately
end

# hax
service 'mysql' do
  service_name node['mariadb']['server']['service_name']
  action :nothing
end

cmd = assign_root_password_cmd
execute 'assign-root-password' do
  command cmd
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template '/etc/mysql_grants.sql' do
  source 'grants.sql.erb'
  owner  'root'
  group  'root'
  mode   '0600'
  action :create
  notifies :run, 'execute[install-grants]', :immediately
end

cmd = install_grants_cmd
execute 'install-grants' do
  command cmd
  action :nothing
  notifies :restart, 'service[mysql]', :immediately
end

#----
template 'final-my.cnf' do
  path '/etc/my.cnf'
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[mysql]', :immediately
end

service 'mysql' do
  service_name node['mariadb']['server']['service_name']
  supports     status: true, restart: true, reload: true
  action       [:enable, :start]
end
