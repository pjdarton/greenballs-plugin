#!/bin/sh

fail() {
  echo "$@" >&2
  exit 1
}

which convert >/dev/null 2>&1 || fail "convert not found - install imagemagick"
which inkscape >/dev/null 2>&1 || fail "inkscape not found - install inkscape"
which pngcrush >/dev/null 2>&1 || fail "pngcrush not found - install pngcrush"
which optipng >/dev/null 2>&1 || fail "optipng not found - install optipng"


# Originals are for dark/mid/highlight
# Hue/Sat/Black 89/100/49, 77/100/72, 59/90/100
# So we want constant hue, different brightness
# So hue 75 is yellowy-green, hue 100 is green
# Sat 100, 100, 90 and Black 50, 75, 100 should be ok.
# Hue 75
#GREEN_DARK='608000'
#GREEN_MID='8fbf00'
#GREEN_HIGHLIGHT='C6ff19'
# Hue 100
#GREEN_DARK='2a8000'
#GREEN_MID='40bf00'
#GREEN_HIGHLIGHT='66ff19'
# Hue 125
GREEN_DARK='00800b'
GREEN_MID='00bf10'
GREEN_HIGHLIGHT='19ff2d'
# Hue 125 then manually tweaked
GREEN_DARK='209020'
GREEN_MID='40dd40'
GREEN_HIGHLIGHT='aaffaa'
# Hue 150
#GREEN_DARK='008040'
#GREEN_MID='00bf60'
#GREEN_HIGHLIGHT='19ff8c'

putSvgBack() {
  mv -f green.svg.orig green.svg
}
[ ! -f green.svg.orig ] && mv green.svg green.svg.orig
trap putSvgBack EXIT

sed \
  -e "s,color:#4e9700,color:#${GREEN_DARK},g" \
  -e "s,color:#417e00,color:#${GREEN_DARK},g" \
  -e "s,color:#96d100,color:#${GREEN_MID},g" \
  -e "s,color:#84b800,color:#${GREEN_MID},g" \
  -e "s,color:#fffc32,color:#${GREEN_HIGHLIGHT},g" \
  -e "s,color:#fffc19,color:#${GREEN_HIGHLIGHT},g" \
  green.svg.orig > green.svg
rm -rf 16x16 24x24 32x32 48x48
./make.sh || fail "make.sh failed"
./makeBalls.sh || fail "makeBalls.sh failed"

