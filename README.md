# iptables Cookbook
This cookbook will install and configure iptables for **IPv4**. This cookbook
only supports Ubuntu 14.04 and 16.04.

**WARNING**: Without setting any iptable rules, this cookbook will fail by default.
This is to prohibit iptables from locking us out. Ensure you can access the node
after a Chef run by adding some rules to use. See the first example under Usage.

*NOTE*: The rules template for this cookbook does _not_ block outbound traffic.
Only inbound. If you require blocking outbound traffic, you will need to create
a rule for it.

If you require further documentation:

* http://ipset.netfilter.org/iptables.man.html
* https://www.netfilter.org/documentation/HOWTO//networking-concepts-HOWTO.txt
* https://www.netfilter.org/documentation/HOWTO//packet-filtering-HOWTO.txt
* https://www.centos.org/docs/5/html/Deployment_Guide-en-US/ch-iptables.html

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
Including the `cop_iptables` cookbook in the run_list ensures that iptables
will be installed. Use the `default['iptables']['rules']` attribute to merge
your rules with the cookbook template.

Here's a general `iptables` role that will install and configure iptables. It
will also allow all traffic on all interfaces.

**WARNING**: This is generally considered bad practice, you should be strict in what
is allowed and on which interface(s). See the next example.

```ruby
name 'iptables'
description 'iptables'

override_attributes(
    'iptables' => {
        'rules' => [
            '-A INPUT -j ACCEPT',
        ]
    }
)

run_list(
    'recipe[cop_iptables::default]'
)
```

In this example these two rules are allowing any traffic over port `22/tcp` and `80/tcp` on all interfaces.

You can find a list of ports by service
[here](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers).

*NOTE*: Use these types of rules at the very least. However, it's better to
lock things down by interfaces. See the next example.

```ruby
override_attributes(
    'iptables' => {
        'rules' => [
            '-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT',
            '-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT',
        ]
    }
)
```

In this example the first rule will allow all traffic on the `eth0` interface,
which is usually the LAN interface. The second and third rules are allowing
traffic over port `22/tcp` and `80/tcp` on the `eth1` or WAN interface.
Interfaces can be different depending on which host you use.

*NOTE*: You can get a list of interfaces by using the `$ ifconfig` command on your host.

*NOTE*: When you specify an interface with `-i <interface>`, that rule will only
apply to that interface. You will need to think about how traffic is coming in
and out of your network.

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
