#!/bin/bash
#将 Linux 系统中 UID 大于等于 1000 的普通用户都删除
user=$(awk ‐F: '$3>=1000{print $1}' /etc/passwd)
for i in $user
do
    userdel -r $i
done
