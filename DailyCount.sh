#!/bin/sh
# 脚本作用:统计下载文件的数量,并把统计数据发送到网站服务器.
# 2014-01-24
# Viprhz

# Print Log
logFile=~/Library/Preferences/CountDownloadLog.txt
# exec 1>>${logFile}
# exec 2>>${logFile}

#Count downloads file
cminTime=30
DownloadPath=~/Downloads/
infoPath=~/Documents/info.html   
fileName="MacBooster*"

fileSize=$((12 * 1000 *1024))
if [[ -f $infoPath ]];then
		lastCount=`awk '/TotalDownload/ {print $4}' ${infoPath}`
		currentCount=`find ${DownloadPath} -size +${fileSize}c -a -name ${fileName} -cmin -${cminTime}|wc -l`
		echo "$(date "+%Y-%m-%d %H:%M:%S") TotalDownload ${currentCount}" >${infoPath}
		totalCount=$((lastCount+currentCount))
	else
		totalCount=`find ${DownloadPath} -size +${fileSize}c -a -name ${fileName} -cmin -${cminTime}|wc -l` 
		echo "$(date "+%Y-%m-%d %H:%M:%S") TotalDownload ${totalCount}" >${infoPath}

fi

ComputerName=`ifconfig|awk '/ether/ {print $2}'|head -1`
sendAddress="http://iobit.herokuapp.com/push"


#Send data to WebServer
for ((i=1;i<4;i++))
{

	if [[ "${totalCount}" -ge 1 ]];then

		curl -H "Accept: application/json" -H "Content-type: application/json" -X POST \
		-d "{\"mac_address\":\"${ComputerName}\",\"downloads\":${totalCount}}" ${sendAddress} >>${infoPath}

		countUpload=`awk '/upload_success/' ~/Documents/info.html|wc -l`

			#If send data success, then delete downloads file.
			if [[ "${countUpload}" -ge 1 ]];then
 				echo "$(date "+%Y-%m-%d %H:%M:%S") Success to send" && rm -rf ${infoPath}
				find ~/Downloads/ -name ${fileName} -a -cmin +5 | xargs rm -rf
				break;
			else
				if [[ $i == 1 ]]; then
					echo "$(date "+%Y-%m-%d %H:%M:%S") FaildSend,TotalDownload ${totalCount}" >${infoPath}
					find ~/Downloads/ -name ${fileName} -a -cmin +5 | xargs rm -rf
				fi
				

			fi
			
	fi
	echo "$(date "+%Y-%m-%d %H:%M:%S") The${i}times send"
	sleep 2
}

