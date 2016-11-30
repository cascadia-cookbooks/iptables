
case node['platform_family']
when 'debian'
    default['iptables']['service']   = 'iptables-persistent'
    default['iptables']['packages']  = %w(iptables iptables-persistent)
    default['iptables']['rule_file'] = '/etc/iptables/rules.v4'
when 'rhel', 'fedora'
    default['iptables']['service']   = 'iptables'
    default['iptables']['packages']  = %w(iptables)
    default['iptables']['rule_file'] = '/etc/sysconfig/iptables'
end
