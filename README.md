# iptables Cookbook
This cookbook will install and configure iptables for *IPv4*. This cookbook only supports Ubuntu 14.04 and 16.04.

## Requirements
### Platforms
- Ubuntu 14.04
- Ubuntu 16.04

### Chef
- Chef '>= 12.5'

## Attributes
You can set custom rules via the `rules` attribute. The default rule will allow
all traffic on the `eth0` interface, which is usually the LAN interface.

```ruby
# attributes/default.rb
default['iptables']['rules'] = [
    '-A INPUT -i eth0 -j ACCEPT',
]
```

## Usage
Here's an example `iptables` role that will install and configure iptables.

Including it in the run list ensures that iptables is installed. Overriding the
rules attribute will merge your custom rules with the cookbook defaults. In this
example we're allowing traffic over port `22/tcp` and `80/tcp` on the `eth1`
interface.

You can get a list of interfaces by using the `$ ifconfig` command on your host.

```ruby
name 'iptables'
description 'iptables'

override_attributes(
    'iptables' => {
        'rules' => [
            '-A INPUT -i eth1 -p tcp -m tcp --dport 22 -j ACCEPT',
            '-A INPUT -i eth1 -p tcp -m tcp --dport 80 -j ACCEPT',
        ]
    }
)

run_list(
    'recipe[cop_iptables::default]'
)
```

## Testing
* http://kitchen.ci
* http://serverspec.org

Testing is handled with ServerSpec, via Test Kitchen, which uses Docker to spin up VMs.

ServerSpec and Test Kitchen are bundled in the ChefDK package.

### Dependencies
```bash
$ brew cask install chefdk
$ chef gem install kitchen-docker
$ brew install docker docker-machine
$ docker-machine create default --driver virtualbox
```

### Running
Get a listing of your instances with:

```bash
$ kitchen list
```

Run Chef on an instance, in this case default-ubuntu-1204, with:

```bash
$ kitchen converge default-ubuntu-1204
```

Destroy all instances with:

```bash
$ kitchen destroy
```

Run through and test all the instances in serial by running:

```bash
$ kitchen test
```

## Notes
* The `Berksfile.lock` file has been purposely omitted, as we don't care about upstream dependencies.
