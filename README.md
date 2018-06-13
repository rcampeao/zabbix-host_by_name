# Correct Zabbix hostname of Discovered Hosts

Copy the hostnameCorrect.sh to "/usr/lib/zabbix/externalscripts/" and give needed permissions to him



cp hostnameCorrect.sh  /usr/lib/zabbix/externalscripts/

chmod +x  /usr/lib/zabbix/externalscripts/hostnameCorrect.sh

chown zabbix. /usr/lib/zabbix/externalscripts/hostnameCorrect.sh



Create a Dicovery Rule in OS Host Templates, set External Check and insert "hostnameCorrect.sh" in the Key field
