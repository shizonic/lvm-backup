#!/bin/bash

# stop & disable systemd timer
systemctl stop backup-cleanup.timer && systemctl disable backup-cleanup.timer

# remove backup and cleanup scripts
rm -rf /mnt/data/backup/scripts

# remove systemd service and timer
rm -f /etc/systemd/system/backup-cleanup.*
systemctl daemon-reload