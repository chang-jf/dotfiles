#!/bin/bash
arp -a|grep `/home/angus/.bin/dash_to_colon.sh $1`|awk '{print $2}'|sed -e 's/(//g' -e 's/)//g'
#arp -a|grep `colon_to_dash.sh $1`|awk '{print $2}'|sed -e 's/(//g' -e 's/)//g'
