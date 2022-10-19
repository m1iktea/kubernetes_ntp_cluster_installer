#!/bin/bash

sync_time_centos(){
    if [ ! -e /usr/sbin/ntpdate ];then 
        yum install -y ntpdate
    else
        echo 'ntpdate already installed, restarting ntp...'
    fi
    systemctl restart ntpd
    ntpdate -u NTP_MASTER_IP
}

sync_time_ubuntu(){
    if [ ! -e /usr/sbin/ntpdate ];then 
        apt install -y ntpdate
    else
        echo 'ntpdate already installed, restarting ntp...'
    fi
    systemctl restart ntp
    ntpdate -u NTP_MASTER_IP
}

if [ -e /etc/redhat-release ];then 
    sys_ver='centos'
    echo "system version is ${sys_ver}, sync time..."
    sync_time_centos
elif [ -e /etc/lsb-release ];then
    sys_ver='ubuntu'
    echo "system version is ${sys_ver}, sync time..."
    sync_time_ubuntu
else
    echo 'Unsupported system version, exit!'
    exit 1
fi