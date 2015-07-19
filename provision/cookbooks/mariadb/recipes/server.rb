#
# Cookbook Name:: mariadb
# Recipe:: default
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
::Chef::Recipe.send(:include, Opscode::Mysql::Helpers)

include_recipe 'mariadb::client'

if Chef::Config[:solo]
  missing_attrs = %w(
    server_debian_password
    server_root_password
    server_repl_password
  ).select { |attr| node['mariadb'][attr].nil? }.map { |attr| "node['mariadb']['#{attr}']" }

  unless missing_attrs.empty?
    Chef::Application.fatal! "You must set #{missing_attrs.join(', ')} in chef-solo mode." \
    ' For more information, see https://github.com/joerocklin/chef-mariadb#chef-solo-note'
  end
else
  # generate all passwords
  node.set_unless['mariadb']['server_debian_password'] = secure_password
  node.set_unless['mariadb']['server_root_password']   = secure_password
  node.set_unless['mariadb']['server_repl_password']   = secure_password
  node.save
end

unless node['mariadb']['replication']['master'].nil? && node['mariadb']['replication']['slave'].nil?
  missing_attrs = %w(user).select { |attr| node['mariadb']['replication'][attr].nil? }.map { |_attr| "node['mariadb']['replication']" }

  unless missing_attrs.empty?
    Chef::Application.fatal!('You must set for the replication')
  end

  if node['mariadb']['replication']['secret'].nil?
    node.default['mariadb']['replication']['secret'] = node['mariadb']['server_repl_password']
  end

  if node['mariadb']['tunable']['server_id'].nil?
    node.default['mariadb']['tunable']['log_bin'] = node['hostname'] if node['mariadb']['tunable']['log_bin'].nil?
    node.default['mariadb']['tunable']['binlog_format'] = 'MIXED'
    node.default['mariadb']['tunable']['server_id'] = (node['macaddress'].gsub(/:/, '').to_i(16) % (2**32 - 1)).to_s(10)
  end
end

case node['platform_family']
when 'rhel', 'fedora'
  include_recipe 'mariadb::_server_rhel'
when 'debian'
  include_recipe 'mariadb::_server_debian'
when 'mac_os_x'
  include_recipe 'mariadb::_server_mac_os_x'
when 'windows'
  include_recipe 'mariadb::_server_windows'
end

# The data directory _should_ exist at this point. This makes absolutely
# sure that it is, so the replication script installation below can't fail
directory node['mariadb']['data_dir'] do
  owner     'mysql'
  group     'mysql'
  action    :create
  recursive true
end

template "#{node['mariadb']['data_dir']}/replication_master_script" do
  source 'replication_master_script.erb'
  owner 'root' unless platform? 'windows'
  group node['mariadb']['root_group'] unless platform? 'windows'
  mode '0600'
  only_if { node['mariadb']['replication']['master'] == true }
end

template "#{node['mariadb']['data_dir']}/replication_slave_script" do
  source 'replication_slave_script.erb'
  owner 'root' unless platform? 'windows'
  group node['mariadb']['root_group'] unless platform? 'windows'
  mode '0600'
  only_if { node['mariadb']['replication']['slave'] == true }
end
