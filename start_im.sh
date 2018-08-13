#!/bin/bash
#IM替换脚本
#from yanxinyue
#2018年07月10日
#系统环境变量说明：
        # NATIP：设置IM外网映射IP，否则则书写宿主机IP
        # SSOHOST：统一认证服务连接地址
        # SSOPORT：统一认证服务端口
        # SELFHOST:新闻推送地址（非必填）
        # SELFPORT:新闻推送地址端口（非必填）
        # OAHOST:OA连接地址（非必填）
        # OAPORT:OA连接端口（非必填）
        # DBHOST：数据库服务连接地址
        # DBPORT：数据库服务连接端口
        # DBNAME：数据库名
        # DBUSER：数据库用户名
        # DBPWD:数据库密码
        # REDIS1HOST：redis1服务连接地址
        # REDIS1PORT：redis1端口
        # REDIS2HOST：redis2服务连接地址
        # REDIS2PORT：redis2端口
        # REDIS3HOST：redis3服务连接地址
        # REDIS3PORT：redis3端口


#测试函数
function Test(){
    # export NATIP="122.1.1.1"
    # export SSOHOST='122.1.1.2'
    # export SSOPORT='8001'
    # export SELFHOST='122.1.1.3'
    # export SELFPORT='8002'
    # export OAHOST='122.1.1.4'
    # export OAPORT='9003'
    # export DBHOST='122.1.1.5'
    # export DBPORT='8004'
    # export DBNAME='DB_name'
    # export DBUSER='dn_user'
    # export DBPWD='dbpw'
    # export REDIS1HOST='122.1.1.6'
    # export REDIS1PORT='8005'
    # export REDIS2HOST='122.1.1.7'
    # export REDIS2PORT='8006'
    # export REDIS3HOST='122.1.1.8'
    # export REDIS3PORT='8007'
    # env
    # echo "------STA-----------------$NATIP"
    # `$1`
    # echo "$1"
    # `echo "$1"`
    # unset NATIP
    # unset SSOHOST
    # unset SSOPORT
    # unset SELFHOST
    # unset SELFPORT
    # unset OAHOST
    # unset OAPORT
    # unset DBHOST
    # unset DBPORT
    # unset DBNAME
    # unset DBUSER
    # unset DBPWD
    # unset REDIS1HOST
    # unset REDIS1PORT
    # unset REDIS2HOST
    # unset REDIS2PORT
    # unset REDIS3HOST
    # unset REDIS3PORT
    ：
}


#提示字
function Echo_PATHINFO(){
    echo '''
    请输入如下系统变量：
        NATIP：设置IM外网映射IP，否则则书写宿主机IP
        SSOHOST：统一认证服务连接地址
        SSOPORT：统一认证服务端口
        SELFHOST:新闻推送地址（非必填）
        SELFPORT:新闻推送地址端口（非必填）
        OAHOST:OA连接地址（非必填）
        OAPORT:OA连接端口（非必填）
        DBHOST：数据库服务连接地址
        DBPORT：数据库服务连接端口
        DBNAME：数据库名
        DBUSER：数据库用户名
        DBPWD:数据库密码
        REDIS1HOST：redis1服务连接地址
        REDIS1PORT：redis1端口
        REDIS2HOST：redis2服务连接地址
        REDIS2PORT：redis2端口
        REDIS3HOST：redis3服务连接地址
        REDIS3PORT：redis3端口
'''
}
# Echo_PATHINFO

