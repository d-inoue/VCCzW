require 'yaml'
_conf = YAML.load_file('/vagrant/config.yml')

name 'config'
description 'Cookbooks User Set Up'
run_list(
   'recipe[apache2]',
   'recipe[apache2::mod_rewrite]',
   'recipe[apache2::mod_php5]',
   'recipe[mariadb::client]',
   'recipe[mariadb::server]',
   'recipe[ruby_build]',
   'recipe[rbenv::system]',
   'recipe[php]',
   'recipe[composer]',
   'recipe[wp-cli]',
   'recipe[nodejs]',
   'recipe[base]',
)
default_attributes(
  'apache' => {
    'listen_ports' => _conf['apache']['port'],
    'docroot_dir'  => _conf['document_root'],
    'user'         => _conf['user'],
    'group'        => _conf['group'],
    'default_site_enabled' => true
  },
  'rbenv' => {
    'rubies'  => _conf['rubies'],
    'global'  => _conf['ruby_global'],
    'gems'    => {
      '2.2.2'    => [
        {'name'    => 'bundler'},
        {'name'    => 'rbenv-rehash'},
        {'name'    => 'sass'},
        {'name'    => 'wordmove'},
        #{'name'    => 'hoge','version'=>'1.0'}
      ]
    }
  },
  'mariadb' => {
    'server_root_password'    => 'wordpress',
    'server_repl_password'    => 'wordpress',
    'server_debian_password'  => 'wordpress',
    'bind_address'            => 'localhost',
    'remove_test_database'    =>true
  },
  'php' => {
    'packages' => %w[php-devel php-mbstring php-gd php-xml php-pear],
    'directives' => {
      'default_charset'            => 'UTF-8',
      'mbstring.language'          => 'neutral',
      'mbstring.internal_encoding' => 'UTF-8',
      'date.timezone'              => 'UTC',
      'short_open_tag'             => 'Off',
      'session.save_path'          => '/tmp'
    }
  },
  'nodejs' => {
    #'install_method' => 'source',
    'version' => _conf['nodejs']['version'],
    'npm_packages' => [
      {'name'     =>      'grunt'},
      {'name'     =>      'grunt-cli'},
      {'name'     =>      'grunt-init'},
      {'name'     =>      'gulp'},
      #{'name'    => 'hoge','version'=>'1.0', 'user' => 'random'} default global install
    ]
  },
  'vcczw' => {
    'apache' => {
      'server_name' => _conf['domain_name'][0],
      'docroot_dir' => _conf['document_root'],
      'phpmyadmin' => {
        'server_name'  => _conf['domain_name'][1],
        'docroot_dir'  => _conf['phpmyadmin_folder']
      }
    },
    'mariadb' => {
      'database' => _conf['mariadb']['database'],
      'username' => _conf['mariadb']['username'],
      'password' => _conf['mariadb']['password']
    },
    'wpcli' => {
      'path'            => _conf['document_root'],
      'locale'          => _conf['wpcli']['locale'],
      'version'         => _conf['wpcli']['version'],
      'prefix'          => _conf['wpcli']['prefix'],
      'wp_home'         => _conf['wpcli']['wp_home'],
      'title'           => _conf['wpcli']['title'],
      'admin_user'      => _conf['wpcli']['admin_user'],
      'admin_password'  => _conf['wpcli']['admin_password'],
      'admin_email'     => _conf['wpcli']['admin_email'],
      'plugins'         => _conf['wpcli']['plugins'],
      'rewrite'         => _conf['wpcli']['rewrite'],
      'blogdescription' => _conf['wpcli']['blogdescription'],
      'theme'           => _conf['wpcli']['theme']
    }
  }
)