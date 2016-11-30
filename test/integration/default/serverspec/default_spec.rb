require 'spec_helper'

describe 'redis::default' do
  describe package('iptables') do
    it { should be_installed }
  end

  describe command('iptables --version') do
    its(:stdout) { should match /1.(4|6).*/ }
  end

  case os[:family]
  when 'redhat', 'fedora'
    describe file('/etc/sysconfig/iptables') do
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode '644' }
    end
  when 'ubuntu', 'debian'
    describe file('/etc/iptables/rules.v4') do
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode '644' }
    end
  end

  # always drop everything that isnt whitelisted
  describe iptables do
    it { should have_rule('-A INPUT -j DROP') }
  end
end
