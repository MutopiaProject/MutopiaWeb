# UsefulScripts

This is the traditional location of helper scripts, mostly used during
client-side publishing. Here is an outline of the most commonly used
scripts.

`mutopia-compile.sh` will build all publishing assets that can be
built with LilyPond. This includes PDF files in both A4 and LETTER, a
MIDI file, and preview images.

`mutopia-clean.sh` will remove all publishing assets in a folder.

`mutopia-combine.sh` finalizes the client-side publication by
combining multiple assets into zip files and creating the RDF file.
