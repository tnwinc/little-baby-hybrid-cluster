net user vagrant "Password1" /add
net localgroup "administrators" "vagrant" /add
wmic useraccount where name='vagrant' set PasswordExpires=FALSE