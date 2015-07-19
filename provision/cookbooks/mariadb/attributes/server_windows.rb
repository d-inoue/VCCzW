case node['platform_family']
when 'windows'
  default['mariadb']['windows']['version']            = '5.5.34'
  default['mariadb']['windows']['arch']               = node['kernel']['machine'] == 'x86_64' ? 'winx64' : 'win32'
  default['mariadb']['windows']['package_file']       = "mysql-#{node['mariadb']['windows']['version']}-#{node['mariadb']['windows']['arch']}.msi"
  default['mariadb']['windows']['packages']           = ['MySQL Server 5.5']
  default['mariadb']['windows']['url']                = "http://dev.mysql.com/get/Downloads/MySQL-5.5/#{node['mariadb']['windows']['package_file']}"

  default['mariadb']['windows']['programdir']         = node['kernel']['machine'] == 'x86_64' ? 'Program Files' : 'Program Files (x86)'
  default['mariadb']['windows']['basedir']            = "#{ENV['SYSTEMDRIVE']}\\#{node['mariadb']['windows']['programdir']}\\MySQL\\#{node['mariadb']['windows']['packages'].first}"
  default['mariadb']['windows']['data_dir']           = "#{ENV['ProgramData']}\\MySQL\\#{node['mariadb']['windows']['packages'].first}\\Data"
  default['mariadb']['windows']['bin_dir']            = "#{node['mariadb']['windows']['basedir']}\\bin"
  default['mariadb']['windows']['mysqladmin_bin']     = "#{node['mariadb']['windows']['bin_dir']}\\mysqladmin"
  default['mariadb']['windows']['mysql_bin']          = "#{node['mariadb']['windows']['bin_dir']}\\mysql"

  default['mariadb']['windows']['conf_dir']           = node['mariadb']['windows']['basedir']
  default['mariadb']['windows']['old_passwords']      = 0
  default['mariadb']['windows']['grants_path']        = "#{node['mariadb']['windows']['conf_dir']}\\grants.sql"

  default['mariadb']['server']['service_name']        = 'mariadb'
  default['mariadb']['server']['slow_query_log']      = 1
end
