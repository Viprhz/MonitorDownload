-- 脚本作用：利用AppleScript实现自动下载Cnet安装包。
-- 2014-04-04
-- Viprhz

(*-- 右键退出 -------------------------------------------------------------------------
on quit
	display dialog "真的要退出?" buttons {"是的", "不"}
	if button returned of result = "是的" then
		continue quit
	end if
end quit*)
-------------------------------------------------------------------------
-- 主程序 -----------------------------------------------------------
script AutoDownload
	try
		tell application "Finder"
			do shell script "open -a TextEdit.app ~/Documents/DoNotShutdown.rtf"
			tell application "TextEdit" to set the bounds of the front window to {110, 47, 1390, 750}
		end tell
		open
		
		-- 打印抛出异常的提示信息.
		do shell script "echo '1' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
		
	end try
	repeat
		del_UnFinishTask()
		delay 1
		del_Cookies()
		delay 1
		if application "Safari" exists then
			tell application "Safari" to open location "http://download.cnet.com/MacBooster/3000-18512_4-76014397.html?part=dl-&subj=dl&tag=button"
			tell application "Safari" to set the bounds of the front window to {0, 0, 640, 640}
		else
			launch application "Safari"
		end if
		
		delay 10
		
		(*page_Load(10) --网页加载,30秒等待时间.
		delay 2
		try
			tell application "System Events"
				tell process "Safari"
					set alluis to entire contents of window 1
					repeat with theui in alluis
						if class of theui is UI element then
							if title of theui contains "Download Now" then
								click theui
								exit repeat
							end if
						end if
					end repeat
				end tell
			end tell
		on error errMsg
			-- 打印抛出异常的提示信息.
			do shell script "echo '1' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
			-- exit repeat
		end try
		delay 1*)
		page_Load(20) --网页加载,30秒等待时间.
		try
			tell application "System Events"
				tell process "Safari"
					set alluis to entire contents of window 1
					repeat with theui in alluis
						if class of theui is UI element then
							if title of theui contains "Download Now" then
								click theui
								exit repeat
							end if
						end if
					end repeat
				end tell
			end tell
		on error errMsg
			-- 打印抛出异常的提示信息.
			do shell script "echo '1' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
			-- exit repeat
		end try
		delay 30
		wait_FileDownload(120)
		delay 1
		if application "Safari" exists then
			tell application "Safari"
				if window 1 exists then close window 1
			end tell
		else
			launch application "Safari"
		end if
		
		try
			tell application "Safari" to activate
			tell application "System Events"
				delay 1
				keystroke return
			end tell
		on error errMsg
			-- 打印抛出异常的提示信息.
			do shell script "echo '1' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
			
		end try
	end repeat
end script
run AutoDownload

---------------------------------------------------------------------------------------------------------







-- 打开浏览器,访问下载地址 -------------------------------------------------------------------------
on open_DownloadUrl()
	try
		if application "Safari" exists then
			tell application "Safari" to open location "http://download.cnet.com/MacBooster/3000-18512_4-76014397.html?part=dl-&subj=dl&tag=button"
			return "Already open Download Url"
		else
			return "Safari not exists"
			launch application "Safari"
			delay 2
			tell application "Safari" to open location "http://download.cnet.com/MacBooster/3000-18512_4-76014397.html?part=dl-&subj=dl&tag=button"
		end if
	end try
end open_DownloadUrl
---------------------------------------------------------------------------------------------

-- 删除未完成的下载文件 -------------------------------------------------------------------------
on del_UnFinishTask()
	try
		do shell script "cd ~/Downloads/ && rm -rf *.download "
		return "Already delete Unfinish files"
	on error errMsg
		do shell script "echo '2' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
		
		
	end try
end del_UnFinishTask
---------------------------------------------------------------------------------------------

-- 退出浏览器-------------------------------------------------------------------------
on quitSafari()
	try
		if application "Safari" exists then
			tell application "System Events"
				set theID to (unix id of processes whose name is "Safari")
				do shell script "kill -9 " & theID
				return "Already quit Safari"
				
			end tell
		end if
	on error errMsg
		do shell script "echo '3' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
	end try
end quitSafari
---------------------------------------------------------------------------------------------
-- 删除浏览器Cookies-------------------------------------------------------------------------
on del_Cookies()
	try
		if application "Safari" exists then
			repeat
				tell application "Safari" to activate
				delay 1
				tell application "System Events"
					tell process "Safari"
						keystroke "," using command down
						tell window 1
							try
								tell toolbar 1
									set buttonIndex to count of every button
									set buttonIndex to buttonIndex - 3
									click button buttonIndex
									
									delay 1
								end tell
								
								tell group 1
									tell group 1
										click button 1
										delay 1
										keystroke return
										delay 1
										keystroke "w" using command down
										return "Already delete Cookies"
										exit repeat
									end tell
								end tell
							end try
						end tell
					end tell
				end tell
			end repeat
		else
			launch application "Safari"
		end if
	on error errMsg
		do shell script "echo '4' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
	end try
end del_Cookies
---------------------------------------------------------------------------------------------

-- 判断网页是否加载成功 -------------------------------------------------------------------------
on page_Load(timeout_value) -- in seconds
	try
		delay 1
		
		set i to 0
		try
			tell application "Safari"
				set isLoaded to false
				repeat until isLoaded
					
					try
						tell application "System Events"
							tell process "Safari"
								set alluis to entire contents of window 1
								repeat with theui in alluis
									if class of theui is UI element then
										if title of theui contains "Download Now" then
											set isLoaded to true
											exit repeat
										end if
									end if
								end repeat
							end tell
						end tell
					on error errMsg
						do shell script "echo '5' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
						exit repeat
					end try
					
					delay 1
					set i to i + 1
					if i is timeout_value then return false
					
				end repeat
			end tell
		on error errMsg
			do shell script "echo '6' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
			return false
		end try
		return true
	on error errMsg
		do shell script "echo '7' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
	end try
end page_Load
---------------------------------------------------------------------------------------------


-- 等待下载-------------------------------------------------------------------------
on wait_FileDownload(waitTime)
	try
		set thePath to (path to downloads folder) -- or wherever the items are being downloaded
		set downloadFileCount to 0
		
		repeat
			tell application "Finder"
				set theItems to (files of thePath whose name extension is "download")
				set theCount to (count theItems)
			end tell
			if theCount is 0 then
				return "Already Finish Download"
				exit repeat
			else
				set downloadFileCount to downloadFileCount + 1
				delay 1
				
			end if
			log downloadFileCount
			if downloadFileCount > waitTime then
				
				try
					tell application "System Events"
						set theID to (unix id of processes whose name is "Safari")
						do shell script "kill -9 " & theID
						return "Download Timeout"
					end tell
				end try
				exit repeat
			end if
		end repeat
	on error errMsg
		do shell script "echo '8' $(date \"+%Y-%m-%d %H:%M:%S\") " & errMsg & " >> ~/Desktop/AppleScriptLog.txt"
	end try
end wait_FileDownload
---------------------------------------------------------------------------------------------...
