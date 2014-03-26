#!/bin/sh
# 脚本作用:项目发布版本测试项.
# 2014-03-25
# Viprhz

if [[ -d /Applications/MacBooster.app ]]; then
# 打印版本号
releaseVersion=`sed -n 'N;/CFBundleShortVersionString/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,5)}'`
svnVersion=`sed -n 'N;/CFBundleVersion/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,4)}'`
echo "版本号:${releaseVersion} ${svnVersion}\n"
# 打印更新地址
FreeUrl=`sed -n 'N;/FreeUrl/p' /Applications/MacBooster.app/Contents/Info.plist`
ProUrl=`sed -n 'N;/ProUrl/p' /Applications/MacBooster.app/Contents/Info.plist`
NormalUrl=`sed -n 'N;/XmlUrl/p' /Applications/MacBooster.app/Contents/Info.plist`

echo "试用期内用户的更新地址: \n${FreeUrl}"
echo "注册用户的更新地址: 	  \n${ProUrl}"
echo "过期用户的更新地址: 	  \n${NormalUrl}"
# 打印最小支持系统版本
MinimumSystemVersion=`sed -n 'N;/LSMinimumSystemVersion/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,4)}'`
echo "最小支持系统版本: ${MinimumSystemVersion}\n"

OnlineUsers=`sed -n 'N;/OnlineUsers/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,1)}'`
echo "OnlineUsers的值: ${OnlineUsers}\n"
# 打印程序文件拥有者
fileOwner=`ls -lR /Applications/MacBooster.app/ | awk '{print $3}' | grep -v "^$" | uniq`
echo "程序文件夹的拥有者为: ${fileOwner}\n"

	else
	echo "You have not install MacBooster!"
fi