case node['platform_family']

when 'freebsd'
  default['mariadb']['data_dir']                = '/var/db/mysql'
  default['mariadb']['server']['packages']      = %w(mysql55-server)
  default['mariadb']['server']['service_name']  = 'mariadb-server'
  default['mariadb']['server']['basedir']       = '/usr/local'
  default['mariadb']['server']['root_group']              = 'wheel'
  default['mariadb']['server']['mysqladmin_bin']          = '/usr/local/bin/mysqladmin'
  default['mariadb']['server']['mysql_bin']               = '/usr/local/bin/mysql'
  default['mariadb']['server']['conf_dir']                = '/usr/local/etc'
  default['mariadb']['server']['confd_dir']               = '/usr/local/etc/mysql/conf.d'
  default['mariadb']['server']['socket']                  = '/tmp/mysqld.sock'
  default['mariadb']['server']['pid_file']                = '/var/run/mysqld/mysqld.pid'
  default['mariadb']['server']['old_passwords']           = 0
  default['mariadb']['server']['grants_path']             = '/var/db/mysql/grants.sql'
end
