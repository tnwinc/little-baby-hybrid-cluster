rmdir /s /q output-vmware-iso
rmdir /s /q output-virtualbox-iso
::packer build -only=vmware-iso windows_2016_tp3.json
packer build -only=virtualbox-iso windows_2016_tp3.json
