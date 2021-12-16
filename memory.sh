#!/bin/bash
disk_size=$(df / |awk '/\//{print $4}')
mem_size=$(free |awk '/Mem/{print $4}')
while : 
do
if [ $disk_size -le 3145728 -a $mem_size -le 6024000 ];then
    mail -s Warning root <<EOF
磁盘空间不足！！！！
EOF
fi
done
