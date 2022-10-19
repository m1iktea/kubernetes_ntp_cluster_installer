#!/bin/bash

install_ntp_centos(){
    if [ ! -e /usr/sbin/ntpq ];then 
        yum install -y ntp
        systemctl enable ntpd
    else
        echo 'ntp already installed, restarting ntp...'
    fi
    systemctl restart ntpd
}

install_ntp_ubuntu(){
    if [ ! -e /usr/bin/ntpq ];then 
        apt install -y ntp
        systemctl enable ntp
    else
        echo 'ntp already installed, restarting ntp...'
    fi
    systemctl restart ntp
}

if [ -e /etc/redhat-release ];then 
    sys_ver='centos'
    echo "system version is ${sys_ver}, installing ntp..."
    install_ntp_centos
elif [ -e /etc/lsb-release ];then
    sys_ver='ubuntu'
    echo "system version is ${sys_ver}, installing ntp..."
    install_ntp_ubuntu
else
    echo 'Unsupported system version, exit!'
    exit 1
fi 



