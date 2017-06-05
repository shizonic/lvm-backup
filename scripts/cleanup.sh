#!/bin/bash

SNAPSHOTS=$(lvs | awk '/root_/ {print}') # get snapshots of root partition
SNAPSHOT_NAMES=( $(printf '%s' "${SNAPSHOTS[@]}" | awk '/root_/ {print $1}') )

#
# CLEANUP BY SIZE
#
MAX_SIZE=50 # in gigabytes
SNAPSHOTS_SIZE=$(printf '%s\n' "${SNAPSHOTS[@]}" | awk '/root_/ {size = size + substr($4, 0, 5)} END {print size}')

if (( $(echo "$SNAPSHOTS_SIZE > $MAX_SIZE" | bc -l) )); then
	echo "Removing snapshot... ${SNAPSHOT_NAMES[0]}"
	lvremove -f ubuntuserver-vg/${SNAPSHOT_NAMES[0]}
fi


#
# CLEANUP BY AGE
#


datediff () {
	d1=$(date -d "$1" +%s)
	d2=$(date -d "$2" +%s)
	echo $(( (d1 - d2) / 86400 )) days
}

SNAPSHOT_DATES=$(printf '%s\n' "${SNAPSHOTS[@]}" | grep -Po '(?<=root_)([0-9]{4}-[0-9]{2}-[0-9]{2})')