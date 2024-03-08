#!/usr/bin/env python3

# V3 resolution use 2304 x 1296 (HDR, which is the only mode worth a shit -- imx708?)
# V2 resolution use 1640 x 1232
# V1 resolution use 1296 x 972

import picamera

with picamera.PiCamera() as cam:
   #print(cam.revision)
   if cam.revision == "ov5647":
      print("-w 1296 -h 972")
   elif cam.revision == "imx219":
      print("-w 1640 -h 1232")
   #  And if nothing matches, just leave it empty
