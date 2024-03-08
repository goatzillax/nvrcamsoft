#!/bin/bash

SCRIPTDIR=`dirname $0`
source $SCRIPTDIR/env.sh

#  Want to keep 500M free at all times
NEEDED=500

delete_oldest ${ARCHIVEDIR} ${NEEDED}

#  Why did I not do this as a service?  I have no idea.
find ${RAMDIR} -type f -mmin +10 -exec nice -19 rsync -av --remove-source-files {} ${ARCHIVEDIR} \;

#  sigh...  technically if the rsync fails we probably want to prevent staging from filling up...
