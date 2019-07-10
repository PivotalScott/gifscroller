# gifscroller
Just bash practice with ImageMagick to create scrolling gif emoji for Slack

```
Usage: ./scroller.sh [options] "Phrase to scroll"
A working ImageMagick installation is required for this tool!
Options:
    -f <font name>, --font <font name>, default font is arial.
        To get available fonts, type "convert -list font | grep Font:"
        WARNING: Some fonts are wholly unsuitable due to excessive y dimensions
    -c <color>, --color <color>, default color is black
    -b <color>, --background <color>, default color is white
        Most normally named colors are available for -c or -b, or go to
        https://imagemagick.org/script/color.php for a more complete listing.
        You can also use standard RGB #000000 - #FFFFFF
```