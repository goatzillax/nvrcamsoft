# nvrcamsoft

scripts n stuff for nvr/camera services

## env.sh

environment setup script, mostly functions and pulls in global vars

## globals.sh

global variables

### RAMDIR

staging directory, usually a RAM filesystem

### ARCHIVEDIR

place where files get sent by default

### SCANDIR

secondary place to stuff scanned files because I'm a sneakernet kind of guy

### OPENRTSP

full path to openrtsp executable.  sometimes works better than ffmpeg.  sometimes.

## nvr-openrtsp.sh

openrtsp streaming sink script.  dumps into RAMDIR.

## nvr-ffmpeg.sh

ffmpeg streaming sink script.  dumps into RAMDIR.

## raspivid_rtsp.sh

one of the contortions to produce an RTSP stream on a Raspbooper Pi with a CSI camera attached.

## nvr-archive.sh

Uses inotify to eyeball the RAMDIR for all the recorded stream changeovers.  Can process/transcode files.

## move_n_rotate.sh

Sometimes inotify somehow manages to miss events, and also it might be beneficial to have some sort of watchdog in the background as a crontab or something.

## sammples/

sample fstab and systemd service file
