choco cup -y chocolatey
choco install -y packer
choco install -y packer-windows-plugins
choco install -y packer-post-processor-vagrant-vmware-ovf
choco install -y vagrant
go get github.com/iancmcc/packer-post-processor-ovftool
go install github.com/iancmcc/packer-post-processor-ovftool