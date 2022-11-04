#!/bin/bash
mkdir Export
	for f in *.png;	
	do

	ffmpeg -loop 1 -i "${f%????}".png -c:v libx264 -t 10 -pix_fmt yuv420p -vf scale=3840:2160 "${f%????}".mp4
	ffmpeg -i "${f%????}".mp4 -vf fade=in:0:d=1 "${f%????}"-tmp.mp4
	rm "${f%????}".mp4
	ffmpeg -i "${f%????}"-tmp.mp4 -vf fade=out:192:d=1 "${f%????}".mp4
	rm "${f%????}"-tmp.mp4
done