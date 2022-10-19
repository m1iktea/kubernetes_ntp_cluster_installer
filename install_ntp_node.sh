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

copy_check_scripts(){
    mkdir -p /opt/ntp_check
    cp ntp_check/resynctime.sh /opt/ntp_check/resynctime.sh
    chmod +x /opt/ntp_check/resynctime.sh
}

if [ -e /etc/redhat-release ];then 
    sys_ver='centos'
    echo "system version is ${sys_ver}, installing ntp..."
    install_ntp_centos
    copy_check_scripts
elif [ -e /etc/lsb-release ];then
    sys_ver='ubuntu'
    echo "system version is ${sys_ver}, installing ntp..."
    install_ntp_ubuntu
    copy_check_scripts
else
    echo 'Unsupported system version, exit!'
    exit 1
fi 



