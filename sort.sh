#!/bin/bash
read -p "请输入一个整数: " num1
read -p "请输入一个整数: " num2
read -p "请输入一个整数: " num3
tmp=0
if [ $num1 -gt $num2 ];then
    tmp=$num1
    num1=$num2
    num2=$tmp
fi
if [ $num1 -gt $num3 ];then
    tmp=$num1
    num1=$num3
    num3=$tmp
fi
if [ $num2 -gt $num3 ];then
    tmp=$num2
    num2=$num3
    num3=$tmp
fi
echo "排序后数据为: $num1,$num2,$num3"

