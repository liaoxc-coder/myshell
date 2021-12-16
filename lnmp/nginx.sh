#!/bin/bash
#该脚本是实现Nginx的手工编译安装
pkgpath=/root/shell/lnmp
nginxpath=/usr/local/nginx/
nginx_serpath=/lib/systemd/system/nginx.service

systemctl stop firewalld.service 
setenforce 0
echo "正在安装所需环境相关软件包"
yum install -y gcc gcc-c++ make pcre pcre-devel zlib-devel &> /dev/null 
if test $? != 0
then 
	echo "环境安装有误，准备退出..."
	sleep 1
	exit 
fi

cd $pkgpath 
tar zxf nginx-1.18.0.tar.gz -C /opt/
#指定用户但不创建家目录
egrep "^nginx" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -M -s /sbin/nologin nginx
fi
#参数配置
echo "正在配置相关参数..."
sleep 2
cd /opt/nginx-1.18.0/
./configure \
--prefix=/usr/local/nginx \
--user=nginx \
--group=nginx \
--with-http_stub_status_module &> /dev/null
if test $? == 0
then 
	echo "配置参数正确!"
else
	echo "配置参数有误!"
	exit 1
fi

echo "正在编译..."

make &> /dev/null 
if test $? == 0
then 
	echo "编译成功!"
else
	echo "编译有误!"
	exit 1
fi

echo "正在安装..."
make install &> /dev/null
if test $? == 0
then 
	echo "安装成功！"
else
	echo "安装失败！"
	exit 1
fi
ln -s $nginxpathsbin/nginx /usr/local/sbin/

cat  >$nginx_serpath <<EOF
[Unit]
Description=nginx
After=network.target
[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/bin/kill -s HUP $MAINPID
ExecStop=/usr/bin/kill -s QUIT $MAINPID
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
chmod 754 $nginx_serpath
systemctl restart nginx.service
if test $? == 0
then 
	echo "nginx 服务启动完成！"
else
	echo "nginx 服务启动失败！"
	exit 1
fi

