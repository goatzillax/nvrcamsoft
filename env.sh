#  need SCRIPTDIR set

source ${SCRIPTDIR}/globals.sh

#  lib functions -- don't use any globals!

function get_avail_megs() {
	local AVAIL=`df -m --output=avail $1 | tail -n1`
	echo ${AVAIL}
}

# string is two digit zero padded.
function get_birth_hour() {
	local HOUR=`stat -c %w $1  | cut -c 12-13`
	echo $((10#$HOUR))
}

# shaddap megs
function get_file_megs() {
	echo `du -m $1 | cut -f1`
}

# return $1 < $2 < $3
function in_range() {
	local TIME=$2
	if (( $TIME > $1 && $TIME < $3 )); then
		echo 1
	else
		echo 0
	fi
}

function delete_oldest() {
	local TARGET=$1
	local NEEDED=$2
	pushd $TARGET || return 1

	local AVAIL=$(get_avail_megs .)
	echo avail=$AVAIL needed=$NEEDED
	while [ $AVAIL -lt $NEEDED ]; do
		echo Avail=${AVAIL} need=${NEEDED}
		local baleetme=`ls -1t | tail -n 1`
		echo deleting $baleetme
		rm $baleetme
		AVAIL=$(get_avail_megs .)
	done
	popd
}

function mv_file() {
	local FN=$1
	local DEST=$2
	local SZ=$(get_file_megs $FN)

	echo SZ=${SZ}
	delete_oldest ${DEST} $((SZ * 2))
	nice -19 rsync -av --remove-source-files ${FN} ${DEST} 
}

#function dvr_scan() {
#}

function transcode() {
	local input=$1
	local output=$2
	nice -19 ffmpeg -itsscale 0.885 -i $input -c:v h264_v4l2m2m -b:v 5000k $output
}


