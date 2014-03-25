#!/bin/sh
if [[ -d /Applications/MacBooster.app ]]; then

releaseVersion=`sed -n 'N;/CFBundleShortVersionString/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,5)}'`
svnVersion=`sed -n 'N;/CFBundleVersion/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,4)}'`
echo "版本号:${releaseVersion} ${svnVersion}\n"

FreeUrl=`sed -n 'N;/FreeUrl/p' /Applications/MacBooster.app/Contents/Info.plist`
ProUrl=`sed -n 'N;/ProUrl/p' /Applications/MacBooster.app/Contents/Info.plist`
NormalUrl=`sed -n 'N;/XmlUrl/p' /Applications/MacBooster.app/Contents/Info.plist`

echo "试用期内用户的更新地址: \n${FreeUrl}"
echo "注册用户的更新地址: 	  \n${ProUrl}"
echo "过期用户的更新地址: 	  \n${NormalUrl}"


MinimumSystemVersion=`sed -n 'N;/LSMinimumSystemVersion/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,4)}'`

echo "最小支持系统版本: ${MinimumSystemVersion}\n"

OnlineUsers=`sed -n 'N;/OnlineUsers/p' /Applications/MacBooster.app/Contents/Info.plist | awk '/string/ {print substr($0,10,1)}'`
echo "OnlineUsers的值: ${OnlineUsers}\n"

fileOwner=`ls -lR /Applications/MacBooster.app/ | awk '{print $3}' | grep -v "^$" | uniq`
echo "程序文件夹的拥有者为: ${fileOwner}"
else
	echo "You have not install MacBooster!"
fi