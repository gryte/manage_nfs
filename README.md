# manage-nfs
This cookbook will install and configure NFS directories. Currently the supported OS is CentOS 7.

## What does it do?

1. Installs nfs utilities
- enables and starts rpcbind service
- enables and starts nfs server
- creates `/etc/exports` file
- exports directories
- configures firewalld for nfs
*more details to come*
