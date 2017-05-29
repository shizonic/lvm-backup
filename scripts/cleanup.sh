#!/bin/bash

datediff () {
	d1=$(date -d "$1" +%s)
	d2=$(date -d "$2" +%s)
	echo $(( (d1 - d2) / 86400 )) days
}

SNAP_DATES=$(lvs | grep -Po '(?<=root_)([0-9]{4}-[0-9]{2}-[0-9]{2})')