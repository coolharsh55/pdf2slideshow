# pdf2slideshow
Creates a Reveal.js HTML slideshow from a PDF document

## requirements

- `pdftoppm` - extracts PDF pages as images ; usually packed as part of poppler or poppler-utils on your distro
- `pngquant` - compresses PNG ; available in package managers

## How it works

1. `script.sh` does all of the work
2. To edit the final reveal.js template, customise `template.html`
3. You might need to configure locatino of `reveal.js` in the template, the default is set to work for example in this repo
4. You use it as `script.sh PDF_Path Output_path`
5. It will exact PNG in output folder, copy template as `index.html`, and insert links to each image in the HTML
6. See demo at [https://harshp.com/pdf2slideshow/example](https://harshp.com/pdf2slideshow/example)

## License

MIT, see License file for full text
