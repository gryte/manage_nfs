# # encoding: utf-8

# Inspec test for recipe manage_nfs::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# firewalld service is enabled and running
describe service('firewalld') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# iptables is configured
describe iptables(chain: 'INPUT_direct') do
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 2049 -m comment --comment nfs-tcp -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p udp -m multiport --dports 2049 -m comment --comment nfs-udp -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 111 -m comment --comment rpcbind-sunrpc-tcp -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p udp -m multiport --dports 111 -m comment --comment rpcbind-sunrpc-udp -j ACCEPT') }
  it { should have_rule('-A INPUT_direct -p tcp -m tcp -m multiport --dports 22 -m comment --comment ssh -j ACCEPT') }
end

# nfs-server service is enabled and running
describe service('nfs-server') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# rpcbind service is enabled and running
describe service('rpcbind') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# exports file has desired contents listed
describe file('/etc/exports') do
  it { should exist }
  #its('content') { should match ".*/tmp 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)\s127.0.0.2(rw,sync,no_root_squash,no_subtree_check)*" }
  its('content') { should match '.*/tmp 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)*' }
  its('content') { should match '.*/var 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)*' }
end

# exportfs command should not return error
describe command('sudo exportfs -rav') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match 'exporting 127.0.0.1:/var\nexporting 127.0.0.1:/tmp\nexporting 127.0.0.2:/tmp' }
end
