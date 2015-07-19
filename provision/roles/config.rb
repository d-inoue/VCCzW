name "config"
description "Cookbooks User Info"
run_list(
   "recipe[apache2]",
   "recipe[apache2::mod_php5]",
   "recipe[apache2-ex]",
   "recipe[mariadb::client]",
   "recipe[mariadb::server]",
   "recipe[php]",
   "recipe[phpmyadmin-ex]",
)
default_attributes(
  "apache" => {
    "listen_ports" => ["80", "443"],
    "docroot_dir"  => "/var/www/wordpress",
    "user"         => "vagrant",
    "group"        => "vagrant",
    "default_site_enabled" => true
  },
  "apache-ex" => {
    "hostname"  => "vcczw.dev",
    "docroot_dir" => "/var/www/wordpress",
    "allow_override" => "All"
  },
  "mariadb" => {
    "server_root_password" => "vcczw",
    "server_repl_password" => "vcczw",
    "server_debian_password" => "vcczw",
    "remove_test_database" =>true
  },
  "php" => {
    "packages" => %w(php-devel php-mbstring php-gd php-xml php-pear),
    "directives" => {
      "default_charset"            => "UTF-8",
      "mbstring.language"          => "neutral",
      "mbstring.internal_encoding" => "UTF-8",
      "date.timezone"              => "UTC",
      "short_open_tag"             => "Off",
      "session.save_path"          => "/tmp"
    }
  },
   "phpmyadmin-ex" => {
    "hostname"  => "phpmyadmin.vcczw.dev",
    "docroot_dir" => "/usr/share/phpMyAdmin/",
    "allow_override" => "All"
  },
)