default['vcczw']['apache']['port'] = "80"
default['vcczw']['apache']['port-ssl'] = "443"
default['vcczw']['apache']['server_name'] = 'vcczw.dev'
default['vcczw']['apache']['docroot_dir'] = '/var/www/wordpress'
default['vcczw']['apache']['allow_override'] = 'All'
default['vcczw']['apache']['name'] = 'vcczw'
default['vcczw']['apache']['name-ssl'] = 'vcczw-ssl'

default['vcczw']['apache']['phpmyadmin']['port'] = "80"
default['vcczw']['apache']['phpmyadmin']['port-ssl'] = "443"
default['vcczw']['apache']['phpmyadmin']['server_name'] = 'phpmyadmin.vcczw.dev'
default['vcczw']['apache']['phpmyadmin']['docroot_dir'] = '/usr/share/phpMyAdmin/'
default['vcczw']['apache']['phpmyadmin']['allow_override'] = 'All'
default['vcczw']['apache']['phpmyadmin']['name'] = 'phpmyadmin'
default['vcczw']['apache']['phpmyadmin']['name-ssl'] = 'phpmyadmin-ssl'

default['vcczw']['mariadb']['database'] = 'vcczw'
default['vcczw']['mariadb']['username'] = 'vagrant'
default['vcczw']['mariadb']['password'] = 'vcczw'