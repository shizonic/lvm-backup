#!/bin/bash

lvcreate --snapshot --name root_`date +%F` --size 30G ubuntuserver-vg/root /dev/sda1