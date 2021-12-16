#!/bin/bash
#用户输入用户名和密码，如果用户拒绝创建账户，则退出；如果用户不输入密码，则统一分配123456为默认密码
read -p "请输入您的用户名: " user
if [ -z $user ];then
    echo "您已经输入了用户名"
    exit 2
fi
stty -echo
read -p "请输入密码: " pass
stty echo
pass=${pass:-123456}
useradd "$user"
echo "$pass" | passwd --stdin "$user"
