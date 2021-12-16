#!/bin/bash
#统计当前 Linux 系统中可以登录计算机的账户有多少个
grep "bash$"  /etc/passwd  | wc -l
