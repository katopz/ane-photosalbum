#!/bin/bash
echo "packing ane-photosalbum..."
cd /Volumes/exFAT/anes/ane-photosalbum/as3/bin
adt -package -target ane ane-photosalbum.ane extension.xml -swc ane-photosalbum.swc -platform iPhone-ARM library.swf libPhotosAlbum.a
echo "Done!"