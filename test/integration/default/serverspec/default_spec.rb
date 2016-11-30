require 'spec_helper'

describe 'redis::default' do
  describe package('iptables') do
    it { should be_installed }
  end

  describe command('iptables --version') do
    its(:stdout) { should match /1.(4|6).*/ }
  end

  describe file('/etc/sysconfig/iptables'), :if => os[:platform_family] == 'rhel' do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
  end

  describe file('/etc/iptables/rules'), :if => os[:platform_family] == 'debian' do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
  end

  # always drop everything that isnt whitelisted
  describe iptables do
    it { should have_rule('-A INPUT -j DROP') }
  end
end
