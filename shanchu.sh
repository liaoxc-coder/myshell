#!/bin/bash
#删除某个目录下大小为 0 的文件
dir="/tmp"
find $dir -type f -size 0 -exec rm -rf {} \;
