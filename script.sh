#!/usr/bin/env bash
#author: Harshvardhan J. Pandit
#github: coolharsh55

#script: Takes a PDF and creates a HTML slideshow for it

#requirements: 
#   - pdftoppm: export PDF pages as png images
#   - pngquant: compress pngs
#   - sed: insert link to images in HTML template for slideshow

# Handling arguments / flags
while getopts "p:f" opt; do
    case "${opt}" in
        p)
            file=${OPTARG}
            ;;
        f)
            FORCE_PROCESSING=1
            ;;
        *)
            ;;
    esac
done

dir=$(dirname "$file")

# Check if $dir/index.html exists, if yes, skip this file
if [[ -f "$dir/index.html" ]]; then
    if [[ -n $FORCE_PROCESSING ]]; then
        echo "Forcing re-processing of HTML version"
    else
        echo "HTML version exists. Skipping processing..."
        exit
    fi
fi

# Step1: convert PDF to images
# pdftoppm will extract each page as a png
echo -n "#1: Exporting $file pages as PNG to $dir ... "
pdftoppm "$file" "${dir}"/slide -png
echo "DONE"

# Step2: compress PNG images for the web
# pngquant will compress images
# -s 1 uses aggressive compression
# -f forces overwriting output files if they exist (for us its same as input)
echo -n "#2: Compressing PNG files ... "
for f in "${dir}"/*.png; do
    pngquant "$f" -s 1 -f -o "$f"
done
echo "DONE"

# # Step3: insert link to images in HTML template
# # this link is hardcoded for convenience
cp ./template.html "${dir}"/index.html
echo -n "#3: inserting links to PNG in reveal.js HTML ... "
mapfile -t slides < <(find "${dir}" -iname '*.png' | sort -r)
for f in "${slides[@]}"; do
    f=$(basename "$f")
    img="<section><img src='$f'></section>"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sed -i "16i $img" "${dir}"/index.html 
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        gsed -i "16i $img" "${dir}"/index.html 
    fi
done;
echo "DONE"
