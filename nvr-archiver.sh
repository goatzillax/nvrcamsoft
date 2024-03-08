#!/bin/bash

SCRIPTDIR=`dirname $0`
source $SCRIPTDIR/env.sh

function process_file() {
	local dir=$1
	local file=$2
	BN=`basename $file .mp4`
	MKV=${RAMDIR}/${BN}.mkv
	nice -19 ffmpeg -i ${dir}${file} -c:v h264_v4l2m2m -b:v 5000k ${MKV}
	#  TODO:  dvr-scan once the library is unfucked
	mv_file $dir$file $ARCHIVEDIR
}

#  Add inotify hooks
#  can't tell if read is dropping events because ffmpeg takes so long, or ffmpeg itself is snarfing stdin.
#  inotify is suppose to have a really long queue...
inotifywait -e close_write -m ${RAMDIR} |
while read dir op file; do
	echo ==============
	echo $dir $op $file

	EXT="${file##*.}"

	if [[ "${EXT}" == "mkv" ]]; then
		#  if SCANDIR exists and has space move sanitized video there
		#  else move to ARCHIVEDIR
		if [ -d ${SCANDIR} ]; then
			AVAIL=$(get_avail_megs $SCANDIR)
			SZ=$(get_file_megs $dir$file)
			if (( ${AVAIL} > ${SZ} )); then
				nice -19 rsync -av --remove-source-files $dir$file ${SCANDIR} &
				continue
			fi
		fi
		mv_file $dir$file ${ARCHIVEDIR}
		continue
	fi

	if [[ $file != wyzecam* ]]; then
		mv_file $dir$file $ARCHIVEDIR &
		continue
	fi

	BIRTH_H=$(get_birth_hour $dir$file)
	if [[ $(in_range ${TIME_START_H} ${BIRTH_H} ${TIME_END_H}) == 0 ]]; then
		echo BUSINESS HOURS R OVER BABY
		mv_file $dir$file $ARCHIVEDIR &
		continue
	fi

	process_file $dir $file &

done

