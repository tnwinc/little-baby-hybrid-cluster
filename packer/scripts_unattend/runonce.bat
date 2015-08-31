@echo off
::both upper and lower case is needed in case the case changes in flight
::.bat files are deliberately ignored so that they can be called separately by packer
A:
for /f %%f in ('dir /b') do (
	echo starting %%f >> c:\packer.log
	if %%~xf == .cmd call %%f
	if %%~xf == .ps1 powershell -file %%f
	if %%~xf == .CMD call %%f
	if %%~xf == .PS1 powershell -file %%f
	echo finished %%f >> c:\packer.log
)
echo done > c:\status.txt