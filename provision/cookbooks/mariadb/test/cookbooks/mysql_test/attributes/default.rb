# Must be specified for chef-solo for successful re-converge
override['mariadb']['server_root_password'] = 'ilikerandompasswords'

override['mysql_test']['database'] = 'mysql_test'
override['mysql_test']['username'] = 'test_user'
override['mysql_test']['password'] = 'neshFiapog'

override['mariadb']['bind_address'] = 'localhost'
