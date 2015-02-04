#!/bin/bash
echo "packing ane-photosalbum..."
adt -package -target ane ane-photosalbum.ane extension.xml -swc ane-photosalbum.swc -platform iPhone-ARM library.swf libPhotosAlbum.a
echo "Done!"