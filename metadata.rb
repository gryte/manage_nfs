name 'manage_nfs'
maintainer 'Adam Linkous'
maintainer_email 'alinkous+support@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures manage_nfs'
long_description 'Installs/Configures manage_nfs'
version '0.2.2'
supports 'centos'
chef_version '>= 12.19' if respond_to?(:chef_version)
issues_url 'https://github.com/gryte/manage_nfs/issues' if respond_to?(:issues_url)
source_url 'https://github.com/gryte/manage_nfs' if respond_to?(:source_url)

depends 'firewall', '~> 2.7.0'
depends 'chef-vault', '~> 3.1.1'
