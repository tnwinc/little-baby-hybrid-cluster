echo started runonce >> c:\vagrant.log
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"
start /wait C:\Windows\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"
cscript %systemroot%\system32\winrm.vbs quickconfig -q
cscript %systemroot%\system32\winrm.vbs quickconfig -transport:http
cscript %systemroot%\system32\winrm.vbs set winrm/config @{MaxTimeoutms="1800000"}
cscript %systemroot%\system32\winrm.vbs set winrm/config/winrs @{MaxMemoryPerShellMB="800"}
cscript %systemroot%\system32\winrm.vbs set winrm/config/service @{AllowUnencrypted="true"}
cscript %systemroot%\system32\winrm.vbs set winrm/config/service/auth @{Basic="true"}
cscript %systemroot%\system32\winrm.vbs set winrm/config/client/auth @{Basic="true"}
cscript %systemroot%\system32\winrm.vbs set winrm/config/listener?Address=*+Transport=HTTP @{Port="5985"} 
net stop winrm 
sc config winrm start= auto
net start winrm
netsh advfirewall firewall set rule group="remote administration" new enable=yes 
netsh firewall add portopening TCP 5985 "Port 5985" 

%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f
%SystemRoot%\System32\reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f
wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE

echo finished runonce >> c:\vagrant.log