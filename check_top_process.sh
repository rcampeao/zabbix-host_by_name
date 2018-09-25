#!/bin/bash

echo -e "\n#####################################"
echo -e "## Processos que mais consomem CPU ##"
echo -e "#####################################\n"
ps aux | sort -k 3 -r | awk '{print $1"\t"$3"\t"$4"\t"$11}'| sed -e 's/\t/_|/g' | column -t -s '_' | head -n 7

echo -e "\n#########################################"
echo -e "## Processos que mais consomem Memoria ##"
echo -e "#########################################\n"
ps aux | sort -k 4 -r | awk '{print $1"\t"$3"\t"$4"\t"$11}'| sed -e 's/\t/_|/g' | column -t -s '_' | head -n 7
echo -e ""
