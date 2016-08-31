default['iptables']['packages'] = %w(iptables iptables-persistent)

default['iptables']['rules_ipv4'] = '/etc/iptables/rules.v4'
default['iptables']['rules_ipv6'] = '/etc/iptables/rules.v6'

default['iptables']['rules'] = [
    '-A INPUT -i eth0 -j ACCEPT',
]

# latest stable package release
case lsb['release']
when '14.04'
    default['iptables']['version'] = '1.4.21-1ubuntu1'
when '16.04'
    default['iptables']['version'] = '3.0.6'
end
