#!/bin/bash
sudo apt install unzip
wget https://github.com/awkwardphoton/Black-Cards/archive/refs/heads/main.zip && unzip main.zip && rm main.zip && cd Black-Cards-main
cp Fonts/* ~/.local/share/fonts
cp -R "Black-Cards-main/Black Cards" ~/
echo "Now Enter This Command: cd '~/Black Cards'"
