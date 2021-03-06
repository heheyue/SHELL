#!/bin/bash
#连接配置文件
#备份数据库并发送备份信息
SERVER=IP
PORT=3306
USER=root
PASSWORD='password'
#邮件接收人
Receiver=''
#设置备份文件存储位置
BDSAVE_PATH='/DB_BackUp'
function seadmail(){
#发送程序
#$1 邮件标题
#$2 邮件内容
    for i in $Receiver
    do
        #echo "$i"
        echo "$2" | mail -s "$1" $i
    done
}

#程序主体
#获取当前时间
time=`date +%Y%m%d-%H%M%S`
runtime=`echo $time`
mkdir ${BDSAVE_PATH}/$runtime
/usr/bin/mysqldump -h$SERVER -P$PORT -u$USER -p$PASSWORD --opt -R 
/usr/bin/mysqldump -h$SERVER -P$PORT -u$USER -p$PASSWORD --opt -R 
if [[ ! -s ${BDSAVE_PATH}/$runtime/syberos_db_$runtime.sql ]]
then
        #echo 'sql_bak ERROR'
	#echo "$runtime --库备份失败" | mail -s '**数据库备份通知' yanxinyue@syberos.com
	seadmail '--数据库备份通知' "$runtime --库备份失败"
        exit
fi
#/usr/bin/mysqldump -h$SERVER -P$PORT -u$USER -p$PASSWORD --opt -R syberos_oadb > ${BDSAVE_PATH}/$runtime/syberos_oadb_$runtime.sql
if [[ ! -s ${BDSAVE_PATH}/$runtime/syberos_oadb_$runtime.sql ]]
then
        #echo 'sql_bak ERROR'
	#echo "$runtime 份失败" | mail -s '**数据库备份通知' yanxinyue@syberos.com
	seadmail '库备份通知' "$runtime 备份失败"
        exit
fi
seadmail '**库备份通知' "$runtime **库备份成功from160_101server"
#echo "$runtime **份成功" | mail -s '**库备份通知' yanxinyue@qq.com
#echo "sql _bak ok"
