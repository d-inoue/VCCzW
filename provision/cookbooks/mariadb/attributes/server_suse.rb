case node['platform_family']
when 'suse'
  default['mariadb']['data_dir']                = '/var/lib/mysql'
  default['mariadb']['server']['service_name']            = 'mariadb'
  default['mariadb']['server']['server']['packages']      = %w(mysql-community-server)
  default['mariadb']['server']['basedir']                 = '/usr'
  default['mariadb']['server']['root_group']              = 'root'
  default['mariadb']['server']['mysqladmin_bin']          = '/usr/bin/mysqladmin'
  default['mariadb']['server']['mysql_bin']               = '/usr/bin/mysql'
  default['mariadb']['server']['conf_dir']                = '/etc'
  default['mariadb']['server']['confd_dir']               = '/etc/mysql/conf.d'
  default['mariadb']['server']['socket']                  = '/var/run/mysql/mysql.sock'
  default['mariadb']['server']['pid_file']                = '/var/run/mysql/mysqld.pid'
  default['mariadb']['server']['old_passwords']           = 1
  default['mariadb']['server']['grants_path']             = '/etc/mysql_grants.sql'
end