#获取docker内部IP
function Get_Sys_Info(){
    LOCALIP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | awk -F"/" '{print $1}'`
    NOWDATE=`date "+%Y%m%d"`
    USEDATE=`date -d -10day "+%Y%m%d"`
}
# Get_Sys_Info
# echo $LOCALIP
# echo $NOWDATE
# echo $USEDATE

#检测环境变量是否存在
function Check_VAR(){
    var='SELFHOST SELFPORT OAHOST OAPORT'
    SysPath=`env | awk -F '=' '{print $1}' | tr " \n" " " `
    for i in $var
        do
            # echo "--------- $i ----------"
            bit='0'
            for a in $SysPath
                do
                    if [ "$i" == "$a" ];then
                    # if [[ (echo "$i" ) ]]; then
                    #     :
                        bit='1'
                    # fi
                    fi
                done
            if [[ $bit == '1' ]]; then
                :
                # echo "0000000000000000000000000000000000000000000000000000000000000$i"
            elif [[ $bit == '0' ]]; then
                    # echo "------------------------------------------------------$i"
                    case $i in
                        SELFHOST )
                            export SELFHOST='127.0.0.1'
                            ;;
                        SELFPORT )
                            export SELFPORT='8030'
                            ;;
                        OAHOST )
                            export OAHOST='127.0.0.1'
                            ;;
                        OAPORT )
                            export OAPORT='80'
                            ;;
                        * )
                            ;;
                    esac
            fi
        done
    var='NATIP SSOHOST SSOPORT DBHOST DBPORT DBNAME DBUSER DBPWD REDIS1HOST REDIS1PORT REDIS2HOST REDIS2PORT REDIS3HOST REDIS3PORT'
    # echo $var
    for i in $var
        do
            # SysPath=`env | awk -F '=' '{print $1}' | tr " \n" "|" | awk -F '_|' '{print $1}' `
            # SysPath=`env | awk -F '=' '{print $1}' | tr " \n" " " `
            # echo "$SysPath"
            # echo "$i"
            bit='0'
            for a in $SysPath
                # bit='0'
                do
                    if [ "$i" == "$a" ];then
                    # if [[ (echo "$i" ) ]]; then
                    #     :
                        bit='1'
                    # fi
                    fi
                done
            if [[ $bit == '1' ]]; then
                :
            elif [[ $bit == '0' ]]; then
                    echo "$i IS NULL ----$i 为空 请从新设置"
                    Echo_PATHINFO
                    exit
            fi
        done
}
# Test
# Check_VAR
# Test Check_VAR

#设置IM配置文件
function Sed_Im_conf(){
    Get_Sys_Info
# NATIP='122.1.1.1'
# SSOHOST='122.1.1.2'
# SSOPORT='8001'
# SELFHOST='122.1.1.3'
# SELFPORT='8002'
# OAHOST='122.1.1.4'
# OAPORT='9003'
# DBHOST='122.1.1.5'
# DBPORT='8004'
# DBNAME='DB_name'
# DBUSER='dn_user'
# DBPWD='dbpw'
# REDIS1HOST='122.1.1.6'
# REDIS1PORT='8005'
# REDIS2HOST='122.1.1.7'
# REDIS2PORT='8006'
# REDIS3HOST='122.1.1.8'
# REDIS3PORT='8007'
    mkdir -p /home/eimserver/program/log
    mkdir -p /home/eimserver/program/file 
    mkdir -p /home/eimserver/program/icon1
    mkdir -p /home/eimserver/program/icon2 
    chmod 777 -R /home/eimserver/
    cd /home/eimserver/program/config/
    sed -i "/NAME=\"oauth2\">/s/>.*</>${SSOHOST}:${SSOPORT}</" config.ap

    sed -i "/<SBC_SERVER>/s/>.*:/>${LOCALIP}:/" config.conductor
    sed -i "/<IMS_SERVER>/s/>.*:/>${LOCALIP}:/" config.conductor

    sed -i "/HTTPPROXY/s/>.*:/>${NATIP}:/" config.gm
    sed -i "/SIPPROXY/s/>.*:/>${NATIP}:/" config.gm
    sed -i "/PBTCPPROXY/s/>.*:/>${NATIP}:/" config.gm
    sed -i "/FTPROXY/s/>.*:/>${NATIP}:/" config.gm
    sed -i "/MSPROXY/s/>.*:/>${NATIP}:/" config.gm
    sed -i "/ENTPLATFORM/s/>.*</>${SELFHOST}:${SELFPORT}</" config.gm
    sed -i "/HTTPSENTPLATFORM/s/>.*</>${SELFHOST}:${SELFPORT}</" config.gm
    sed -i "/OA/s/>.*</>${OAHOST}:${OAPORT}</" config.gm

    sed -i "/WEBICONDIR>/s/>.*</>\/home\/uploads\/syberos_im_uploads\/</" config.pg

    sed -i "s/<LOCALIP>.*<\/LOCALIP>/<LOCALIP>${LOCALIP}<\/LOCALIP>/" config.public
    sed -i "s/<NATIP>.*<\/NATIP>/<NATIP>${NATIP}<\/NATIP>/" config.public
    # sed -i "s/<DESC>.*<\/DESC>/<DESC>${DBNAME}<\/DESC>/" config.public
    sed -i "s/<IP>.*<\/IP>/<IP>${DBHOST}<\/IP>/" config.public
    sed -i "/USER/s/>.*</>${DBUSER}</" config.public
    sed -i "s/<DATABASE>.*<\/DATABASE>/<DATABASE>${DBNAME}<\/DATABASE>/" config.public
    sed -i "/PIN/s/>.*</>${DBPWD}</" config.public
    sed -i "s/<PORT>.*<\/PORT>/<PORT>${DBPORT}<\/PORT>/" config.public

    sed -i "/<IP>/d" config.redislist
    sed -i "/<PORT>/d" config.redislist
    sed -i "/<NAME>groupmsgmap<\/NAME>/s/<NAME>groupmsgmap<\/NAME>/<NAME>groupmsgmap<\/NAME>\n                <IP>${REDIS1HOST}<\/IP>\n                <PORT>${REDIS1PORT}<\/PORT>/" config.redislist
    sed -i "/<NAME>onlinemsg<\/NAME>/s/<NAME>onlinemsg<\/NAME>/<NAME>onlinemsg<\/NAME>\n                <IP>${REDIS2HOST}<\/IP>\n                <PORT>${REDIS2PORT}<\/PORT>/" config.redislist
    sed -i "/<NAME>webadaptor_cache<\/NAME>/s/<NAME>webadaptor_cache<\/NAME>/<NAME>webadaptor_cache<\/NAME>\n                <IP>${REDIS3HOST}<\/IP>\n                <PORT>${REDIS3PORT}<\/PORT>/" config.redislist
    sed -i "/NAME=\"IM\">/s/>.*:/>${LOCALIP}:/" config.sbc
    sed -i "/NAME=\"MSRPGW\">/s/>.*:/>${LOCALIP}:/" config.sbc
    sed -i "/NAME=\"PG\">/s/>.*:/>${LOCALIP}:/" config.sbc
    sed -i "/MS\">/s/>.*:/>${LOCALIP}:/" config.sbc
    # sed -i "ROUTER\">/s/>.*:/>${LOCALIP}:/" config.sbc
    sed -i "/COND\">/s/>.*:/>${LOCALIP}:/" config.sbc

    sed -i "/STARTDATE/s/>.*</>${USEDATE}</" config.schedule

    sed -i "/<IP>/d" config.stg
    sed -i "/<SRC/d" config.stg
    sed -i "/<TO>/d" config.stg
    sed -i "/<PROXYSERVER>/s/<PROXYSERVER>/<PROXYSERVER>\n    <IP>${NATIP}<\/IP>/" config.stg
    sed -i "/<STGSERVER>/s/<STGSERVER>/<STGSERVER>\n    <IP>${LOCALIP}<\/IP>/" config.stg
    sed -i "/<STG_PUBLIC_ADDR>/s/<STG_PUBLIC_ADDR>/<STG_PUBLIC_ADDR>\n    <IP>${NATIP}<\/IP>/" config.stg
    sed -i "/<PROTOCOL> SIP <\/PROTOCOL>/s/<PROTOCOL> SIP <\/PROTOCOL>/<PROTOCOL> SIP <\/PROTOCOL>\n      <SRC PORTSTART=\"8020\" PORTEND=\"8020\"> ${NATIP}<\/SRC>\n      <TO> ${LOCALIP}<\/TO>/" config.stg
    sed -i "/<PROTOCOL> RTP <\/PROTOCOL>/s/<PROTOCOL> RTP <\/PROTOCOL>/<PROTOCOL> RTP <\/PROTOCOL>\n      <SRC PORTSTART=\"12000\" PORTEND=\"12000\"> ${NATIP}<\/SRC>\n      <TO> ${LOCALIP}<\/TO>/" config.stg
    sed -i "/<PROTOCOL> HTTP <\/PROTOCOL>/s/<PROTOCOL> HTTP <\/PROTOCOL>/<PROTOCOL> HTTP <\/PROTOCOL>\n      <SRC PORTSTART=\"8061\" PORTEND=\"8061\"> ${NATIP}<\/SRC>\n      <TO> ${LOCALIP}<\/TO>/" config.stg
    sed -i "/<PROTOCOL> FILETCP <\/PROTOCOL>/s/<PROTOCOL> FILETCP <\/PROTOCOL>/<PROTOCOL> FILETCP <\/PROTOCOL>\n      <SRC PORTSTART=\"8064\" PORTEND=\"8064\"> ${NATIP}<\/SRC>\n      <TO> ${LOCALIP}<\/TO>/" config.stg
    sed -i "/<PROTOCOL> PB <\/PROTOCOL>/s/<PROTOCOL> PB <\/PROTOCOL>/<PROTOCOL> PB <\/PROTOCOL>\n      <SRC PORTSTART=\"8050\" PORTEND=\"8050\"> ${NATIP}<\/SRC>\n      <TO> ${LOCALIP}<\/TO>/" config.stg
}
# Sed_Im_conf

#启动IM
function Start_Service(){
    /home/eimserver/program/bin/pstart
}
#守护进程
function Defender(){
    while [[ 1 ]]; do
        ps aux | grep '/home/eimserver/program/bin/pstart' | grep -v grep | grep -v start_im.sh >  /dev/null
        if [ $? -ne 0 ]
            then
            exit
        else
            :
        fi
    done
}

function main(){
        #检测环境变量
        Check_VAR
        #更改配置文件
        Sed_Im_conf
        #启动服务
        Start_Service
        #守护进程--前台执行-随主程序死亡而结束
        Defender
}
#入口
main
