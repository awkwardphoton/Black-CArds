 for f in *.txt; do
source "$f"

  if [[ $LINES == "2" ]]
    then
      POSITION="1835,726"
    else
      POSITION="592,723"
  fi

  if [[ $RATING == "U" ]]
  then
    ACCENT="#05916e"
    LINE1="Universal. Suitable for all."
    LINE2=""
    INSIGHT=""
  elif [[ $RATING == "PG" ]]
  then
    ACCENT="#fed322"
    LINE1="Parental Guidance. General viewing, but some scenes may be"
    LINE2="unsuitable for young children."
  elif [[ $RATING == "12A" ]]
  then
    ACCENT="#f89246"
    LINE1="May be unsuitable for children under 12."
    LINE2="Children under 12 must be accompanied by an adult."
  elif [[ $RATING == "12" ]]
  then
    ACCENT="#f9afaf"
    LINE1="Suitable only for persons of 12 years or older."
    LINE2=""
  elif [[ $RATING == "15" ]]
  then
    ACCENT="#f9afaf"
    LINE1="Suitable only for persons of 15 years and older."
    LINE2=""
  elif [[ $RATING == "18" ]]
  then
    ACCENT="#ed1b2e"
    LINE1="Suitable only for persons of 18 years and older."
    LINE2=""
  elif [[ $RATING == "R18" ]]
  then
    ACCENT="#0668b3"
    LINE1="Restricted 18. Adult works for licensed premises only."
    LINE2="Suitable only for Adults of 18 years or older."
  fi

seven () {
 convert -size 3840x2160 Resources/7.png \
 -fill white -font ProximaNova-Regular -pointsize 67 -kerning 1 -interline-spacing -4 -draw 'text 459,918 "This is to certify that"' \
 -fill white -font ProximaNova-Regular -pointsize 85 -kerning 0 -interline-spacing -4 -draw 'text '$POSITION' "'"${TITLE^^}"'"' \
 -fill white  -strokewidth 0 -draw "rectangle 456,1146 3395,1151" \
Export/"$TMDBID".png
}

  live () {
    convert -size 3840x2160 Resources/15.png \
    15/logo.png -gravity northwest -geometry +595+165  -composite \
    -fill white -font Comic-Sans-MS -pointsize 50 -kerning 21.5 -draw ' text 2825,205 "CFJ48764"' \
    -fill white  -strokewidth 0 -draw "rectangle 2818,275 3232,277" \
    -fill white  -strokewidth 0 -draw "rectangle 2817,215 2819,277" \
    -fill white  -strokewidth 0 -draw "rectangle 3230,215 3232,277" \
    -fill white  -strokewidth 0 -draw "rectangle 2870,239 2872,277" \
    -fill white  -strokewidth 0 -draw "rectangle 2920,239 2922,277" \
    -fill white  -strokewidth 0 -draw "rectangle 2973,239 2975,277" \
    -fill white  -strokewidth 0 -draw "rectangle 3024,239 3026,277" \
    -fill white  -strokewidth 0 -draw "rectangle 3077,239 3079,277" \
    -fill white  -strokewidth 0 -draw "rectangle 3127,239 3129,277" \
    -fill white  -strokewidth 0 -draw "rectangle 3180,239 3182,277" \
    -fill "$ACCENT" -font Rockwell-Nova -pointsize 35 -kerning 0 -draw " text 592,378 'Age Ratings You Trust'" \
    -fill "$ACCENT" -font RockwellStd-Bold -pointsize 40 -kerning 0 -draw ' text 2906,386 "www.bbfc.co.uk"' \
    -fill white -font RockwellStd-Bold -pointsize 67 -kerning 1 -interline-spacing -4 -draw 'text 596,574 "This is to certify that"' \
    -fill white -font RockwellStd-Bold -pointsize 84 -kerning 0 -interline-spacing -4 -draw 'text 592,723"'"${TITLE^^}"'"' \
    -fill "$ACCENT" -font RockwellStd-Bold -pointsize 69 -kerning 0 -interline-spacing -4 -draw 'text 591,876 "has been classified for cinema exhibition"' \
    -fill "$ACCENT"  -strokewidth 0 -draw "rectangle 593,827 3234,843" \
    15/"${RATING^^}".png -gravity northwest -geometry +827+1084 -composite \
    -fill white -font Rockwell-Nova -pointsize 53 -kerning -1 -interline-spacing -4 -draw 'text 1642,1216 "'"${NOTES,,}"'"' \
    Resources/insight.png -gravity northwest -geometry +1469+1201 -composite \
    -fill "$ACCENT" -font Rockwell-Nova -pointsize 53 -kerning -1.25 -draw ' text 1469,1336 "'"${LINE1}"'"' \
    -fill "$ACCENT" -font Rockwell-Nova -pointsize 53 -kerning -1.25 -draw ' text 1469,1400 "'"${LINE2}"'"' \
    png/Widescreen/President.png -gravity northwest -geometry +581+1780  -composite \
    Resources/Signatures/"${Director}".png -gravity northwest -geometry +1322+1780  -composite \
    -fill white -font ProximaNova-Regular -pointsize 40 -kerning -1.75 -draw ' text 585,1916 "President"' \
    -fill white -font ProximaNova-Regular -pointsize 40 -kerning -1.75 -draw ' text 1327,1916 "Director"' \
    Export/"$TMDBID".png
  }

     live

   done    

#    