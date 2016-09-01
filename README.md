# iptables Cookbook
This cookbook will install and configure iptables for **IPv4**. This cookbook
only supports Ubuntu 14.04 and 16.04.

**Warning**: Without setting any iptable rules, this cookbook will fail by default.
This is to prohibit iptables from locking us out.  Ensure you can access the node
after a Chef run by adding a rule to allow 22/tcp on all interfaces. See the
first example under Usage.

## Requirements
### Platforms
- Ubuntu 14.04
- Ubuntu 16.04

### Chef
- Chef '>= 12.5'

## Attributes
You can set custom rules via the `rules` attribute.

`default['iptables']['rules']`

## Usage
Here's an `iptables` role that will install and configure iptables.

Including the `cop_iptables` cookbook in the run_list ensures that iptables
will be installed. Use the `default['iptables']['rules']` attribute to merge
your rules with the cookbook template.

In this example the first rule will allow all traffic on all interfaces. The
second and third rules are allowing traffic over port `22/tcp` and `80/tcp` on
all interfaces as well.

You can get a list of interfaces by using the `$ ifconfig` command on your host.

```ruby
name 'iptables'
description 'iptables'

override_attributes(
    'iptables' => {
        'rules' => [
            '-A INPUT -j ACCEPT',
            '-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT',
            '-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT',
        ]
    }
)

run_list(
    'recipe[cop_iptables::default]'
)
```

In this example the first rule will allow all traffic on the `eth0` interface,
which is usually the LAN interface. The second and third rules are allowing
traffic over port `22/tcp` and `80/tcp` on the `eth1` or WAN interface.

The lesson here is that if you specify an interface with `-i <interface`, that
rule will only apply to that interface. You will need to think about how traffic
is coming in and out of your network.

```ruby
override_attributes(
    'iptables' => {
        'rules' => [
            '-A INPUT -i eth0 -j ACCEPT',
            '-A INPUT -i eth1 -p tcp -m tcp --dport 22 -j ACCEPT',
            '-A INPUT -i eth1 -p tcp -m tcp --dport 80 -j ACCEPT',
        ]
    }
)
```

## Testing
* http://kitchen.ci
* http://serverspec.org

Testing is handled with ServerSpec, via Test Kitchen, which uses Vagrant to spin up VMs.

ServerSpec and Test Kitchen are bundled in the ChefDK package.

### Dependencies
```bash
$ brew cask install chefdk
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
