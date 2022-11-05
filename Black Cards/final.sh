#!/bin/bash

title () {
  clear
  echo "Awkwardphoton's BBFC Black Card Creator Script"
  echo "---------------------------------------------"
}
title
echo Enter Film name
read TITLE
SEARCH=$(echo "$TITLE" | tr -d '[:punct:]')
SEARCH=${SEARCH// /%20}
TITLE=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
TITLE=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<span>).*?(?=</span>)' | head -1 | tail -1)

touch "$TITLE".txt

if [ -f "$TITLE".txt ]
  then
    rm "$TITLE".txt
fi

if [[ $(echo $TITLE | wc -c) -gt "22" ]] && [[ $TITLE == *":"* ]]
  then
    echo LINES="2" >> "$TITLE".txt
    LINEONE=$(echo "$TITLE" | cut -d ":" -f 1)
    LINEONE="$LINEONE:"
    LINETWO=$(echo "$TITLE" | cut -d ":" -f 2)
    LINETWO=$(echo "$LINETWO" | xargs)
    echo TITLE="\"$LINEONE" >> "$TITLE".txt
    echo "$LINETWO\"" >> "$TITLE".txt
    SEARCH=${LINETWO// /%20}
  elif
    [[ $(echo $TITLE | wc -c) -gt "22" ]] && [[ $TITLE == *"-"* ]]
  then
    echo LINES="2" >> "$TITLE".txt
    LINEONE=$(echo "$TITLE" | cut -d "-" -f 1)
    LINEONE="$LINEONE -"
    LINETWO=$(echo "$TITLE" | cut -d "-" -f 2)
    LINETWO=$(echo "$LINETWO" | xargs)
    echo TITLE="\"$LINEONE" >> "$TITLE".txt
    echo "$LINETWO\"" >> "$TITLE".txt
    SEARCH=${LINETWO// /%20}
  elif [[ $(echo $TITLE | wc -w) -gt "4" ]]
    then
      echo LINES="2" >> "$TITLE".txt
      LINEONE=$(echo "$TITLE" | cut -d " " -f -6)
      LINETWO=$(echo "$TITLE" | cut -d " " -f 7-)
      if [[ $(echo $LINEONE | wc -c) -gt "22" ]]; then
      LINEONE=$(echo "$TITLE" | cut -d " " -f -5)
      LINETWO=$(echo "$TITLE" | cut -d " " -f 6-)
      fi
      echo TITLE="\"$LINEONE" >> "$TITLE".txt
      echo "$LINETWO\"" >> "$TITLE".txt
  else
    echo LINES="1" >> "$TITLE".txt
    echo TITLE="\"$TITLE\"" >> "$TITLE".txt
    SEARCH=${TITLE// /%20}     
fi

OPTION_ONE=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=SearchItem_Title__38hx7">).*?(?=<)' | head -1)
OPTION_TWO=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=SearchItem_Title__38hx7">).*?(?=<)' | head -2 | tail -1 )
echo $OPTION_ONE
echo $OPTION_TWO

TITLE=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
TITLE=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<span>).*?(?=</span>)' | head -1 | tail -1)

if [[ $OPTION_ONE == *"$TITLE ("* ]] && [[ $OPTION_TWO == *"$TITLE ("* ]]
 then
  echo "Two Choices"
  PS3='Please enter your choice: '
  options=("$OPTION_ONE" "$OPTION_TWO" "Quit")
  select opt in "${options[@]}"
    do
    case $opt in
        "$OPTION_ONE")
            echo "you chose $OPTION_ONE"
            LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
            YEAR=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<h4 class="Type_base__2EnB2">).*?(?=<)' | head -2 | tail -1)
            RATING=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<="Rated ).*?(?=")' | head -8 | tail -1)
            TEMP=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=<div class="SearchItem_Wrapper__1lhgt">).*?(?=</div></div>)' | head -1 | tail -1)
            if [[ ${TEMP} != *"Type_base-large__3q3Or\">"* ]];then
              echo "Doesn't have any notes"
              NOTES=""
            else
              NOTES=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=3q3Or">).*?(?=</div>)' | head -1)
            fi 
            BBFCref=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -2 | tail -1)
            Classified_Date=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -1 | tail -1)
            TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH%20" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)' | head -1)
            Release_Date=$(curl -s -N "https://api.themoviedb.org/3/movie/ $TMDBID/release_dates?api_key=47d8219645342ad266da600131de56f9" | grep -oP -m 1 '(?<="release_date":").*?(?=T)' | head -1)
            if [ -z "$TMDBID" ] 
              then
                TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH%20y:$YEAR" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)' | head -1)
            fi
            break
            ;;
        "$OPTION_TWO")
            echo "you chose $OPTION_TWO"
            LINK1=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1 | tail -1)
            echo "$LINK1"
            LINK2=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -2 | tail -1)
            echo "$LINK2"
            if [[ "$LINK2" == "$LINK1" ]]; then
              LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -3 | tail -1)
            else
              LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -2 | tail -1)
            fi
            echo "$LINK"
            read -p "pause"
            YEAR=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<h4 class="Type_base__2EnB2">).*?(?=<)' | head -2 | tail -1)
            echo "$YEAR"
            read -p "pause"
            RATING=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<="Rated ).*?(?=")' | head -8 | tail -1)
            echo "$RATING"
            read -p "pause"
            TEMP=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=<div class="SearchItem_Wrapper__1lhgt">).*?(?=</div></div>)' | head -1 | tail -1)
            if [[ ${TEMP} != *"Type_base-large__3q3Or\">"* ]];then
              echo "Doesn't have any notes"
              NOTES=""
            else
              NOTES=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=3q3Or">).*?(?=</div>)' | head -1)
            fi 
            echo "$NOTES"
            read -p "pause"
            BBFCref=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -3 | tail -1)
            echo "$BBFCref"
            read -p "pause"
            Classified_Date=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -1 | tail -1)
            echo "$Classified_Date"
            read -p "pause"
            TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH%20y:$YEAR" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)'  | head -3 | tail -1)
            echo "$TMDBID"
            read -p "pause"
            Release_Date=$(curl -s -N "https://api.themoviedb.org/3/movie/ $TMDBID/release_dates?api_key=47d8219645342ad266da600131de56f9" | grep -oP -m 1 '(?<="release_date":").*?(?=T)' | head -1)
            
            echo "$Release_Date"
            read -p "pause"
            if [ -z "$TMDBID" ] 
              then
               TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH%20y:$YEAR" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)' | head -1)
            fi
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option";;
    esac
