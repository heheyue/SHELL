#!/bin/bash
# Program:
#       system_init_shell
# Release:
#       1.2
#设置时间同步服务器地址
NTPTIME='time.windows.com'
HOSTNAME='localhost.localdomain'
cat << EOF
 +--------------------------------------------------------------+
 |          === Welcome to CentOS 7.x System init ===           |
 +--------------------------------------------------------------+
EOF
PAT=`/usr/bin/pwd`
#添加本地yum源
mv /etc/yum.repos.d /etc/yum.repos.d_bak
mkdir /etc/yum.repos.d
cat >> /etc/yum.repos.d/local.repo << EOF
[local]
name=local
baseurl=file://$PAT/yumrepo
gpgcheck=0
EOF
yum clean all
#安装环境基本包
for i in vim gcc gcc-c++ glibc make autoconf nc automake dos2unix zlib-devel libxml* python-devel iftop libtool-ltdl-devel gd-devel freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel bison patch unzip ncurses ncurses-devel sudo bzip2 mlocate flex lrzsz sysstat lsof setuptool system-config-firewall-tui ntp libaio-devel wget createrepo yum-downloadonly
do
   yum -y install ${i} > /dev/null 2>&1
   if [ $? -eq 0 ];
   then
        echo "${i} is installed"
   else
        echo "${i} is installed to error"
   fi
done
#开启rc.local
chmod 744 /etc/rc.d/rc.local

#设置环境变量(历史命令)
cat >> /etc/profile << EOF
export PROMPT_COMMAND="history -a"
USER_IP=\`who -u am i 2>/dev/null| awk '{print \$NF}' |sed -e 's/[()]//g'\`
export HISTTIMEFORMAT="[%F %T][\`whoami\`][\${USER_IP}] "
HISTDIR=/var/log/.hist
if [ -z \$USER_IP ]
then
USER_IP=\`hostname\`
fi
if [ ! -d \$HISTDIR ]
then
mkdir -p \$HISTDIR
chmod 777 \$HISTDIR
fi
if [ ! -d \$HISTDIR/\${LOGNAME} ]
then
mkdir -p \$HISTDIR/\${LOGNAME}
chmod 300 \$HISTDIR/\${LOGNAME}
fi
export HISTSIZE=4096
DT=\`date +%Y%m%d_%H%M\`
export HISTFILE="\$HISTDIR/\${LOGNAME}/\${USER_IP}.hist.\$DT"
chmod 600 \$HISTDIR/\${LOGNAME}/*.hist* 2>/dev/null
EOF
source /etc/profile
echo 'cmd log changed'

#set 时间同步服务器同步时间
echo "*/5 * * * * /usr/sbin/ntpdate $NTPTIME > /dev/null 2>&1" >> /var/spool/cron/root
systemctl restart crond.service
echo "ntpserver set $NTPTIME"

#set 硬件时钟
hwclock --set --date="`date +%D\ %T`"
hwclock --hctosys
echo 'time is ok'

#set linux的最大进程数和最大文件打开数
echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
 *           soft   nofile       102400
 *           hard   nofile       102400
 *           soft   nproc        102400
 *           hard   nproc        102400
EOF


#set max user processes
#sed -i 's/1024/102400/' /etc/security/limits.d/90-nproc.conf

# 关闭control-alt-delete功能键
#sed -i 's#exec /sbin/shutdown -r now#\#exec /sbin/shutdown -r now#' /etc/init/control-alt-delete.conf
rm -rf /usr/lib/systemd/system/ctrl-alt-del.target

#关闭服务
for service in `ls /usr/lib/systemd/system | grep service`
do
        case $service in
                crond.service | irqbalance.service | NetworkManager.service | sshd.service | rsyslog.service | sysstat.service )
                echo "skip $service"
                echo '-----------------'
                ;;
        *)
                systemctl stop $service
                systemctl disable $service
                echo "$service is off "
                echo '-----------------'
                ;;
        esac
done
#设置系统字符集及语言
# :> /etc/sysconfig/i18n
# cat >> /etc/sysconfig/i18n << EOF
#  LANG="en_US.UTF-8"
# EOF
# cat >> /etc/locale.conf << EOF
#   LANG="en_US.UTF-8"
# EOF


#ssh连接提速
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl restart sshd.service

#set sysctl
true > /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
 net.ipv4.ip_forward = 0
 net.ipv4.conf.default.rp_filter = 1
 net.ipv4.conf.default.accept_source_route = 0
 kernel.sysrq = 0
 kernel.core_uses_pid = 1
 net.ipv4.tcp_syncookies = 1
 kernel.msgmnb = 65536
 kernel.msgmax = 65536
 kernel.shmmax = 68719476736
 kernel.shmall = 4294967296
 net.ipv4.tcp_max_tw_buckets = 6000
 net.ipv4.tcp_sack = 1
 net.ipv4.tcp_window_scaling = 1
 net.ipv4.tcp_rmem = 4096 87380 4194304
 net.ipv4.tcp_wmem = 4096 16384 4194304
 net.core.wmem_default = 8388608
 net.core.rmem_default = 8388608
 net.core.rmem_max = 16777216
 net.core.wmem_max = 16777216
 net.core.netdev_max_backlog = 262144
 net.core.somaxconn = 262144
 net.ipv4.tcp_max_orphans = 3276800
 net.ipv4.tcp_max_syn_backlog = 262144
 net.ipv4.tcp_timestamps = 0
 net.ipv4.tcp_synack_retries = 1
 net.ipv4.tcp_syn_retries = 1
 net.ipv4.tcp_tw_recycle = 1
 net.ipv4.tcp_tw_reuse = 1
 net.ipv4.tcp_mem = 94500000 915000000 927000000
 net.ipv4.tcp_fin_timeout = 1
 net.ipv4.tcp_keepalive_time = 1200
 net.ipv4.ip_local_port_range = 1024 65535
 net.ipv6.conf.all.disable_ipv6 =1
 net.ipv6.conf.default.disable_ipv6 =1
EOF
/sbin/sysctl -p
echo "sysctl set OK!!"

#disable ipv6
#echo "alias net-pf-10 off" >> /etc/modprobe.conf
#echo "alias ipv6 off" >> /etc/modprobe.conf
#/sbin/chkconfig ip6tables off
#echo "ipv6 is disabled!"

#关闭selinus
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0

#vim setting
#sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
#echo 'syntax on' > /root/.vimrc

cat << EOF
 +--------------------------------------------------------------+
 |                    ===System init over===                    |
 +--------------------------------------------------------------+
EOF
echo "###############################################################"
