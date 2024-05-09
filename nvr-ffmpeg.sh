#!/bin/bash

SCRIPTDIR=`dirname $0`
source $SCRIPTDIR/env.sh

URL=$1
HOST=$2
SEGTIME=300
SHUTUP=-nostats

if [ ! -d ${RAMDIR} ]; then
   sleep 5
fi

while true; do
   nice -n -10 ffmpeg ${SHUTUP} -stimeout 5000000 -y -i rtsp://${URL} -c copy -an -f segment -segment_time ${SEGTIME} -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 -segment_format mp4 "${RAMDIR}/${HOST}-%Y%m%d-%H%M%S.mp4"
done
