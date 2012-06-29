ADG-Android_Drawable_Generator
==============================

This is a tool that allows for the automatic creation of drawables resources for the different screen densities in an Android  projects.  

Dependencies:
* Perl
* ImageMagick

The usage is fairly simple, you call the script and pass as the parameters the image and the attributes for width and heigh of the resulting image for the default size. This image will be a baseline for creating the different sizes, more details can be found here: 
http://developer.android.com/guide/practices/screens_support.html#DesigningResources.

The image, width and height are mandatory but you can also specify an output directory and a name for the resulting image. By the default the script will place the output in thr current directory and the name will be tha same as the input image. 

For making your life easier, the images are placed in their respective folder(ldi, mdpi, hdpi, xldpi...). I will add more attributes and more options in the future, but for now the most important function is completed.

Example:

This command will generate the four screen densities for icon.png with 24x24 as base size(mdpi). The output will be placed in the current directory, each file in a separate folder.
* ./adg.pl icon.png 24 24

This command will generate the images but the output will be placed in the res/ folder of the android project. This way you dont have to copy-paste anything.
* ./adg.pl icon.png 24 24 --output ~/path/to/project/res

With the file option you can specify the name of the output image. 
* ./adg.pl icon.png 24 24 --file click.png

Remember you can combine both options.