done
else
  LINK=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=href="/release/).*?(?=")' | head -1)
  YEAR=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=<h4 class="Type_base__2EnB2">).*?(?=<)' | head -2 | tail -1)
  RATING=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<="Rated ).*?(?=")' | head -8 | tail -1)
   TEMP=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=<div class="SearchItem_Wrapper__1lhgt">).*?(?=</div></div>)' | head -1 | tail -1)
            if [[ ${TEMP} != *"Type_base-large__3q3Or\">"* ]];then
              echo "Doesn't have any notes"
              NOTES=""
            else
              NOTES=$(curl "https://www.bbfc.co.uk/search?q=$SEARCH" | grep -oP -m 1 '(?<=3q3Or">).*?(?=</div>)' | head -1)
            fi 
  BBFCref=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -2 | tail -1)
  Classified_Date=$(curl "https://www.bbfc.co.uk/release/$LINK" | grep -oP -m 1 '(?<=MediaDetails_Value__apBzp">).*?(?=</h4>)' | head -1 | tail -1)
  TMDBID=$(curl -s "https://www.themoviedb.org/search?query=$SEARCH:$YEAR" | cat | grep -oP -m 1 '(?<=class="result" href="/movie/).*?(?=">)' | head -1)
 Release_Date=$(curl -s -N "https://api.themoviedb.org/3/movie/ $TMDBID/release_dates?api_key=47d8219645342ad266da600131de56f9" | grep -oP -m 1 '(?<="release_date":").*?(?=T)' | head -1)
fi


echo YEAR="\"$YEAR\"" >> "$TITLE".txt
echo NOTES="\"$NOTES\"" >> "$TITLE".txt
echo RATING="\"${RATING^^}\"" >> "$TITLE".txt
echo BBFCref="\"$BBFCref\"" >> "$TITLE".txt
echo TMDBID="\"$TMDBID\"" >> "$TITLE".txt
echo Classified_Date="\"$Classified_Date\"" >> "$TITLE".txt
echo Release_Date="\"$Release_Date\"" >> "$TITLE".txt

