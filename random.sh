#!/bin/bash
#1-100的随机数猜数游戏
num=$[RANDOM%100+1]
while  :
do
      read -p  "计算机生成了一个 1‐100 的随机数，你猜: "  cai
      if   [  $cai -eq $num  ];then
             echo   "恭喜，猜对了"
             exit
      elif  [  $cai -gt $num  ];then
             echo   "猜大了"
      else
             echo   "猜小了"
      fi
done
