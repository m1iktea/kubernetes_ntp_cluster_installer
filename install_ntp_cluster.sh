#!/bin/bash
log_file='./cluster_ntp_installer.log'

#get master
get_master_node(){
    master_node=$(kubectl get node | grep master | sed -n '1p' | awk '{print $1}')
    master_node_ip=$(kubectl get node ${master_node} -o wide | awk '{print $6}' | sed '1d')
    sed "s/NTP_MASTER_IP/${master_node_ip}/g" ntp_client.conf.template > ntp_client.conf
    for i in $(ls ntp_check/*.template);do
        script=$(echo ${i} | sed 's/.template//g')
        echo "change master ip for check scripts ${script}"
        sed "s/NTP_MASTER_IP/${master_node_ip}/g" ${i} > ${script}
    done
}

#get all nodes
get_all_nodes(){
    node_list=$(kubectl get node -o wide | awk '{print $6}' | sed '1d') 
    echo ${node_list} | sed 's/ /\n/g' > clusterhosts
}

#install ntp
install_ntp_each_node(){
    #master
    echo 'master node installing...'
    scp install_ntp_node.sh ${master_node_ip}:/tmp/install_ntp_node.sh
    ssh ${master_node_ip} 'bash -c /tmp/install_ntp_node.sh'
    scp -r ntp_check/ ${master_node_ip}:/opt/

    #client
    echo 'client nodes installing...'
    for node in $(cat ./clusterhosts | grep -v ${master_node_ip});do
        echo ${node}
        scp install_ntp_node.sh ${node}:/tmp/install_ntp_node.sh
        ssh ${node} 'bash -c /tmp/install_ntp_node.sh'
        scp ntp_client.conf ${node}:/etc/ntp.conf
        ssh ${node} 'bash -c /tmp/install_ntp_node.sh'
        ssh ${node} 'ntpq -p'
        ssh ${node} 'mkdir -p /opt/ntp_check'
        scp ntp_check/resynctime.sh ${node}:/opt/ntp_check/resynctime.sh
    done
}

init_check_scripts(){
    chmod +x ntp_check/*.sh
    cp clusterhosts ntp_check/clusterhosts
}

crontab_check(){
    # restart all ntp service in 00:00 every day
    (crontab -l | grep -v ntp_check; echo "0 0 */1 * * /opt/ntp_check/restartallsync.sh >> /opt/ntp_check/sync.log 2>&1") | crontab -
}

main(){
    get_master_node
    get_all_nodes
    init_check_scripts
    install_ntp_each_node
    crontab_check
}

main 2>&1 | tee -a ${log_file}
