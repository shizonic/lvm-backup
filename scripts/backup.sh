#!/bin/bash

if [ $(lvs | grep $(date +%F) | wc -l) -eq 0 ]; then
	lvcreate --snapshot --name root_`date +%F` --size 30G ubuntuserver-vg/root /dev/sda1
	echo "Snapshot successfully created"
else
	echo "Snapshot already exists"
fi