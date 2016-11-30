#
# Cookbook Name:: cop_iptables
# Recipe:: default
# Author:: Copious Inc. <engineering@copiousinc.com>
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Copious Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

node['iptables']['packages'].each do |p|
    package p do
        # NOTE: upgrade whenever possible
        action :upgrade
    end
end

rules = node['iptables']['rules']
# NOTE: abort chef run if rules doesnt exist or is an empty string, this is to prohibit
# ourselves from being locked out of ssh access
Chef::Application.fatal!("No iptable rules set, aborting Chef run to prohibit lockout.") unless rules && rules != ''

template 'create iptables rules' do
    path     node['iptables']['rule_file']
    source   'iptables.rules.erb'
    cookbook 'cop_iptables'
    group    'root'
    owner    'root'
    mode     0644
    backup   false
    action   :create
end

file '/etc/cron.d/iptables-restore' do
    content "@reboot root iptables-restore < #{node['iptables']['rule_file']}"
    group   'root'
    owner   'root'
    mode    0644
    backup  false
    action  :create
end

execute 'import iptable rules' do
    subscribes :run, 'template[create iptables rules]', :immediately
    command    "iptables-restore < #{node['iptables']['rule_file']}"
    action     :nothing
end