RATING=${RATING^^}

# BLACK CARD DESIGNS
Start_01=1913-01-01
End_01=1913-12-31
Start_02=1932-01-01
End_02=1932-12-31
Start_03=1967-01-01
End_03=1967-12-31
Start_04=1971-01-01
End_04=1982-12-18
Start_05=1982-12-19
End_05=2002-12-31
Start_07=2003-01-01
End_07=2011-12-31
Start_08=2012-01-01
End_08=2012-02-29
Start_09=2012-03-01
End_09=2012-04-30
Start_10=2012-05-01
End_10=2012-06-30
Start_11=2012-07-01
End_11=2012-08-30
Start_12=2012-08-03
End_12=2012-08-03
Start_13=2012-09-01
End_13=2012-10-31
Start_14=2012-11-01
End_14=2012-12-31
Start_15=2013-01-01
End_15=2019-04-26
Start_16=2019-02-06
End_16=$(date +%F)

# PRESIDENTS OF THE BBFC
# George A. Redford
Start_George_Redford=1913-01-01
End_George_Redford=1916-12-11
# T.P O'Connor
Start_TP_OConnor=1916-12-11
End_TP_OConnor=1929-10-18
# Edward Shortt
Start_Edward_Shortt=1929-10-21
End_Edward_Shortt=1935-10-10
# William Tyrrell
Start_William_Tyrrell=1935-10-25
End_William_Tyrrell=1948-03-22
# Sir Sidney Harris
Start_Sidney_Harris=1948-03-31
End_Sidney_Harris=1960-05-31
# Herbert Morrison, Baron Morrison of Lambeth
Start_Herbert_Morrison=1960-06-1
End_Herbert_Morrison=1965-03-06
# David Ormsby-Gore, 5th Baron of Harlech
Start_David_Ormsby=1965-07-21
End_David_Ormsby=1985-01-26
# George Lascelles, 7th Earl of Harewood
Start_George_Laselles=1985-06-01
End_George_Laselles=1997-12-18
# Andreas Whittham Smith
Start_Andreas_Whittham_Smith=1997-12-18
End_Andreas_Whittham_Smith=2002-08-01
# Sir Quentin Thomas
Start_Quentin_Thomas=2002-08-01
End_Quentin_Thomas=2012-10-17
# Patrick Swaffer
Start_Patrick_Swaffer=2012-10-17
End_Patrick_Swaffer=2022-10-17
# Natasha Kaplinsky
Start_Natasha_Kaplinsky=2022-10-17
End_Natasha_Kaplinsky=$(date +%F)

# DIRECTORS OF THE BBFC
# Joseph Brooke Wilkinson - Chief Executive
Start_Joseph_Brooke_Wilkinson=1913-01-01
End_Joseph_Brooke_Wilkinson=1948-07-15
# A. T. L. Watkins - Chief Executive
Start_ATL_Watkins=1948-07-26
End_ATL_Watkins=1957-01-23
# John Nicholls - Chief Executive
Start_John_Nicholls=1957-01-23
End_John_Nicholls=1958-04-30
# John Trevelyan - Chief Executive
Start_John_Trevelyan=1958-05-22
End_John_Trevelyan=1971-07-01
# Stephen Murphy - Chief Executive
Start_Stephen_Murphy=1971-07-01
End_Stephen_Murphy=1975-06-18
# James Ferman - Director
Start_James_Ferman=1975-06-18
End_James_Ferman=1999-01-10
# Robin Duval - Director
Start_Robin_Duval=1999-01-11
End_Robin_Duval=2004-09-19
# David Cooke - Director
Start_David_Cooke=2004-09-20
End_David_Cooke=2016-03-10
# David Austin - Chief Executive
Start_David_Austin=2016-03-10
End_David_Austin=$(date +%F)





if [[ "$Release_Date" > "$Start_01" ]] && [[ "$Release_Date" < "$End_01" ]]
  then
    BLACKCARD=01
elif [[ "$Release_Date" > "$Start_02" ]] && [[ "$Release_Date" < "$End_02" ]]
  then
    BLACKCARD=02
