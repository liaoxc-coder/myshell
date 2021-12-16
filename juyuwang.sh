#!/bin/bash
#测试 192.168.115.0/24 整个网段中哪些主机处于开机状态，哪些主机处于关机状态
myping(){
ping -c2 -i0.3 -W1 $1 &>/dev/null
if [ $? -eq 0 ];then
    echo "$1 is up"
else
    echo "$1 is down"
fi
}
for i in {1..254}
do
    myping 192.168.115.$i &
done
