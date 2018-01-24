#!/bin/bash
grep -R ether *|grep enp0s25|awk '{print $1"\t"$3}'|sed -e 's/^.*txt://g'|sort|sed -e 's/ *//g'|sed -e 's/$/\t20171221/g'>20171221_all_alive_host.txt
