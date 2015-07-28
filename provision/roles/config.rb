name 'config'
description 'Cookbooks User Info'
run_list(
   'recipe[apache2]',
   'recipe[apache2::mod_php5]',
   'recipe[apache2::mod_rewrite]',
   'recipe[mariadb::client]',
   'recipe[mariadb::server]',
   'recipe[php]',
   'recipe[wordpress]',
   'recipe[base]',
)
default_attributes(
  'apache' => {
    'listen_ports' => ['80', '443'],
    'docroot_dir'  => '/var/www/wordpress',
    'user'         => 'vagrant',
    'group'        => 'vagrant',
    'default_site_enabled' => true
  },
  # 'rbenv' => {
  #   'rubies'  => ['2.2.2'],
  #   'global'  => '2.2.2',
  #   'gems'    => {
  #     '2.2.2'    => [
  #       {'name'    => 'bundler'},
  #       {'name'    => 'rbenv-rehash'},
  #       {'name'    => 'sass'},
  #       #{'name'=>'hoge','version'=>'1.0'}
  #     ]
  #   }
  # },
  'mariadb' => {
    'server_root_password' => 'vcczw',
    'server_repl_password' => 'vcczw',
    'server_debian_password' => 'vcczw',
    'bind_address' => 'localhost',
    'remove_test_database' =>true
  },
  'php' => {
    'packages' => %w(php-devel php-mbstring php-gd php-xml php-pear),
    'directives' => {
      'default_charset'            => 'UTF-8',
      'mbstring.language'          => 'neutral',
      'mbstring.internal_encoding' => 'UTF-8',
      'date.timezone'              => 'UTC',
      'short_open_tag'             => 'Off',
      'session.save_path'          => '/tmp'
    }
  },
  'wordpress' => {
    'version' => 'latest',
    'dir' => '/var/www/wordpress',
    'db' => {
      'root_password'            => 'vcczw',
      'instance_name'            => 'root',
      'name'            => 'vcczw',
      'user'          => 'vagrant',
      'pass' => 'vcczw',
      'prefix'              => 'wp_',
    }
  },
)