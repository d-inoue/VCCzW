case node['platform_family']
when 'fedora'

  # Probably driven from wrapper cookbooks, environments, or roles.
  # Keep in this namespace for backwards compat
  default['mariadb']['data_dir'] = '/var/lib/mysql'

  # Setup the install package and the slow query logging
  default['mariadb']['server']['packages'] = ['mariadb-server']
  default['mariadb']['server']['slow_query_log']       = 1
  default['mariadb']['server']['slow_query_log_file']  = '/var/log/mysql/slow.log'

  # Platformisms.. filesystem locations and such.
  default['mariadb']['server']['basedir'] = '/usr'
  default['mariadb']['server']['tmpdir'] = ['/tmp']

  default['mariadb']['server']['directories']['run_dir']              = '/var/run/mysqld'
  default['mariadb']['server']['directories']['log_dir']              = '/var/lib/mysql'
  default['mariadb']['server']['directories']['slow_log_dir']         = '/var/log/mysql'
  default['mariadb']['server']['directories']['confd_dir']            = '/etc/mysql/conf.d'

  default['mariadb']['server']['mysqladmin_bin']       = '/usr/bin/mysqladmin'
  default['mariadb']['server']['mysql_bin']            = '/usr/bin/mysql'

  default['mariadb']['server']['pid_file']             = '/var/run/mysqld/mysqld.pid'
  default['mariadb']['server']['socket']               = '/var/lib/mysql/mysql.sock'
  default['mariadb']['server']['grants_path']          = '/etc/mysql_grants.sql'
  default['mariadb']['server']['old_passwords']        = 1
  default['mariadb']['server']['service_name']        = 'mariadb'

  # RHEL/CentOS mysql package does not support this option.
  default['mariadb']['tunable']['innodb_adaptive_flushing'] = false
  default['mariadb']['server']['skip_federated'] = false
end
