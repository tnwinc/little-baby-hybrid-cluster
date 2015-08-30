A:
for /f %%f in ('dir /b *.cmd') do (
	echo starting %%f c:\packer.log
	call %%f
	echo finished %%f c:\packer.log
)
echo done > c:\status.txt