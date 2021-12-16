#!/bin/bash
#查看远程连接的主机有哪些
netstat -atn | awk '{print $5}' | awk '{print $1}' | sort -nr | uniq -c