elif [[ "$Release_Date" > "$Start_03" ]] && [[ "$Release_Date" < "$End_03" ]]
  then
    BLACKCARD=03
elif [[ "$Release_Date" > "$Start_04" ]] && [[ "$Release_Date" < "$End_04" ]]
  then
    BLACKCARD=04
elif [[ "$Release_Date" > "$Start_05" ]] && [[ "$Release_Date" < "$End_05" ]]
  then
    BLACKCARD=05  
elif [[ "$Release_Date" > "$Start_06" ]] && [[ "$Release_Date" < "$End_06" ]]
  then
    BLACKCARD=06
elif [[ "$Release_Date" > "$Start_07" ]] && [[ "$Release_Date" < "$End_07" ]]
  then
    BLACKCARD=07
elif [[ "$Release_Date" > "$Start_08" ]] && [[ "$Release_Date" < "$End_08" ]]
  then
    BLACKCARD=08
elif [[ "$Release_Date" > "$Start_09" ]] && [[ "$Release_Date" < "$End_09" ]]
  then
    BLACKCARD=09
elif [[ "$Release_Date" > "$Start_10" ]] && [[ "$Release_Date" < "$End_10" ]]
  then
    BLACKCARD=10
elif [[ "$Release_Date" > "$Start_11" ]] && [[ "$Release_Date" < "$End_11" ]]
  then
    BLACKCARD=11
elif [[ "$Release_Date" > "$Start_12" ]] && [[ "$Release_Date" < "$End_12" ]]
  then
    BLACKCARD=12
elif [[ "$Release_Date" > "$Start_13" ]] && [[ "$Release_Date" < "$End_13" ]]
  then
    BLACKCARD=13
elif [[ "$Release_Date" > "$Start_14" ]] && [[ "$Release_Date" < "$End_14" ]]
  then
    BLACKCARD=14
elif [[ "$Release_Date" > "$Start_15" ]] && [[ "$Release_Date" < "$End_15" ]]
  then
    BLACKCARD=15
elif [[ "$Release_Date" > "$Start_16" ]] && [[ "$Release_Date" < "$End_16" ]]
  then
    BLACKCARD=16
fi

if [[ "$Release_Date" > "$Start_Joseph_Brooke_Wilkinson" ]] && [[ "$Release_Date" < "$End_Joseph_Brooke_Wilkinson" ]]
  then
    DIRECTOR="Wilkinson"
elif [[ "$Release_Date" > "$Start_ATL_Watkins" ]] && [[ "$Release_Date" < "$End_ATL_Watkins" ]]
  then
    DIRECTOR="Watkins"
elif [[ "$Release_Date" > "$Start_John_Nicholls" ]] && [[ "$Release_Date" < "$End_John_Nicholls" ]]
  then
    DIRECTOR="Nicholls"
elif [[ "$Release_Date" > "$Start_John_Trevelyan" ]] && [[ "$Release_Date" < "$End_John_Trevelyan" ]]
  then
    DIRECTOR="Trevelyan"
elif [[ "$Release_Date" > "$Start_Stephen_Murphy" ]] && [[ "$Release_Date" < "$End_Stephen_Murphy" ]]
  then
    DIRECTOR="Murphy"
elif [[ "$Release_Date" > "$Start_James_Ferman" ]] && [[ "$Release_Date" < "$End_James_Ferman" ]]
  then
    DIRECTOR="Ferman"
elif [[ "$Release_Date" > "$Start_Robin_Duval" ]] && [[ "$Release_Date" < "$End_Robin_Duval" ]]
  then
    DIRECTOR="Duval"
elif [[ "$Release_Date" > "$Start_David_Cooke" ]] && [[ "$Release_Date" < "$End_David_Cooke" ]]
  then
    DIRECTOR="Cooke"
elif [[ "$Release_Date" > "$Start_David_Austin" ]] && [[ "$Release_Date" < "$End_David_Austin" ]]
  then
    DIRECTOR="Austin"
fi
  

if [[ "$Release_Date" > "$Start_George_Redford" ]] && [[ "$Release_Date" < "$End_George_Redford" ]]
  then
    PRESIDENT="Redford"
elif [[ "$Release_Date" > "$Start_TP_OConnor" ]] && [[ "$Release_Date" < "$End_TP_OConnor" ]]
  then
    PRESIDENT="O'Connor"
