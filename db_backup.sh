#!/bin/bash
#备份MySQL
user=root
passwd=123456
dbname=mysql
date=$(date +%Y%m%d)
[ ! -d /mysqlbackup ] && mkdir /mysqlbackup
mysqldump -u "$user" -p "$passwd" "$dbname" > /mysqlbackup/"$dbname"-${date}.sql
