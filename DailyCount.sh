#!/bin/sh
set -o nounset
set -o errexit
# 脚本作用:统计下载文件的数量,并把统计数据发送到网站服务器.
# 2014-01-24
# Viprhz

fileName="MacBooster*"
currentTime=`date +%H`
startTime=$(date "+%M")
fileSize=$((12 * 1000 *1024))
currentDate=`date | awk '{print$1}'`
PassWD=`cat ~/Documents/PWinfo.txt`
ComputerName=`ifconfig|awk '/ether/ {print $2}'|head -1`
sendAddress="http://iobit.herokuapp.com/push"
cminTime=360
DownloadPath=~/Downloads/
infoPath=~/Documents/info.html   
logFile=~/Library/Preferences/CountDownloadLog.txt

echo "#################### $(date "+%Y-%m-%d %H:%M:%S") Start Script. ####################" >>${logFile}

#Count downloads file
if [[ -f $infoPath ]];then
		lastCount=`awk '/TotalDownload/ {print $5}' ${infoPath}`
		currentCount=`find ${DownloadPath} -size +${fileSize}c -a -name ${fileName} -a -cmin -${cminTime}|wc -l`
		totalCount=$((lastCount+currentCount))
		#echo "$(date "+%Y-%m-%d %H:%M:%S") TotalDownload ${totalCount}" >${infoPath}
	else
		totalCount=`find ${DownloadPath} -size +${fileSize}c -a -name ${fileName} -a -cmin -${cminTime}|wc -l` 
		#echo "$(date "+%Y-%m-%d %H:%M:%S") TotalDownload ${totalCount}" >${infoPath}

fi


#Restart while download number less 1.
if [[ "${totalCount}" -eq 0 ]];then
	if [[ "${currentTime}" -lt 9 ]] || [[ "${currentTime}" -gt 22 ]];then
	echo "$(date "+%Y-%m-%d %H:%M:%S") download number less 1, Restart." >>${logFile}
	echo ${PassWD}|sudo -S shutdown -r now
	fi
fi


#Send data to WebServer
for ((i=1;i<100;i++))
{

	if [[ "${totalCount}" -ge 1 ]];then

		curl -H "Accept: application/json" -H "Content-type: application/json" -X POST \
		-d "{\"mac_address\":\"${ComputerName}\",\"downloads\":${totalCount}}" ${sendAddress} >${infoPath}
		sleep 10	
		countUpload=`awk '/upload_success/' ~/Documents/info.html|wc -l`

			#If send data success, then delete downloads file.
			if [[ "${countUpload}" -eq 1 ]];then
 				echo "$(date "+%Y-%m-%d %H:%M:%S") The ${i} times Success to send, TotalDownload ${totalCount}" >>${logFile}
				find ~/Downloads/ -name ${fileName} -a -cmin +5 | xargs rm -rf
				break;
			else
					echo "$(date "+%Y-%m-%d %H:%M:%S") The ${i} times FaildSend,TotalDownload ${totalCount}" >>${logFile}
					echo "$(date "+%Y-%m-%d %H:%M:%S") Last TotalDownload ${totalCount}" >${infoPath}
			
			fi
	
	fi

now=$(date "+%M")
if (( $startTime - $now == 50 )); then
break;
fi
sleep 50

}

echo "#################### $(date "+%Y-%m-%d %H:%M:%S") End Script. ####################" >>${logFile}