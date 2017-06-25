# manage-nfs
This cookbook will install and configure NFS directories. Currently the supported OS is CentOS 7.

## What does it do?

1. Installs nfs utilities
- enables and starts rpcbind service
- enables and starts nfs server
- creates `/etc/exports` file
- exports directories
- configures firewalld for nfs

## Dependencies

### Chef Vault - nfs_exports

In order to manage the `/etc/exports` file, the attribute `['nfs_exports']['config']` must be set to **true**. Also, the attribute `['nfs_exports']['nfs_server']` must reference an existing Chef Vault item that contains the desired list of remote servers and local file systems in the format specified below.

The json layout is as follows:
- The parent item starts with the **environment**
  - The recipe assumes the local server is assigned to a matching environment in the chef server
  - This allows for *production* and *test* groups of file systems and servers
- The next child item is the **path**
  - Each environment can have multiple _file systems_ or paths specified to be exported as nfs shares
- The next child item is the **server list**
  - Each path specified can have a list of one or more remote server ip addresses needing access
  - Each entry will have the nfs options `(rw,sync,no_root_squash,no_subtree_check)`

*example - nfs_test.json*
```json
{
  "id": "nfs_test",
  "environment": {
    "path1": [
      "server1"
    ],
    "path2": [
      "server3, server4"
    ]
  },
  "test": {
    "/tmp": [
      "127.0.0.1"
    ],
    "/var": [
      "127.0.0.1"
    ]
  }
}
```

*example - /etc/exports*

```
# This file is managed by Chef and should not be modified otherwise.

/tmp 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)
/var 127.0.0.1(rw,sync,no_root_squash,no_subtree_check)
```

#### Command to decrypt included test vault

To see an example working layout in the json format, run the following knife commands to create then decrypt the test data bag included for the kitchen run.

```bash
# Create test data bag for use with chef-client local mode
knife data bag create nfs_exports -z

# Create a data bag item from a file that's already encrypted for use with chef-client local mode
knife data bag from file nfs_exports ./test/integration/data_bags/nfs_exports/nfs_test.json -z

# Decrypt display contents of data bag in json format
knife data bag show nfs_exports nfs_test -z --secret-file ./test/integration/files/encrypted_data_bag_secret -Fj
```
