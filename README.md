# Correct Zabbix hostname of Discovered Hosts

#Copy the hostnameCorrect.sh to "/usr/lib/zabbix/externalscripts/" and give nedeed permissions to him

1 - cp hostnameCorrect.sh  /usr/lib/zabbix/externalscripts/
2 - chmod +x  /usr/lib/zabbix/externalscripts/hostnameCorrect.sh
3 - chown zabbix. /usr/lib/zabbix/externalscripts/hostnameCorrect.sh

Create a Dicovery Rule in OS Host Templates, set External Check and insert "hostnameCorrect.sh" in the Key field
