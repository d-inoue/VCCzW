
#----

group 'mariadb' do
  action :create
end

user 'mariadb' do
  comment 'MySQL Server'
  gid     'mariadb'
  system  true
  home    node['mariadb']['data_dir']
  shell   '/sbin/nologin'
end

node['mariadb']['server']['packages'].each do |name|
  package name do
    action   :install
    notifies :start, 'service[mysql]', :immediately
  end
end

#----

execute 'mysql-install-db' do
  command     "mysql_install_db --verbose --user=`whoami` --basedir=\"$(brew --prefix mysql)\" --datadir=#{node['mariadb']['data_dir']} --tmpdir=/tmp"
  environment('TMPDIR' => nil)
  action      :run
  creates     "#{node['mariadb']['data_dir']}/mysql"
end

# set the root password for situations that don't support pre-seeding.
# (eg. platforms other than debian/ubuntu & drop-in mysql replacements)
execute 'assign-root-password mac_os_x' do
  command %("#{node['mariadb']['mysqladmin_bin']}" -u root password '#{node['mariadb']['server_root_password']}')
  action :run
  only_if %("#{node['mariadb']['mysql_bin']}" -u root -e 'show databases;')
end

#----
