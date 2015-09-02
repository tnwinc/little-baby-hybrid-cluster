Start-Transcript -Append -Path c:\packer.log

$iso = $false
if (Test-Path C:\Users\Packer\windows.iso) { $iso = "C:\Users\packer\windows.iso" }
if (Test-Path C:\users\packer\VBoxGuestAdditions.iso) { $iso = "C:\Users\packer\VBoxGuestAdditions.iso" }

if (!$iso) { Write-Error "VM tools not found"; Exit 1 }

Write-Output "The ISO is $iso"
Write-Output "PACKER_BUILDER_TYPE = $($ENV:PACKER_BUILDER_TYPE)"

if (Get-Command "Mount-DiskImage" -ErrorAction SilentlyContinue)
{
    Write-Output "Use powershell to mount $iso"
    $mountResult = Mount-DiskImage -ImagePath $iso -PassThru
    $driveLetter = ($mountResult | Get-Volume).DriveLetter
}
else
{
    Write-Output "Use WinCDEmu to mount $iso"
    wget -Uri http://sysprogs.com/files/WinCDEmu/PortableWinCDEmu-4.0.exe -OutFile "$($ENV:SystemRoot)\temp\wincdemu.exe"
    & "$($ENV:SystemRoot)\temp\wincdemu.exe" /install
    & "$($ENV:SystemRoot)\temp\wincdemu.exe" $iso V:
    $driveLetter = "V"
}

Write-Output "VM tools mounted to $driveLetter"

if ($ENV:PACKER_BUILDER_TYPE -eq "vmware-iso")
{
    #deal with PowerShells foolishness around executing external commands
    write-output "$($driveLetter):\setup.exe /s /v""/qn REBOOT=R""" | Out-File c:\vmtools.bat -Encoding ascii
    & c:\vmtools.bat
}


if ($ENV:PACKER_BUILDER_TYPE -eq "virtualbox-iso")
{
    Write-Output "MIIFhzCCBG+gAwIBAgIQUcoAmBb9vYDxIOAV7nWCPjANBgkqhkiG9w0BAQUFADCBtDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykxMDEuMCwGA1UEAxMlVmVyaVNpZ24gQ2xhc3MgMyBDb2RlIFNpZ25pbmcgMjAxMCBDQTAeFw0xMzEyMjMwMDAwMDBaFw0xNjEyMjIyMzU5NTlaMIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEXMBUGA1UEBxMOUmVkd29vZCBTaG9yZXMxGzAZBgNVBAoUEk9yYWNsZSBDb3Jwb3JhdGlvbjE+MDwGA1UECxM1RGlnaXRhbCBJRCBDbGFzcyAzIC0gTWljcm9zb2Z0IFNvZnR3YXJlIFZhbGlkYXRpb24gdjIxEzARBgNVBAsUClZpcnR1YWxCb3gxGzAZBgNVBAMUEk9yYWNsZSBDb3Jwb3JhdGlvbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANwEJ826OPc0dQqohvPo8OprhqT2LS87oHT5KiC0o9TiunxC+WEEcTp6L4zHRsyo6mvnADrR1SPDpYFFbxj9znYSjfiS0DDw3svfY0ladTs3IGnfsd49nD3NjfecJlyNM2i8iCl3v/Q68k+A7WZzUwdxdyTATpj3iSdXmdTjiJUEpGozLSpzX/0y2bxnhIZSBMb5l2gQqsNIluMVcosVQLBXq8rZAy9kzycczKUxAezhbKyNPY+0pOeLrY2TH5ah/z+counq4ZjnQCRYhBhqIz3lDK25q4y9zl8byW/CoV4fULa81GH+Zes1OK4NHX7JnOb3D9S4VJSaN644sb+s0xcCAwEAAaOCAXswggF3MAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQDAgeAMEAGA1UdHwQ5MDcwNaAzoDGGL2h0dHA6Ly9jc2MzLTIwMTAtY3JsLnZlcmlzaWduLmNvbS9DU0MzLTIwMTAuY3JsMEQGA1UdIAQ9MDswOQYLYIZIAYb4RQEHFwMwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYTATBgNVHSUEDDAKBggrBgEFBQcDAzBxBggrBgEFBQcBAQRlMGMwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnZlcmlzaWduLmNvbTA7BggrBgEFBQcwAoYvaHR0cDovL2NzYzMtMjAxMC1haWEudmVyaXNpZ24uY29tL0NTQzMtMjAxMC5jZXIwHwYDVR0jBBgwFoAUz5mp6nsm9EvJjo/X8AUm7+PSp50wEQYJYIZIAYb4QgEBBAQDAgQQMBYGCisGAQQBgjcCARsECDAGAQEAAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQChxA2+RiSKslK7yUo1yb32/8BrvbmSVTNkjWicIgbokD+XLxyU0TsHZMmxPrDc+B/uiiZwnanACzDl+IFYyK3KctsxBOMZ2wdTtLLJ4hJF7uWA66DyXcZkPyw1z1kH+y47KaG7Xw1VDIDJy73wdmm5j6d2Ry4z4TGN+Fka5lTyhmYCmRzxPJo8hiiXbVen3SEJTFZYPjT3ptw0i/kZbeHpBE33BdW1wAf/BzEbOV7VfL9EygwLz0lkqDOpjBGF9qJrqJvEpBT7ri+Rj0t5iKkzhy1X78znMDpY6+UECIX36bz0/e7W+LLXia8h8d7UZQax/cyv+JdvWt6eIl4548X1" | Out-File c:\oracle-cert.cer -Encoding ascii
    & certutil -addstore -f "TrustedPublisher" C:\oracle-cert.cer 
    #deal with PowerShells foolishness around executing external commands
    write-output "$($driveLetter): `n start /wait VBoxWindowsAdditions.exe /S" | Out-File c:\vmtools.bat -Encoding ascii
    & c:\vmtools.bat
}

if ($ENV:PACKER_BUILDER_TYPE -eq "parallels-iso")
{
    #deal with PowerShells foolishness around executing external commands
    write-output "$($driveLetter):\PTAgent.exe /install_silent" | Out-File c:\vmtools.bat -Encoding ascii
    & c:\vmtools.bat
}

if (Get-Command "Mount-DiskImage" -ErrorAction SilentlyContinue)
{
    Write-Output "Use powershell"
    Dismount-DiskImage -ImagePath $iso
}
else
{
    Write-Output "Use WinCDEmu"
    & "$($ENV:SystemRoot)\temp\wincdemu.exe" /umountall
    & "$($ENV:SystemRoot)\temp\wincdemu.exe" /uninstall
}
Write-Output "Tools installed"
Stop-Transcript
exit 0