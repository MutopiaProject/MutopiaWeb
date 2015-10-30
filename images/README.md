# Image sources

This folder holds images for the use of the MutopiaProject web site.
Binary images should be un-encumbered by any copyright. This area can
also hold original artwork sources (Inkscape SVG files, GIMP XCF's,
etc.)

## Tools

   * For vector graphics, [inkscape](inkscape.org) is preferred.

   * If you use the [GIMP](gimp.org) for pixel editing, please leave
     the XCF file for possible future editing.

   * If you use [ImageMagick](imagemagick.org), please leave a note
     here on the commands you used to manipulate the image.

   * For the favicon I use [favicomatic](favicomatic.com), but it is
     trivial to do this with `imagemagick`.

## Creating the favicon.ico file

The original artwork is in the inkscape file, `mutopia-ico.svg`. This
is a vector image created at 64X64.

   * Check the borders to make sure the image is within the page
     borders.

   * Export the image to a PNG file.

   * *optional:* Optimize the image with `optipng` or something
      similar.

   * Upload to [favicomatic](favicomatic.com) and specify 16x16,
     24x24, and 32x32 image sizes. The site will download
     a zip file containing more than everything you need.

   * Move the favicon.ico file to the top of the project tree and
     commit.

   * Commit the generated files (mutopia-ico-NNxNN.png) for later use
     on the site.
