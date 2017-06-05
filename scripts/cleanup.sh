#!/bin/bash

#
# CONFIG
#

MAX_SIZE=250 # in gigabytes
MAX_AGE=7 # in days

#
# CLEANUP BY SIZE
#

SNAPSHOTS=$(lvs | awk '/root_/ {print}') # get snapshots of root partition
SNAPSHOT_NAMES=( $(printf '%s' "${SNAPSHOTS[@]}" | awk '/root_/ {print $1}') )
SNAPSHOTS_SIZE=$(printf '%s\n' "${SNAPSHOTS[@]}" | awk '/root_/ {size = size + substr($4, 0, 5)} END {print size}')

echo "Checking maximum size ..."
if (( $(echo "$SNAPSHOTS_SIZE > $MAX_SIZE" | bc -l) )); then
	echo "Removing snapshot... ${SNAPSHOT_NAMES[0]}"
	lvremove -f ubuntuserver-vg/${SNAPSHOT_NAMES[0]}
fi


#
# CLEANUP BY AGE
#

SNAPSHOTS=$(lvs | awk '/root_/ {print}') # get snapshots of root partition
SNAPSHOT_NAMES=( $(printf '%s' "${SNAPSHOTS[@]}" | awk '/root_/ {print $1}') )
SNAPSHOT_DATES=$(printf '%s\n' "${SNAPSHOTS[@]}" | grep -Po '(?<=root_)([0-9]{4}-[0-9]{2}-[0-9]{2})')

echo "Checking maximum age ..."
for SNAPSHOT_DATE in $SNAPSHOT_DATES; do
	TODAY_TIMESTAMP=$(date +%s)
	SNAPSHOT_TIMESTAMP=$(date -d $SNAPSHOT_DATE +%s)
	SNAPSHOT_AGE_TIMESTAMP=$(echo "$TODAY_TIMESTAMP - $SNAPSHOT_TIMESTAMP" | bc)
	SNAPSHOT_AGE_DAYS=$(echo "$SNAPSHOT_AGE_TIMESTAMP / 86400" | bc)

	if (( $(echo "$SNAPSHOT_AGE_DAYS > $MAX_AGE" | bc -l) )); then
		SNAPSHOT_NAME=$(echo "root_$SNAPSHOT_DATE")
		echo "Removing snapshot... $SNAPSHOT_NAME"
		lvremove -f ubuntuserver-vg/${SNAPSHOT_NAME}
	fi
done