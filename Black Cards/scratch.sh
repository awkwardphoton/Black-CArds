#!/bin/bash
TEMP=$(curl "https://www.bbfc.co.uk/search?q=the%20time%20Machine" | grep -oP -m 1 '(?<=<div class="SearchItem_Wrapper__1lhgt">).*?(?=</div></div>)' | head -1 | tail -1)
            if [[ ${TEMP} != *"Type_base-large__3q3Or\">"* ]];then
              echo "Doesn't have any notes"
            else
              echo "has notes"
            fi