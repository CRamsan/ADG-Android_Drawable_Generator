ADG-Android_Drawable_Generator
==============================

This is a tool that allows for the automatic creation of drawables resources for the different screen densities in an Android  projects.  

Dependencies:
* Perl
* ImageMagick

I would also recommend to place this script in a directory included in your $PATH to make it much easier to call.

Usage
=====
adg [file] [reference size] [--outname] [--outwidth] [--outheight] [--outdir] [--genoutdir] [--aspectratio] [--scaleoutside] [--ldpi] [--mdpi] [--hdpi] [--xhdpi] [--help]

How scaling works
=================

A image will be scaled based on the size provided. The size provided will be used for the mdpi image, all the other images will have relative sizes as specified on http://developer.android.com/guide/practices/screens_support.html#DesigningResources. The scaling will happen by generating a square using the dimensions provided and then fitting the image inside of it. By default the image will not be stretched and it will be scaled to fit inside the square. Some options can be used, such as --noaspectratio, to strech the image into the shape. Another important option is --scaleoutside, this option will scale the image to fill the square.

Negatable flags
===============

The options marked as [negatable] can accept a 'no' in front of it to negate it's value. For example --nogenoutdir can be used to negate the effect of --genoutdir. Please check which options are negatable and what is their default value.

Target selection
================

By default, all the modified images will be created(ldpi, mdpi, hdpi, xhdpi), but you can also specify which image to create. By using --ldpi, --mdpi, --hdpi, --xhdpi you can specify which images to generate. If you specify any image size, then all the not specified will not be created.

 * file: The file path to an image. Supported formats are the ones supported by ImageMagick(jpg, png, bmp and others)

 * reference size: The image will be scaled by comparing a square of dimensions sizeXsize. The image can be scaled by using either the longest or the shortest side. If this value is provided, then do not use --outwidth or --outheight. Reference --scaleoutside

 * --outname: The name of the output file. If --genoutdir is not set, then a modifier(ldpi, mdpi, hdpi or xhdpi) will be included between the file name and the extension.

 * --outwidth: The specific width for the shape used to set the scale. 

 * --outheight: The specific height for the shape used to set the scale

 * --outdir: The folder where the output images will be placed

 * --genoutdir[negatable]: If folders with the modifiers(ldpi-drawable, mdpi-...) will be created. This is set to true by default.

 * --aspectratio[negatable]: If aspect ration will be kept when scaling. This is set to true by default. If this flag is set, then --scaleoutside can not be set. 

 * --scaleoutside[negatable]: If the shortest side is going to be used for reference when scaling. This is set to false by default. If this flag is set, then --aspectration can not be negated. 

 * --ldpi: Generate the ldpi version of the image

 * --mdpi: Generate the mdpi version of the image

 * --hdpi: Generate the hdpi version of the image

 * --xhdpi: Generate the xhdpi version of the image

 * --help: Display this message

Examples
=========

 * adg image.png 30; Scale image.png to fit a square 30x30
 * adg image.png 30; Scale image.png to fit a square 30x30
