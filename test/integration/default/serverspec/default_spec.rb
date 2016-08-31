require 'spec_helper'

describe 'redis::default' do
  describe package('iptables') do
    it { should be_installed }
  end

  describe command('iptables --version') do
    if os[:release] == '14.04'
      its(:stdout) { should match /1.4.21/ }
    end
    if os[:release] == '16.04'
      its(:stdout) { should match /1.6.0/ }
    end
  end

  describe file('/etc/iptables/rules.v4') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
  end

  # always drop everything that isnt whitelisted
  describe iptables do
    it { should have_rule('-A INPUT -j DROP') }
  end
end