elif [[ "$Release_Date" > "$Start_Edward_Shortt" ]] && [[ "$Release_Date" < "$End_Edward_Shortt" ]]
  then
    PRESIDENT="Shortt"
elif [[ "$Release_Date" > "$Start_William_Tyrrell" ]] && [[ "$Release_Date" < "$End_William_Tyrrell" ]]
  then
    PRESIDENT="Tyrrell"
elif [[ "$Release_Date" > "$Start_Sidney_Harris" ]] && [[ "$Release_Date" < "$End_Sidney_Harris" ]]
  then
    PRESIDENT="Harris"
elif [[ "$Release_Date" > "$Start_Herbert_Morrison" ]] && [[ "$Release_Date" < "$End_Herbert_Morrison" ]]
  then
    PRESIDENT="Morrison"
elif [[ "$Release_Date" > "$Start_David_Ormsby" ]] && [[ "$Release_Date" < "$End_David_Ormsby" ]]
  then
    PRESIDENT="Ormsby-Gore"
elif [[ "$Release_Date" > "$Start_George_Laselles" ]] && [[ "$Release_Date" < "$End_George_Laselles" ]]
  then
    PRESIDENT="Laselles"
elif [[ "$Release_Date" > "$Start_Andreas_Whittham_Smith" ]] && [[ "$Release_Date" < "$End_Andreas_Whittham_Smith" ]]
  then
    PRESIDENT="Whittham"
elif [[ "$Release_Date" > "$Start_Quentin_Thomas" ]] && [[ "$Release_Date" < "$End_Quentin_Thomas" ]]
  then
    PRESIDENT="Thomas"
elif [[ "$Release_Date" > "$Start_Patrick_Swaffer" ]] && [[ "$Release_Date" < "$End_Patrick_Swaffer" ]]
  then
    PRESIDENT="Swaffer"
elif [[ "$Release_Date" > "$Start_Natasha_Kaplinsky" ]] && [[ "$Release_Date" < "$End_Natasha_Kaplinsky" ]]
  then
    PRESIDENT="Kaplinsky"
fi




if [[ "$DIRECTOR"="James Ferman" ]]
then
  CEO="Director"
fi
if [[ "$DIRECTOR"="Robin Duval" ]]
then
  CEO="Director"
fi
if [[ "$DIRECTOR"="David Cooke" ]]
then
  CEO="Director"
fi

if [[ "$CEO"="" ]]; then
  CEO="Chief Executive"
fi





clear
echo "$TITLE"
echo "Your Film Was Released $Release_Date."
echo "It Used Black Card Design #$BLACKCARD."
echo "The BBFC President Was $PRESIDENT."
echo "The BBFC $CEO Was $DIRECTOR."

touch "$TITLE".txt

if [ -f "$TITLE".txt ]
  then
    rm "$TITLE".txt
fi
echo TITLE="\"$TITLE\"" >> "$TITLE".txt
echo YEAR="\"$YEAR\"" >> "$TITLE".txt
echo NOTES="\"$NOTES\"" >> "$TITLE".txt
echo RATING="\"${RATING^^}\"" >> "$TITLE".txt
echo BBFCref="\"$BBFCref\"" >> "$TITLE".txt
echo TMDBID="\"$TMDBID\"" >> "$TITLE".txt
echo Classified_Date="\"$Classified_Date\"" >> "$TITLE".txt
echo Release_Date="\"$Release_Date\"" >> "$TITLE".txt
echo Director="\"$DIRECTOR\"" >> "$TITLE".txt
echo CEO="\"$CEO\"" >> "$TITLE".txt
echo BlackCard="\"$BLACKCARD\"" >> "$TITLE".txt
echo President="\"$PRESIDENT\"" >> "$TITLE".txt
echo "----------------------------------------------------------"
cat "$TITLE".txt
echo "----------------------------------------------------------"



