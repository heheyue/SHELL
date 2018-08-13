#!/bin/sh
# this script can make certificate from file which you point!
if [ $# -ne 1 ];then
   echo -e "\033[33m Input your domain's file \033[0m"
   exit 1
fi
for line in `cat $1`
do
    hostname=$line
    line="`echo $line|awk -F" " '{print $1}'`.key"
    echo "==$line=="
    echo -e "\n\n\033[32m Make certificate of $line \033[0m\n\n"
    csr_file=`echo $line|awk -F".key" '{print $1}'`
    expect -c "
        set timeout 20;
        spawn openssl genrsa -des3 -out $line 2048
        expect {
            : {send 12345678\r;exp_continue}
            : {send 12345678\r;}
        }

        spawn openssl rsa -in $line -out $line
        expect {
            \"Enter pass phrase\" {send 12345678\r;exp_continue}
        }

        spawn openssl req -new -key $line -out  $csr_file.csr
        expect {
            \"Enter pass phrase\"  {send 12345678\r;exp_continue}
            \"Country Name\" {send CN\r;exp_continue}
            \"State or Province Name\" {send Beijing\r;exp_continue}
	    \"Locality Name\" {send Beijing\r;exp_continue}
	    \"Organization Name\" {send \"Beijing Yuanxin Technology Co., Ltd.\r\";exp_continue}
	    \"Organizational Unit Name\" {send \"Beijing Yuanxin Technology Co., Ltd.\r\";exp_continue}
	    \"Common Name*\" {send \"$hostname\r\";exp_continue}
	    \"Email Address\" {send \r;exp_continue}
            \"A challenge password\" {send 12345678\r;exp_continue}
	    \"An optional company name\" {send \"Beijing Yuanxin Technology Co., Ltd\r\";exp_continue}
       }"
done


