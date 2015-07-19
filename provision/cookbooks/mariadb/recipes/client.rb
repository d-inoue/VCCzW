#
# Cookbook Name:: mariadb
# Recipe:: client
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

# Include Opscode helper in Recipe class to get access
# to debian_before_squeeze? and ubuntu_before_lucid?
::Chef::Recipe.send(:include, Opscode::Mysql::Helpers)

unless node['mariadb']['disable_repo'] == true
  include_recipe 'mariadb::mariadb_repo'
end

# On RHEL platforms, yum isn't happy to have MariaDB and mysql-libs coexisting
package 'mysql-libs' do
  action :remove
  only_if { node['platform_family'] == 'rhel' }
end

package 'mariadb-libs' do
  action :remove
  only_if { node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7.0 }
end

case node['platform']
when 'windows'
  package_file = node['mariadb']['client']['package_file']
  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source node['mariadb']['client']['url']
    not_if { File.exist? "#{Chef::Config[:file_cache_path]}/#{package_file}" }
  end

  windows_package node['mariadb']['client']['packages'].first do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end
  ENV['PATH'] += ";#{node['mariadb']['client']['bin_dir']}"
  windows_path node['mariadb']['client']['bin_dir'] do
    action :add
  end
  def package(*args, &blk)
    windows_package(*args, &blk)
  end
when 'mac_os_x'
  include_recipe 'homebrew::default'
end

node['mariadb']['client']['packages'].each do |name|
  package name
end

if platform_family?('windows')
  ruby_block 'copy libmysql.dll into ruby path' do
    block do
      require 'fileutils'
      FileUtils.cp "#{node['mariadb']['client']['lib_dir']}\\libmysql.dll", node['mariadb']['client']['ruby_dir']
    end
    not_if { File.exist?("#{node['mariadb']['client']['ruby_dir']}\\libmysql.dll") }
  end
end
