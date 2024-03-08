#!/bin/bash

SCRIPTDIR=`dirname $0`
source $SCRIPTDIR/env.sh

FPS=30
BITRATE=600000
NICE="nice -n -10 "

RESOLUTION=`$SCRIPTDIR/picamera_version.py`
echo Using resolution: ${RESOLUTION}

#  fookin vlc or ffmpeg bug somewhere here
#  https://forum.videolan.org/viewtopic.php?t=156419

${NICE}raspivid -o - -t 0 ${RESOLUTION} -fps ${FPS} -b ${BITRATE} -n -a 12 -ae 32,0xff,0x000000 | ${NICE}cvlc --rtsp-timeout 10 -vvv stream:///dev/stdin --sout '#rtp{access=udp,sdp=rtsp://:8554/}' :demux=h264 --h264-fps=${FPS}
