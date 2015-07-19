This cookbook includes support for running tests via Test Kitchen (1.0). This has some requirements.

1. You must be using the Git repository, rather than the downloaded cookbook from the Chef Community Site.
2. You must have Vagrant 1.1 installed.
3. You must have a "sane" Ruby 2.1.x environment.

Once the above requirements are met, install the additional requirements:

    gem install berkshelf

Install Test Kitchen.

    gem install test-kitchen

Install the Vagrant driver for Test Kitchen.

    gem install kitchen-vagrant

Once the above are installed, you should be able to run Test Kitchen:

    kitchen list
    kitchen test
