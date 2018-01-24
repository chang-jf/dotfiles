#!/bin/bash
#echo "0800.37ab.df31"|sed 's/./&./2'|sed 's/./&./8'|sed 's/./&./14'│       enp0s25
echo $1|sed 's/./&./2'|sed 's/./&./8'|sed 's/./&./14'|sed 's/\./:/g'
