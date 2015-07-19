#
# Cookbook Name:: mariadb
# Attributes:: client
#
# Copyright 2008-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include Opscode helper in Node class to get access
# to debian_before_squeeze? and ubuntu_before_lucid?
::Chef::Node.send(:include, Opscode::Mysql::Helpers)

case node['platform_family']
when 'rhel'
  default['mariadb']['client']['packages'] = %w(MariaDB-client MariaDB-devel)
when 'fedora'
  default['mariadb']['client']['packages'] = %w(mariadb mariadb-devel)
when 'suse'
  default['mariadb']['client']['packages'] = %w(mariadb-community-server-client libmariadbclient-devel)
when 'debian'
  default['mariadb']['client']['packages'] = %w(mariadb-client libmariadbclient-dev)
when 'freebsd'
  default['mariadb']['client']['packages'] = %w(mariadb55-client)
when 'windows'
  default['mariadb']['client']['version']      = '6.0.2'
  default['mariadb']['client']['arch']         = 'win32' # force 32 bit to work with mariadb gem
  default['mariadb']['client']['package_file'] = "mariadb-connector-c-#{mariadb['client']['version']}-#{mariadb['client']['arch']}.msi"
  default['mariadb']['client']['url']          = "http://www.mariadb.com/get/Downloads/Connector-C/#{mariadb['client']['package_file']}/from/http://mariadb.mirrors.pair.com/"
  default['mariadb']['client']['packages']     = ["MariaDB Connector C #{mariadb['client']['version']}"]

  default['mariadb']['client']['basedir']      = "#{ENV['SYSTEMDRIVE']}\\Program Files (x86)\\MariaDB\\#{mariadb['client']['packages'].first}"
  default['mariadb']['client']['lib_dir']      = "#{mariadb['client']['basedir']}\\lib/opt"
  default['mariadb']['client']['bin_dir']      = "#{mariadb['client']['basedir']}\\bin"
  default['mariadb']['client']['ruby_dir']     = RbConfig::CONFIG['bindir']
when 'mac_os_x'
  default['mariadb']['client']['packages'] = %w(mariadb-connector-c)
else
  default['mariadb']['client']['packages'] = %w(mariadb-client libmariadbclient-dev)
end
