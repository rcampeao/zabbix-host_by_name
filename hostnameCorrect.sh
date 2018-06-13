#!/bin/bash

HOST_NAME=`echo $(hostname)`
USER="Admin"
PASS="zabbix"
ZABBIX_SERVER="localhost"
API="http://localhost/zabbix/api_jsonrpc.php"
#egrep '([0-9]){1,3}\.([0-9]){1,3}\.([0-9]){1,3}\.([0-9]){1,3}'`

# Authenticate with Zabbix API
###############################
authenticate() {

        echo `curl -s -H  'Content-Type: application/json-rpc' -d \
                        "{ \\
                                \\
                                \"jsonrpc\": \"2.0\", \\
                                \"method\":\"user.login\", \\
                                \"params\":{ \\
                                        \"user\":\""${USER}"\", \\
                                        \"password\":\""${PASS}"\" \\
                                        }, \\
                                        \"auth\": null, \\
                                        \"id\":0 \\
                        }" \
                        \
                        $API`

        }

AUTH_TOKEN=`echo $(authenticate)|jq -r .result`

#Get Host Name like IP:
###############################
getHostNameLikeIP() {

        echo `curl -s -H 'Content-Type: application/json-rpc' -d \
                "{ \\
                        \\
                        \"jsonrpc\": \"2.0\", \\
                        \"method\":\"host.get\", \\
                        \"params\": { \\
                                \"output\": [\"name\"] \\
                        }, \\
                        \"id\": 2, \\
                        \"auth\": \""${AUTH_TOKEN}"\" \\
                }" \
                \
                $API | \
                jq -r .result`
        }

HOST_ID=`echo -e "$(getHostNameLikeIP)"`
LIST=$(echo $HOST_ID | \
        sed -e 's/}, /&\n/g' | \
        egrep '([0-9]){1,3}\.([0-9]){1,3}\.([0-9]){1,3}\.([0-9]){1,3}' | \
        cut -d "\"" -f4)

#Update Host´s Names like Host´s Names
###############################
for i in $LIST;
do

        getName=$(curl -s -H 'Content-Type: application/json-rpc' -d \
                "{ \
                        \
                        \"jsonrpc\": \"2.0\",   \
                        \"method\": \"host.get\", \
                        \"params\": { \
                                \"filter\": {\"hostid\": \"$i\"}, \
                                \"output\": [\"name\"], \
                                \"selectInventory\": [\"name\"] \
                        }, \
                        \"id\": 2, \
                        \"auth\": \""${AUTH_TOKEN}"\" \
                }" \
                \
                \
                $API | jq -r .result[].inventory.name)

        if [ -n $getName ];
        then

                curl -s -H 'Content-Type: application/json-rpc' -d \
                                "{ \
                                        \
                                        \"jsonrpc\":\"2.0\", \
                                        \"method\":\"host.update\", \
                                        \"params\":{ \
                                                \"hostid\":\"$i\", \
                                                \"name\":\"$getName\" \
                                        }, \
                                        \"auth\":\"${AUTH_TOKEN}\", \
                                        \"id\":1 \
                                }" \
                                \
                                $API \
                                > /dev/null 2>&1

        fi

done

exit 0
