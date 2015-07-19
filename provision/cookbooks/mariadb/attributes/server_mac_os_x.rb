case node['platform_family']
when 'mac_os_x'
  default['mariadb']['server']['packages']      = %w(mariadb)
  default['mariadb']['basedir']                 = '/usr/local/Cellar'
  default['mariadb']['data_dir']                = '/usr/local/var/mysql'
  default['mariadb']['root_group']              = 'admin'
  default['mariadb']['mysqladmin_bin']          = '/usr/local/bin/mysqladmin'
  default['mariadb']['mysql_bin']               = '/usr/local/bin/mysql'
end
