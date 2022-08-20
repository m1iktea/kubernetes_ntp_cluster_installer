# kubernetes_ntp_cluster_installer
kubernetes cluster install ntp in each nodes

## Before use this script
1. localhost can executed `kubectl` admin commands
2. localhost can ssh to each nodes without password

## Principle
1. choose one kubernetes master node as ntp server master node
2. all other nodes sync time from ntp server master node

## Running
```bash
  ./install_ntp_cluster.sh
```

## Support system
1. Ubuntu 18.04 and later versions
2. Centos 7.x and later versions
