#!/bin/bash
log_file="${HOME}/uninstall_cluster_ntp_installer.log"

#get all nodes
get_all_nodes(){
    node_list=$(kubectl get node -o wide | awk '{print $6}' | sed '1d') 
    echo ${node_list} | sed 's/ /\n/g' > clusterhosts
}

remove_client_data(){
    for i in $(cat clusterhosts);do
        echo "restore ntp config file"
        scp ./ntp_master.conf.template ${i}:/etc/ntp.conf
        echo "remove client node scripts"
        ssh ${i} 'rm -rf /opt/ntp_check && systemctl restart ntp'
        ssh $i '(crontab -l | grep -v ntp_check) | crontab -'
    done
    echo "good bye!"
}

main(){
    get_all_nodes
    remove_client_data
}

main 2>&1 | tee -a ${log_file}
