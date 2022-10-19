#!/bin/bash
cd /opt/ntp_check
for i in `cat clusterhost| grep -v NTP_MASTER_IP`;do 
	echo $i
	ssh $i '/opt/ntp_check/resynctime.sh'
	echo
done
bash -c ./checktime.sh