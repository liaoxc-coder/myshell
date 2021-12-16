#!/bin/bash
#检测当前用户是否为root，如果是，则安装httpd
if [ $USER == "root" ];then
    yum -y install httpd
else 
    echo "请使用root用户登录"
fi
