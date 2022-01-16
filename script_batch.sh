#!/usr/bin/env bash
#author: Harshvardhan J. Pandit
#github: coolharsh55

#script: Takes a folder structure and creates HTML slideshows for each PDF

#requirements: 
#   - pdftoppm: export PDF pages as png images
#   - pngquant: compress pngs
#   - sed: insert link to images in HTML template for slideshow

#inputs:
#   1: path to parent folder
# TODO rest of inputs using a better parameter management method
#   2: path to output folder
#   3: path to reveal js (could be on web)
#   4: path to HTML template (needs to be on disk)

# Handling arguments / flags
while getopts ":p:fi" opt; do
    case "${opt}" in
        p)
            ROOT=${OPTARG}
            ;;
        f)
            FORCE_PROCESSING=1
            ;;
        i)
            INDEX=1
            ;;
        *)
            ;;
    esac
done

echo "ROOT: $ROOT"

mapfile -t PDFs < <(find "$ROOT" -iname '*.pdf' -type f -not -path '*/\.*')
for file in "${PDFs[@]}"; do
    printf '%s\n' --------------------
    dir=$(dirname "$file")
    echo "FOLDER: $dir"
    echo "PDF: $file"

    # The actual processing is done by script.sh
    if [[ -z "${FORCE_PROCESSING+x}" ]]; then
        ./script.sh -p "$file"
    else
        ./script.sh -p "$file" -f
    fi

# loop for nested folder iteration
done

printf '%s\n' --------------------
if [[ -n $INDEX ]]; then
    cd "$ROOT" || exit
    tree -r -I '*.png' -H './' > "$ROOT/index.html"
    echo "Generated index.html for $ROOT"
    cd - || exit
fi

echo "PROGRAM END"
printf '%s\n' --------------------

# TODOs

# TODO: Create a separate script to handle folder of PDFs (no nesting)
# The script will take a folder that contains PDFs 
# and creates subfolders, moves the PDF in that subfolder,
# and generates HTML for each PDF
