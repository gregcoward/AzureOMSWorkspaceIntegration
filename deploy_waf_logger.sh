#!/bin/bash
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"

IP_REGEX='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'

while getopts m:d:n:h:s:t:l:a:c:u:p: option
do	case "$option"  in
        u) user=$OPTARG;;
        p) passwd=$OPTARG;;
        w) wspaceid=$OPTARG;;
        k) wspacekey=$OPTARG;;
    esac
done

sleep 120

# check for existence of device-group
response_code=$(curl -sku $user:$passwd -w "%{http_code}" -X GET -H "Content-Type: application/json" https://localhost/mgmt/tm/cm/device-group/~Common~Sync  -o /dev/null)

if [[ $response_code != 200 ]]; then
     echo "We are one, set device group to none"
     device_group="none"
else
     echo "We are two, set device group to Sync"
     device_group="/Common/Sync"
fi


# deploy cloudlogger iApp
 response_code=$(curl -sk -u $user:$passwd -w "%{http_code}" -X POST -H "Content-Type: application/json" https://localhost/mgmt/tm/sys/application/service/ -d '{"name": "azurecloudlogger","partition": "Common","deviceGroup": "none","strictUpdates": "disabled","template": "/Common/template f5.cloud_logger.v1.0.0","trafficGroup": "none","lists": [{"name": "logging_config__ltm_req_log_options","value": "CLIENT_IP SERVER_IP  HTTP_METHOD HTTP_URI VIRTUAL_NAME"}],"variables": [{"Name":"analytics_config__analytics_solution","value": "azure_oms"},{"Name": "analytics_config__log_type","value": "F5CustomLog"},{"Name": "analytics_config__shared_key","encrypted": "yes","value": "'"$wspacekey"'"},{"Name": "analytics_config__workspace","value": "'"$wspaceid"'"},{"Name": "basic__advanced","value": "no"},{"Name": "basic__help","value": "hide"},{"Name": "internal_config__hostname","value": "yes"},{"Name": "internal_config__port","value": "yes"},{"Name": "logging_config__asm_log_choice","value": "yes"},{"Name": "logging_config__asm_log_level","value": "log_all"},{"Name": "logging_config__dos_logs","value": "yes"},{"Name": "logging_config__ltm_req_log_choice","value": "yes"}]}' -o /dev/null)

if [[ $response_code != 200  ]]; then
     echo "Failed to install LTM policy; exiting."
     exit
fi

echo "Deployment complete."
exit
