#!/bin/bash
read -p "为这些用户统一设置个密码: " PASSWD
for UNAME in `cat users.txt`
do
id $UNAME &> /dev/null
if [ $? -eq 0 ]
then
echo "这些用户已存在"
else
useradd $UNAME &> /dev/null
echo "$PASSWD" | passwd --stdin $UNAME &> /dev/null
if [ $? -eq 0 ]
then
echo "$UNAME , 添加成功"
else
echo "$UNAME , 添加失败"
fi
fi
done
