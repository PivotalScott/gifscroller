#!/bin/bash


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--color)
    color="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--background)
    background="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--font)
    font="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
echo "$color  $background  $font  $1"

pointsize=100

if [ "$1" == "" ]; then
    echo 'Usage: ./scroller.sh [options] "Phrase to scroll"'
    echo 'A working ImageMagick installation is required for this tool!'
    echo 'Options:' 
    echo '    -f <font name>, --font <font name>, default font is arial.'
    echo '        To get available fonts, type "convert -list font | grep Font:"'
    echo '        WARNING: Some fonts are wholly unsuitable due to excessive y dimensions'
    echo '    -c <color>, --color <color>, default color is black'
    echo '    -b <color>, --background <color>, default color is white'
    echo '        Most normally named colors are available for -c or -b, or go to' 
    echo '        https://imagemagick.org/script/color.php for a more complete listing.'
    echo '        You can also use standard RGB #000000 - #FFFFFF'
    echo ''
    exit 0
else
    mkdir -p scrollertmp
    cd scrollertmp
    if [ "$font" == "" ]; then
        font="Arial"
    fi
    if [ "$color" == "" ]; then
        color="black"
    fi
    if [ "$background" == "" ]; then
        background="white"
    fi

    convert -fill "$color" -font "$font" -background "$background" -pointsize $pointsize label:"$1" text.png
    width=$(identify text.png | cut -d ' ' -f 3 | cut -d 'x' -f 1)
    newwidth=`expr $width + $pointsize \* 2`
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
