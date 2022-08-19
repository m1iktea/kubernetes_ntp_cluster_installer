#!/bin/bash
log_file='./cluster_ntp_installer.log'

#get master
get_master_node(){
    master_node=$(kubectl get node | grep master | sed -n '1p' | awk '{print $1}')
    master_node_ip=$(kubectl get node ${master_node} -o wide | awk '{print $6}' | sed '1d')
    sed "s/NTP_MASTER_IP/${master_node_ip}/g" ntp_client.conf.template > ntp_client.conf
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

    #client
    echo 'client nodes installing...'
    for node in $(cat ./clusterhosts | grep -v ${master_node_ip});do
        echo ${node}
        scp install_ntp_node.sh ${node}:/tmp/install_ntp_node.sh
        ssh ${node} 'bash -c /tmp/install_ntp_node.sh'
        scp ntp_client.conf ${node}:/etc/ntp.conf
        ssh ${node} 'bash -c /tmp/install_ntp_node.sh'
        ssh ${node} 'ntpq -p'
    done
}

main(){
    get_master_node
    get_all_nodes
    install_ntp_each_node
}

main 2>&1 | tee -a ${log_file}
