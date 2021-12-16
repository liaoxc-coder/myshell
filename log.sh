#!/bin/bash
#统计/var/log有多少文件
#使用 ls 递归显示所有，再判断是否为文件，如果是文件则计数器加 1
cd  /var/log
sum=0
for i in `ls -r *`
do
    if  [ -f $i  ];then
        let sum++
        echo "文件名:$i"
    fi
done
echo "总文件数量为:$sum"
