#
# Cookbook Name:: base-box-prep
# Recipe:: default
#
# Copyright 2013
#

# The default vagrant base boxes come with some packages installed which depend
# on mariadb. Since installing mariadb involves replacing libmysql pieces, this
# fails on some platforms. For the purposes of testing, we'll just uninstall
# various packages which conflict.
package 'postfix' do
  action :remove
end
