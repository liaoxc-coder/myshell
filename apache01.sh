#!/bin/bash
#统计13:30到14:30所有访问 apache 服务器的请求有多少个
awk -F "[ /:]" '$7":"$8>="13:30" && $7":"$8<="14:30"' /var/log/httpd/access_log | wc -l
