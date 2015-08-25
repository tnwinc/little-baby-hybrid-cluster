#FROM windowsservercore
FROM microsoft/iis
LABEL Description="Some hello world site"
RUN @powershell -NoProfile -ExecutionPolicy unrestricted -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin 
RUN choco install -fy nssm
RUN choco install -fy etcd
RUN sc config etcd start= auto
