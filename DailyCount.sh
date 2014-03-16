#!/bin/sh
# 脚本作用:统计 CNET 下载 MacBooster 的数量,并把统计数据发送到网站服务器.
# 2014-01-24
# 朱荣华

# 打印日志
# logFile=~/Library/Preferences/CountDownloadLog.txt
# exec 1>>${logFile}
# exec 2>>${logFile}

#统计之前一个小时的下载数量

cminTime=30
DownloadPath=~/Downloads/
infoPath=~/Documents/info.html   
fileName="MacBooster.pkg"
upSize=$((15 * 1024 * 1024))
downSize=$((10 * 1024 *1024))
if [[ -f $infoPath ]];then
		lastCount=`awk '/TotalDownload/ {print $4}' ${infoPath}`
		downloadCount=`find ${DownloadPath} -size -${upSize}c -a -name ${fileName} -cmin -${cminTime}|wc -l` && echo "$(date "+%Y-%m-%d %H:%M:%S") TotalDownload ${downloadCount}" >${infoPath}
		totalCount=$((lastCount+downloadCount))
		else
			totalCount=`find ${DownloadPath} -size -${upSize}c -a -name ${fileName} -cmin -${cminTime}|wc -l` && echo "$(date "+%Y-%m-%d %H:%M:%S") TotalDownload ${downloadCount}" >${infoPath}

	fi




# 区分机器.
ComputerName=`ifconfig|awk '/ether/ {print $2}'|head -1`
#时间间隔
upTime=`date +%M`
SecondTimeCount=`echo $((cminTime + upTime))`
sendAddress="http://iobit.herokuapp.com/pusha"


#发送统计数量到网站服务器
for ((i=1;i<4;i++))
{

	

	#判断下载数量，如果大于1就发送统计数据。
	if [[ "${downloadCount}" -ge 1 ]];then

		curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"mac_address\":\"${ComputerName}\",\"downloads\":${totalCount}}" ${sendAddress} >>${infoPath}

		countUpload=`awk '/upload_success/' ~/Documents/info.html|wc -l`

			#判断是否发送成功，如果成功就删除下载文件。
			if [[ "${countUpload}" -ge 1 ]];then
 				echo "$(date "+%Y-%m-%d %H:%M:%S") 成功发送统计数量到服务器" && rm -rf ${infoPath}
				find ~/Downloads/  -size ${upSize}c -a -name "MacBooster*" -a -cmin +5 #| xargs rm -rf
				break;
			else
				if [[ $i == 1 ]]; then
					echo "$(date "+%Y-%m-%d %H:%M:%S") FaildSend,TotalDownload ${totalCount}" >${infoPath}
				fi
				

			fi
			
	fi

	echo "$(date "+%Y-%m-%d %H:%M:%S") 第${i}次发送统计数据"
	sleep 2
}




				
