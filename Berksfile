source "https://supermarket.chef.io"

#community cookbooks
#公式のcookbook(https://supermarket.chef.io)やgithubにあるcookbookを利用する時は以下に記述する
cookbook 'apache2', '~> 3.1.0'
cookbook 'mariadb', github: 'joerocklin/chef-mariadb', ref: 'v2.1.1'
cookbook 'ruby_build'
cookbook 'rbenv', github: 'fnichol/chef-rbenv', ref: 'v0.8.1'
cookbook 'php', '~> 1.6.1'
cookbook 'composer', '~> 2.2.0'
cookbook 'wp-cli', '~> 0.1.4'
cookbook 'nodejs', '~> 2.4.2'

#original cookbooks
#自前のクックブックは以下に記述する
#修正する場合は./provision/site-cookbooks/以下のそれぞれのcookbookを修正したのち「$ berks vendor ./provision/cookbooks」を実行
cookbook 'base',  path: './provision/site-cookbooks/base'
