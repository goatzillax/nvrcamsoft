#!/bin/bash

SCRIPTDIR=`dirname $0`
source $SCRIPTDIR/env.sh

HOST=$1
SEGTIME=300

if [ ! -d ${RAMDIR} ]; then
   sleep 5
fi

pushd ${RAMDIR}

while true; do
	${OPENRTSP} -4 -P ${SEGTIME} -b 2097152 -B 2097152 -f 15 -F ${HOST} rtsp://admin:admin@${HOST}:8554/unicast
done
