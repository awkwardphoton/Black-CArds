#!/bin/bash

sudo apt install unzip -y
unzip *.zip
cp Black-Cards-main/Fonts/* ~/.local/share/fonts
cp -R "Black-Cards-main/Black Cards" ~/
echo "Now Enter This Command: cd '~/Black Cards'"
