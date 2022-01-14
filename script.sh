#!/usr/bin/env bash
#author: Harshvardhan J. Pandit
#github: coolharsh55

#script: Takes a PDF and creates a HTML slideshow for it

#requirements: 
#   - pdftoppm: export PDF pages as png images
#   - pngquant: compress pngs
#   - awk: insert link to images in HTML template for slideshow

#inputs:
#   1: path to PDF file
# TODO rest of inputs using a better parameter management method
#   2: path to output folder
#   3: path to reveal js (could be on web)
#   4: path to HTML template (needs to be on disk)

echo "JOB: to convert $1 to HTML slideshow"

# Step1: convert PDF to images
# pdftoppm will extract each page as a png
echo -n "Step1: exporting $1 pages as PNG to $2 ... "
pdftoppm $1 ${2}/slide -png
echo "DONE"

# Step2: compress PNG images for the web
# pngquant will compress images
# -s 1 uses aggressive compression
# -f forces overwriting output files if they exist (for us its same as input)
echo -n "Step2: Compressing PNG files ... "
for f in ${2}/*.png; do
    pngquant $f -s 1 -f -o $f
done
echo "DONE"

# Step3: insert link to images in HTML template
# this link is hardcoded for convenience
cp ./template.html ${2}/index.html
echo -n "Step3: inserting links to PNG in reveal.js HTML ... "
slides=($(ls -1 ${2}/*.png | sort -r))
for f in "${slides[@]}"; do
    f=$(basename $f)
    img="<section><img src='$f'></section>"
    sed -i "16i $img" ${2}/index.html 
done;
echo "DONE"
