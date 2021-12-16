#!/bin/bash
#查看有多少远程的 IP 在连接本机
netstat -atn | awk '{print $5}' | awk  '{print $1}' | sort -nr | uniq -c
