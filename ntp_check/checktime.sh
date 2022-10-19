#!/bin/bash
for i in `cat clusterhost| grep -v NTP_MASTER_IP`;do
    echo $i
    ssh $i 'ntpq -p'
    echo
done