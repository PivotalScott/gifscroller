#!/bin/bash
if [ "$1" == "" ]; then
    echo 'Usage: ./scroller.sh "Phrase to scroll" [fontname] [color]'
    echo 'To get available fonts, type "convert -list font | grep Font:"'
    echo 'Most normally named colors are available, or go to' 
    echo 'https://imagemagick.org/script/color.php for a more complete listing.'
    echo 'WARNING: Some fonts are wholly unsuitable due to large y stroke dimensions.'
    echo 'The defaults are Arial using the color black.'
    exit 0
else
    mkdir -p scrollertmp
    cd scrollertmp
    if [ "$2" == "" ]; then
        font="Arial"
    else
        font="$2"
    fi
    if [ "$3" == "" ]; then
        color="black"
    else
        color="$3"
    fi
    convert -fill "$color" -font "$font" -pointsize 100 label:"$1" text.png
    width=$(identify text.png | cut -d ' ' -f 3 | cut -d 'x' -f 1)
    newwidth=`expr $width + $width / 7`
    mogrify -gravity center -extent "$newwidth"x128 text.png
    width=$(identify text.png | cut -d ' ' -f 3 | cut -d 'x' -f 1)
    slice=20
    scroll=0
    steps=`expr $width / $slice`
    for increment in $(seq 0 "$steps")
        do
            convert text.png -crop 128x128+"$scroll"+0 "text$increment.png"
            let scroll=`expr $scroll + $slice`
        done
fi
convert -delay 6 -size 128x128 -page +0+0 text%d.png[0-$steps] -loop 0 ../"$1.gif"
cd ..
convert "$1.gif" -fuzz 5% -coalesce -layers OptimizePlus "$1.gif"
convert "$1.gif" +matte +map "$1.gif"
rm -rf scrollertmp
