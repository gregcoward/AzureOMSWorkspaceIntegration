#!/bin/bash
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"

IP_REGEX='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'

while getopts w:k: option
do	case "$option"  in
        w) wspaceid=$OPTARG;;
        k) wspacekey=$OPTARG;;
    esac
done

echo $wspaceid
echo $wspacekey

# deploy cloudlogger iApp
tmsh create sys application service f5cloudlogger template f5.cloud_logger.v1.0.0 lists add { logging_config__ltm_req_log_options { value { CLIENT_IP SERVER_IP HTTP_METHOD HTTP_URI VIRTUAL_NAME }}} variables add { analytics_config__analytics_solution { value azure_oms } analytics_config__log_type { value F5CustomLog } analytics_config__shared_key { encrypted no value $wspacekey } analytics_config__workspace { value $wspaceid } basic__advanced { value no } basic__help { value hide } internal_config__hostname { value yes } internal_config__port { value yes } logging_config__asm_log_choice { value yes } logging_config__asm_log_level { value log_illegal } logging_config__dos_logs { value yes } logging_config__ltm_req_log_choice {  value yes }}

echo "Deployment complete."
exit
