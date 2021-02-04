#!/bin/bash
# Functions: send messages to wechat app
# set variables
#企业识别吗:CorpID
CropID=''
#应用识别:Secret
Secret=''
#获取tocken
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret"
Gtoken=$(/usr/bin/curl -s -G $GURL | awk -F\: '{print $4}'| awk -F\, '{print $1}' | awk -F\"  '{print $2}')
#echo "$Gtoken"
#拼接token
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Gtoken"
#格式化数据为接口格式
function body() {
	local int AppID=1                        #企业号中的应用id
	local UserID='@all'                     #部门成员id，zabbix中定义的微信接收者
	local PartyID=1                          #部门id，定义了范围，组内成员都可接收到消息
	local Msg=$(echo "$@" | cut -d" " -f3-)   #过滤出zabbix传递的第三个参数
	printf '{\n'
	printf '\t"touser": "'"$UserID"\"",\n"
	printf '\t"toparty": "'"$PartyID"\"",\n"
	printf '\t"msgtype": "text",\n'
	printf '\t"agentid": "'" $AppID "\"",\n"
	printf '\t"text": {\n'
	printf '\t\t"content": "'"$Msg"\""\n"
	printf '\t},\n'
	printf '\t"safe":"0"\n'
	printf '}\n'
}
#echo "$(body $1 $2 $3)"
#/usr/bin/curl --data-ascii "$(body $1 $2 $3)" $PURL
#post方式发送application/json格式的数据,请求发送。
/usr/bin/curl -H "Content-Type: application/json" -X POST  --data "`echo $(body $1 $2 $3)`" $PURL
