for f in *.txt; do
source "$f"

if [[ $LINES == "3" ]]
then
  POSITION="1594,529"
elif [[ $LINES == "2" ]]
then
  POSITION="1594,661"
elif [[ $LINES == "1" ]]
then
  POSITION="1598,793"
fi

if [[ $RATING == "U" ]]
then
  ACCENT="#0ac700"
  LINE1="Universal. Suitable for all."
  LINE2=""
elif [[ $RATING == "PG" ]]
then
  ACCENT="#fbad00"
  LINE1="Parental Guidance. General viewing, but some"
  LINE2="scenes may be unsuitable for young children."
elif [[ $RATING == "12A" ]]
then
  ACCENT="#ff7d13"
  LINE1="Children under 12 must be accompanied by an adult."
  LINE2=""
elif [[ $RATING == "12" ]]
then
  ACCENT="#ff7d13"
  LINE1="Suitable only for persons of 12 years or older."
  LINE2=""
elif [[ $RATING == "15" ]]
then
  ACCENT="#fb4f93"
  LINE1="Suitable only for persons of 15 years and older."
  LINE2=""
elif [[ $RATING == "18" ]]
then
  ACCENT="#dc0a0a"
  LINE1="Suitable only for persons of 18 years and older."
  LINE2=""
elif [[ $RATING == "R18" ]]
then
  ACCENT="#006ed2"
  LINE1="Restricted 18. Adult works for licensed premises only."
  LINE2="Suitable only for Adults of 18 years or older."
fi


convert -size 3840x2160 xc:black \
    png/Standard/logo.png -gravity northwest -geometry +642+160  -composite \
    -fill white -font ProximaNova-Regular -pointsize 54 -kerning -2.5 -draw " text 2833,189 'Get more info on our app'" \
    -fill white -font ProximaNova-Extrabld -pointsize 76 -kerning -2 -draw " text 2876,243 'bbfc.co.uk/app'" \
    png/Standard/"$RATING".png -gravity northwest -geometry +606+665 -composite \
    -fill white -font Yorkten-Slab-Norm-ExBold -pointsize 125 -kerning -5 -interline-spacing -22 -draw 'text '$POSITION' "'"${TITLE^^}"'"' \
    -fill "$ACCENT"  -strokewidth 0 -draw "rectangle 1602,972 3367,979" \
    -fill "$ACCENT" -font ProximaNova-Extrabld -pointsize 61 -kerning -1 -draw ' text 1596,1043 "'"${NOTES,,}"'"' \
    -fill white -font ProximaNova-Regular -pointsize 63 -kerning -2 -draw ' text 1597,1112 "'"${LINE1}"'"' \
    -fill white -font ProximaNova-Regular -pointsize 63 -kerning -2 -draw ' text 1597,1184 "'"${LINE2}"'"' \
    png/Standard/Signatures.png -gravity northwest -geometry +613+1767  -composite \
    -fill white -font ProximaNova-Regular -pointsize 42  -kerning -1 -draw ' text 638,1886 "President"' \
    -fill white -font ProximaNova-Regular -pointsize 42 -draw ' text 1192,1886 "Chief Executive"' \
    png/Standard/Ethan.png -gravity northwest -geometry +2488+1816  -composite \
    -fill white -font ProximaNova-Regular -pointsize 42 -draw ' text 2487,1886 "Black Card Designer"' \
    -fill white -font ProximaNova-Regular -pointsize 42 -kerning 3 -draw ' text 3152,1886 "CFJ48764"' \
    Export/"$TMDB".png
done