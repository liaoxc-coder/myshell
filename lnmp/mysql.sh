#!/bin/bash
if test $# != 1
then 
	echo "error!"
	exit
fi
#手工编译安装MySQL脚本
pkgpath=~/tar/LNMP-C7/
mysqlpath=/usr/local/mysql 

#安装所需环境软件包
echo "安装所需环境软件包..."
yum install -y ncurses ncurses-devel bison cmake  expect &> /dev/null
if test $? != 0
then 
	echo "环境安装有误，准备退出..."
	sleep 1
	exit 
fi
#ncurses 字符终端包 bison 函数库 cmake 编译工具

#创建非登录用户
egrep "^mysql" /etc/passwd &> /dev/null
if [ $? -ne 0 ]
then
    useradd -s /sbin/nologin mysql
fi
 
#解压缩mysql软件包
cd  $pkgpath
tar zxf mysql-boost-5.7.20.tar.gz -C /opt/

#配置参数设置
echo "正在执行配置参数设置..."
sleep 2
cd /opt/mysql-5.7.20/
cmake \
-DCMKAE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DSYSCONFDIR=/etc \
-DSYSTEMD_PID_DIR=/usr/local/mysql \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DWITH_BOOST=boost \
-DWITH_SYSTEMD=1 &> /dev/null
if test $? == 0
then 
	echo "配置参数正确!"
else
	echo "配置参数有误!"
	exit 1
fi
echo "正在编译..."
echo "编译所需时间较长，请耐心等待（20-45min）..."
sleep 3
make &> /dev/null
if test $? == 0
then 
	echo "编译成功!"
else
	echo "编译失败!"
	exit 1
fi
echo "正在安装..."
make install &> /dev/null 
if test $? == 0
then 
	echo "安装成功!"
else
	echo "安装失败!"
	exit 1
fi
cd /usr/local
chown -R mysql.mysql mysql/
cat >/etc/my.cnf <<EOF
[client]
port = 3306
default-character-set=utf8
socket = /usr/local/mysql/mysql.sock

[mysql]
port = 3306
default-character-set=utf8
socket = /usr/local/mysql/mysql.sock

[mysqld]
user = mysql
basedir = /usr/local/mysql
datadir = /usr/local/mysql/data
port = 3306
character_set_server=utf8
pid-file = /usr/local/mysql/mysqld.pid
socket = /usr/local/mysql/mysql.sock
server-id = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_AUTO_VALUE_ON_ZERO,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,PIPES_AS_CONCAT,ANSI_QUOTES
EOF

chown mysql.mysql /etc/my.cnf
#echo 'PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH' >> /etc/profile
#echo 'export PATH' >> /etc/profile
#source /etc/profile
ln -s $mysqlpath/bin/* /usr/local/bin/ 
ln -s $mysqlpath/lib/* /usr/local/bin/
cd $mysqlpath 
bin/mysqld \
--initialize-insecure \
--user=mysql \
--basedir=/usr/local/mysql \
--datadir=/usr/local/mysql/data >& /dev/null 

cp usr/lib/systemd/system/mysqld.service /lib/systemd/system/

systemctl start mysqld.service 


passwd=$1
/usr/bin/expect <<-EOF
spawn mysqladmin -u root -p password 
expect {
	"Enter password:"
	{ send "\r";exp_continue }
	"New password:"
	{ send "$1\r";exp_continue }
	"Confirm new password:"
	{ send "$1\r"; }
}
expect eof
EOF

echo "数据库登录密码设置完成，请稍后手动创建自己的数据库..."

