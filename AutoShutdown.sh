#!/bin/bash
# 脚本作用：每天自动重启电脑。
# 2014-01-24
# Viprhz
echo "Please input your Computer Password."
if read -s -t 3 ComputerPW
	then 
echo ${ComputerPW} >~/Documents/PWinfo.txt
fi
PassWD=`cat ~/Documents/PWinfo.txt`
currentTime=`date +%y%m%d`
# if [[ $currentTime = 140131 ]];then
# 	shutdownTime=140201
# else
# shutdownTime=$((currentTime+1))
# fi
echo ${PassWD}|sudo -S shutdown -r now
echo "$(date "+%Y-%m-%d %H:%M:%S") Sucess set shutdown">>~/Documents/Set.txt

