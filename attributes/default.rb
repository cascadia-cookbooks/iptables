default['iptables']['packages'] = %w(
    iptables
)

case node['platform_family']
when 'debian'
    default['iptables']['rule_file'] = '/etc/iptables/rules'
when 'rhel', 'fedora'
    default['iptables']['rule_file'] = '/etc/sysconfig/iptables'
end
