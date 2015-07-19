#
# Cookbook Name:: mariadb
# Recipe:: mariadb_repo
#
# Copyright 2012, Myplanet Digital, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'mariadb' do
    uri "http://ftp.osuosl.org/pub/mariadb/repo/#{node['mariadb']['version']}/#{node['platform']}"
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key '0xcbcb082a1bb943db'
    action :add
  end

when 'rhel'
  include_recipe 'yum'

  arch = node['kernel']['machine']
  # Fedora reports the architecture as 'x86_64'
  arch = 'amd64' if arch == 'x86_64'
  arch = 'x86' unless arch == 'amd64'
  pversion = node['platform_version'].split('.').first
  platform = node['platform']

  system_string = "#{platform}#{pversion}-#{arch}"

  yum_repository 'mariadb' do
    description 'MariaDB Repository'
    baseurl     "http://yum.mariadb.org/#{node['mariadb']['version']}/#{system_string}"
    gpgkey      'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
  end
when 'fedora'
  # Fedora provides MariaDB as part of the system's default repositories
  # Additionally, MariaDB's amd64 repository has issues on Fedora x86_64
  # https://mariadb.atlassian.net/browse/MDEV-5152
  # So just use the system repositories
end
