#    manage exports file
#
# If set to true, then the cookbook will update the file
# /etc/exports based on the nfs_server vault item which requires a
# chef vault 'nfs_exports'. Please see test/integration/data_bags/nfs_exports for an
# example.
#
default['nfs_exports']['config'] = false
default['nfs_exports']['nfs_server'] = ''
