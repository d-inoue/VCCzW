default['mariadb']['server_root_password'] = 'wordpress'

default['vcczw']['apache']['port'] = '80'
default['vcczw']['apache']['port-ssl'] = '443'
default['vcczw']['apache']['server_name'] = 'www.vcczw.local'
default['vcczw']['apache']['docroot_dir'] = '/var/www/wordpress'
default['vcczw']['apache']['allow_override'] = 'All'
default['vcczw']['apache']['name'] = 'vcczw'
default['vcczw']['apache']['name-ssl'] = 'vcczw-ssl'

default['vcczw']['apache']['phpmyadmin']['port'] = '80'
default['vcczw']['apache']['phpmyadmin']['port-ssl'] = '443'
default['vcczw']['apache']['phpmyadmin']['server_name'] = 'phpmyadmin.vcczw.local'
default['vcczw']['apache']['phpmyadmin']['docroot_dir'] = '/usr/share/phpMyAdmin/'
default['vcczw']['apache']['phpmyadmin']['allow_override'] = 'All'
default['vcczw']['apache']['phpmyadmin']['name'] = 'phpmyadmin'
default['vcczw']['apache']['phpmyadmin']['name-ssl'] = 'phpmyadmin-ssl'

default['vcczw']['mariadb']['database'] = 'vcczw'
default['vcczw']['mariadb']['username'] = 'vagrant'
default['vcczw']['mariadb']['password'] = 'vcczw'

default['vcczw']['wpcli']['path'] = '/var/www/wordpress/'
default['vcczw']['wpcli']['locale'] = 'ja'
default['vcczw']['wpcli']['version'] = 'latest'
default['vcczw']['wpcli']['prefix'] = 'wp_'
default['vcczw']['wpcli']['title'] = 'VCCZW'
default['vcczw']['wpcli']['admin_user'] = 'vagrant'
default['vcczw']['wpcli']['admin_password'] = 'vcczw'
default['vcczw']['wpcli']['admin_email'] = 'vcczw@example.com'
default['vcczw']['wpcli']['plugins'] = %w[contact-form-7 wp-total-hacks dynamic-hostname]
default['vcczw']['wpcli']['rewrite'] = '%postname%'
default['vcczw']['wpcli']['blogdescription'] = 'Hello VCCZW!'
default['vcczw']['wpcli']['theme'] = 'https://github.com/d-inoue/GB-w/archive/master.zip'
