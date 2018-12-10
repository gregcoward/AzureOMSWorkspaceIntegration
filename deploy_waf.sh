#!/bin/bash
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin/"

IP_REGEX='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'

while getopts p: option
do	case "$option"  in
        p) webserverPrivateAddress=$OPTARG;;
    esac
done

tmsh create sys application service f5sampleapphttp template f5.http.v1.2.0 lists add { asm__security_logging { value { \"/Common/f5cloudlogger.app/f5cloudlogger_remote_logging\" }}} tables add { basic__snatpool_members { } net__snatpool_members { } optimizations__hosts { } pool__hosts { column-names { name } rows {{ row { www.sample.net }}}} pool__members { column-names { addr port connection_limit } rows {{ row { $webserverPrivateAddress 80 0 }}}}} variables add { asm__asm_template { value POLICY_TEMPLATE_RAPID_DEPLOYMENT } asm__language { value utf-8 } asm__use_asm { value  \"/#create_new#\" } client__http_compression { value \"/#create_new#\" } net__client_mode { value wan } net__server_mode { value lan } net__v13_tcp { value yes } pool__addr { value 0.0.0.0/0 } pool__pool_to_use { value \"/#create_new#\" } pool__port { value 80 }  ssl__mode { value no_ssl } ssl_encryption_questions__advanced { value no } ssl_encryption_questions__help { value hide }}

echo "Deployment complete."
exit