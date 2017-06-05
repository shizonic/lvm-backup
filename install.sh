#!/bin/bash

# install backup and cleanup scripts
mkdir -p /mnt/data/backup/scripts
install --mode=744 scripts/* /mnt/data/backup/scripts/

# install systemd service and timer
install --mode=644 systemd/* /etc/systemd/system/
systemctl daemon-reload

# enable & start systemd timer
systemctl enable backup-cleanup.timer && systemctl start backup-cleanup.timer