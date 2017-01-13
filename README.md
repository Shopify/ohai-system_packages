# Packages

This [OHAI](https://github.com/opscode/ohai) plugin will use your package manager to see which packages are currently installed and which are upgradeable together with their current version and the possible new version which would get installed on a full upgrade run.

# Supported platforms

## Debian family (Debian, Ubuntu, Linux Mint)

The data retrieval mechanism is influenced from [apt-dater-host](http://packages.debian.org/search?keywords=apt-dater-host) which provides a similar service to network clients. We require an installed and correctly configured `apt-get` and `dpkg`, which is given on any reasonably setup system.

You should use this plugin together with the [apt cookbook](https://github.com/opscode-cookbooks/apt) to ensure a proper setup and timely updates of the packages sources. As such, this plugin should generally be loaded *after* the apt cookbook to ensure the package cache is up-to-date.

# Installing

You should use the [ohai cookbook](https://github.com/opscode-cookbooks/ohai) to install this plugins. Then you can add this cookbook to the node's runlist and add this configuration to the node (or role):

    ohai_plugin 'ohai-system_packages' do
      source_file 'ohai-system_packages.rb'
      cookbook 'ohai-system_packages'
    end

# Using

This plugin provides `system_packages` to OHAI. It has three sub-sections:

    {
      'system_packages': {
        'upgradeable': {
          'apache2': '2.2.16-6+squeeze7'
        },
        'installed': {
          'apache2': {
            'version': '2.2.16-6+squeeze5'
            'status': 'installed',
          },
          'nagios3': {
            'version': '2.7.1-1+squeeze1',
            'status': 'half-configured'
          }
        },
        'holding': [
          'linux-image-2.6'
        ]
      }
    }

The `installed` section lists all currently installed packages together with their current version number and their status. This status is dependent on the operating system family used. On Debian-like systems, it should normally be `'installed'`. If it is something other, things might be broken (e.g. when the package manager couldn't finish configuration).

The `upgradeable` section lists all packages which could be upgraded with a `apt-get dist-upgrade` together with the versions they would be upgraded to.

Finally, the `holding` section contains an array of all the package names that are set to hold and are not automatically upgraded.

# Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
4. Create new Pull Request

# License

This code is licensed under the MIT License. Copyright (c) 2012 Finn GmbH
