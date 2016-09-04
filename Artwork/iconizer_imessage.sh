#!/bin/sh

# Based on https://gist.github.com/crishoj/f08d9183caee9d6262a6

# Exit on first error
set -e

XCODE_STICKERS_ICON_SET="../MessagesExtension/Assets.xcassets/iMessage App Icon.stickersiconset"
APP_ICON_FILE=redpoll_icon_imessage.png

if [ ! -x "$(command -v convert)" ]
    then
        echo "Executable 'convert' not found in path. Please install Imagemagick."
else
    echo "Creating icons into $XCODE_STICKERS_ICON_SET"
    IFS=','
    for i in 54,40 64,48 81,60 96,72 120,90 134,100 148,110 180,135 1024,768
      do
        set -- $i
        echo "Creating $1x$2 px icon"
        convert $APP_ICON_FILE -resize $1x$2\! "$XCODE_STICKERS_ICON_SET/Icon-$1_$2.png"
    done

    echo "Complete!"
fi