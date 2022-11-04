#!/bin/bash
echo "Installing Unzip"
sudo apt install unzip
echo "Downloading Project"
wget https://github.com/awkwardphoton/Black-Cards/archive/refs/heads/main.zip && unzip main.zip && rm main.zip && cd Black-Cards-main
echo "Copying Fonts"
cp Fonts/* ~/.local/share/fonts
echo "Copying Project"
cp -R "Black Cards" ~/
echo "Now Enter This Command: cd '~/Black Cards'"
