#
# Cookbook:: manage_nfs
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# enable platform default firewall
firewall 'default' do
  action :install
end

# open ports for nfs
firewall_rule 'nfs-tcp' do
  protocol :tcp
  port 2049
  command :allow
end

firewall_rule 'nfs-udp' do
  protocol :udp
  port 2049
  command :allow
end

# open ports for rpcbind/sunrpc
firewall_rule 'rpcbind-sunrpc-tcp' do
  protocol :tcp
  port 111
  command :allow
end

firewall_rule 'rpcbind-sunrpc-udp' do
  protocol :udp
  port 111
  command :allow
end

# open port for ssh connections
firewall_rule 'ssh' do
  port 22
  command :allow
end

# install nfs utilities
package 'nfs-utils' do
  action :upgrade
  notifies :restart, 'service[nfs-server]'
  notifies :restart, 'service[rpcbind]'
end

# nfs-server service
service 'nfs-server' do
  action :enable
end

# rpcbind service
service 'rpcbind' do
  action :enable
end