sixteen () {
  if [[ $LINES == "2" ]]
    then
      POSITION="1835,726"
    else
      POSITION="1835,886"
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

  convert -size 5120x2160 xc:black \
    16/logo.png -gravity northwest -geometry +741+201  -composite \
    -fill white -font ProximaNova-Regular -pointsize 66 -kerning -2.5 -draw " text 3711,232 'Get more info on our app'" \
    -fill white -font ProximaNova-Extrabld -pointsize 90 -kerning -1 -draw " text 3781,307 'bbfc.co.uk/app'" \
    16/"${RATING^^}".png -gravity northwest -geometry +639+698 -composite \
    -fill white -font Yorkten-Slab-Norm-ExBold -pointsize 133 -kerning 2 -interline-spacing -4 -draw 'text '$POSITION' "'"${TITLE^^}"'"' \
    -fill "$ACCENT"  -strokewidth 0 -draw "rectangle 1834,1079 4378,1090" \
    -fill "$ACCENT" -font Yorkten-Slab-Norm-ExBold -pointsize 67 -kerning 1 -draw ' text 1834,1127 "'"${NOTES,,}"'"' \
    -fill white -font ProximaNova-Regular -pointsize 73 -kerning 0 -draw ' text 1835,1251 "'"${LINE1}"'"' \
    -fill white -font ProximaNova-Regular -pointsize 73 -kerning 0 -draw ' text 1835,1338 "'"${LINE2}"'"' \
    Resources/Signatures/"${President}".png -gravity northwest -geometry +708+1768  -composite \
    Resources/Signatures/"${Director}".png -gravity northwest -geometry +1431+1766  -composite \
    -fill white -font ProximaNova-Regular -pointsize 50  -kerning -1 -draw ' text 730,1919 "President"' \
    -fill white -font ProximaNova-Regular -pointsize 50 -draw ' text 1428,1919 "'"${CEO}"'"' \
    -fill white -font ProximaNova-Regular -pointsize 50 -kerning 5 -draw ' text 4102,1919 "CFJ48764"' \
    Export/"$TMDBID".png
   # -fill white -font ProximaNova-Regular -pointsize 50 -draw ' text 3307,1919 "Black Card Designer"' \  
}

 fifteen () {

  if [[ $RATING == "U" ]]
  then
    ACCENT="#009370"
    LINE1="Universal. Suitable for all."
    LINE2=""
  elif [[ $RATING == "PG" ]]
  then
    ACCENT="#009370"
    LINE1="Parental Guidance. General viewing, but some"
    LINE2="scenes may be unsuitable for young children."
  elif [[ $RATING == "12A" ]]
  then
    ACCENT="#ff7d13"
    LINE1="Children under 12 must be accompanied by an adult."
    LINE2=""
  elif [[ $RATING == "12" ]]
  then
    ACCENT="#fabeab"
    LINE1="Suitable only for persons of 12 years or older."
    LINE2=""
  elif [[ $RATING == "15" ]]
  then
    ACCENT="#fabeab"
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
    Resources/Signatures/"${President}".png -gravity northwest -geometry +581+1780  -composite \
    Resources/Signatures/"${Director}".png -gravity northwest -geometry +1322+1780  -composite \
    -fill white -font ProximaNova-Regular -pointsize 40 -kerning -1.75 -draw ' text 585,1916 "President"' \
    -fill white -font ProximaNova-Regular -pointsize 40 -kerning -1.75 -draw ' text 1327,1916 "Director"' \
    Export/"$TMDBID".png
  }

  seven () {
 convert -size 3840x2160 xc:black \
 -fill white -font ProximaNova-Regular -pointsize 45 -kerning -1 -interline-spacing -4 -draw 'text 457,948 "This is to certify that"' \
 -fill white -font Ramabhadra -pointsize 83 -kerning -4 -interline-spacing -4 -draw 'text 451,1128 "'"${TITLE^^}"'"' \
 -fill white -font Arial -pointsize 42 -kerning 0 -interline-spacing -4 -draw 'text 459,1221 "has been classified for cinema exhibition"' \
 -fill white  -strokewidth 0 -draw "rectangle 456,1146 3395,1151" \
 07/logo.png -gravity northwest -geometry +459+387  -composite \
Export/"$TMDBID".png
}

 for f in *.txt; do
source "$f"

if [[ "$BLACKCARD" = 16 ]]; then
  sixteen
elif [[ "$BLACKCARD" = 15 ]]; then
  fifteen
elif [[ "$BLACKCARD" = 07 ]]; then
  seven
else
  echo "Black Card Template not ready for this title!"
  echo "----------------------------------------------------------"
fi
done
