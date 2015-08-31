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

:: firewall rules after restart to make sure packer isn't ambushed
netsh advfirewall firewall set rule group="remote administration" new enable=yes 
netsh firewall add portopening TCP 5985 "Port 5985" 
powershell -Command "Get-NetFirewallRule -DisplayGroup 'Remote Desktop' | Enable-NetFirewallRule"