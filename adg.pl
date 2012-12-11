#!/usr/bin/perl

use strict;
use warnings;

use Image::Magick;
use File::Path qw(make_path remove_tree);
use Getopt::Long;
use Cwd;

#Global variables
my $MAX_IMAGE_DIMENSION = '4000';

#[0] Image
#[1] Width
#[2] Height
#[3] Alpha
#[4] Output Directory
#[5] Output Filename
sub resizeImage{
  my $imageObject = $_[0];
  my $imageWidth = $_[1];
  my $imageHeight = $_[2];
  my $imageAlpha = $_[3];  
  my $imageDirectory = $_[4];
  my $imageFilename = $_[5];

  #Set if using alpha
  if($imageAlpha)
  {
    $imageObject->Set(alpha=>'On');
  }
  else
  {
    $imageObject->Set(alpha=>'Off');
  }
  
  #Make the required changes
  $imageObject->Resize( geometry => "$imageWidth"."x"."$imageHeight" );
  print "Saving file to $imageDirectory/$imageFilename\n";
  #Save the image
  $imageObject->Write( "$imageDirectory/$imageFilename" );
}

#Check arguments validity
if (@ARGV == 0)
{
  print "No arguments passed\n";
  print "Use --help to see valid syntax and more options\n";
  exit;
}

#Arguments
my $outputFileName = '';
my $outputFileHeight = '0';
my $outputFileWidth = '0';
my $outputDirectoryName = '';

my $generateOutputDirectory = '1';
my $useAlpha = '1';
my $createLDPI = '0';
my $createMDPI = '0';
my $createHDPI = '0';
my $createXHDPI = '0';

my $help = '0';

my $modFolderL = '.';
my $modFolderM = '.';
my $modFolderH = '.';
my $modFolderXH = '.';

#Variable
my $inputFileName = '';
my $error = '';

$error = GetOptions (	'outName:s'	=> \$outputFileName,
			"outWidth=i" 	=> \$outputFileWidth,
			"outHeight=i" 	=> \$outputFileHeight,
			'outDir:s' 	=> \$outputDirectoryName,
			'genOutDir!' 	=> \$generateOutputDirectory,
			'alpha!' 	=> \$useAlpha,
			'ldpi'  	=> \$createLDPI,
			'mdpi'  	=> \$createMDPI,
			'hdpi' 		=> \$createHDPI,
			'xhdpi'  	=> \$createXHDPI,
			'help' 		=> \$help);

if ($error)
{
  print "Error while reading arguments\n";
  print "Use --help to check the valid syntax\n";
  exit;
}

if($help)
{
  print "";
}

#Check the validity of the provided dimensions
if($outputFileHeight == 0 && $outputFileWidth == 0)
{
  print "No dimensions provided\n";
  exit;
}
if($outputFileWidth < 0)
{
  print "Width provided is less than 0\n";
  print "Value: $outputFileWidth\n";
  $error = '1';
}
if($outputFileHeight < 0)
{
  print "Height provided is less than 0\n";
  print "Value: $outputFileHeight\n";
  $error = '1';
}
if($outputFileWidth > $MAX_IMAGE_DIMENSION)
{
  print "Width provided is bigger than MAX_IMAGE_DIMENSION\n";
  print "Value: $outputFileWidth\n";
  $error = '1';
}
if($outputFileHeight > $MAX_IMAGE_DIMENSION)
{
  print "Height provided is bigger than MAX_IMAGE_DIMENSION\n";
  print "Value: $outputFileHeight\n";
  $error = '1';
}
if($error)
{
  exit;
}

#Make sure the output folder is formatted correctly
if($outputDirectoryName =~ m/\/$/){
  chop($outputDirectoryName);
  if($outputDirectoryName =~ m/\/$/){
    print "Output directory is not well formatted\n";
    exit;
  }
}

#If the ourput folder is empty, use cwd
if($outputDirectoryName eq ''){
  $outputDirectoryName = cwd;
}

#Get the input file from the arguments
$inputFileName = $ARGV[0];

#Main body
print "Starting script\n";

if($generateOutputDirectory){
  #All flags are set to false by default, if the user activates at least 
  #one flag  this change will be kept. If all flags are still false(no 
  #flag set by the user), then set all of them to true.
  if(!($createLDPI || $createMDPI || $createHDPI || $createXHDPI))
  {
    $createLDPI = '1';
    $createMDPI = '1';
    $createHDPI = '1';
    $createXHDPI = '1';
  }
}
else
{
  print "Modular directories will not be created\n";
}

#Starting file processing
print "Opening image $inputFileName\n";
my $image = Image::Magick->new;
$image->read($inputFileName);   
#If the outputFileName is empty, use the current file name
if($outputFileName eq '')
{
  my($filename, $directories, $suffix) = fileparse($inputFileName);
  $outputFileName = $filename; 
}

#Set the gravity to Center
$image->Set( Gravity => 'Center' );

#We will check each size flag and the $generateDirectory flag
#and we will take action as required. If generateDirectory is
#not set then $modFolder will be equal to '.'. If it is set, 
#then $modFolder will be the respective folder with the modifier
#(ldpi, mdpi, hdpi, xhdpi).
my $outputFolder = '';
if($createXHDPI)
{
  if($generateOutputDirectory){
      $modFolderXH = 'drawable-xhdpi';
      make_path("$outputDirectoryName/$modFolderXH");
  }	
  $outputFolder = "$outputDirectoryName/$modFolderXH";
  resizeImage($image, $outputFileWidth * 2.0, $outputFileHeight * 2.0, $useAlpha, $outputFolder, $outputFileName);
}
if($createHDPI)
{
  if($generateOutputDirectory){
      $modFolderH = 'drawable-hdpi';
      make_path("$outputDirectoryName/$modFolderH");
  }
  $outputFolder = "$outputDirectoryName/$modFolderH";
  resizeImage($image, $outputFileWidth * 1.5, $outputFileHeight * 1.5, $useAlpha, $outputFolder, $outputFileName);
}
if($createMDPI)
{
  if($generateOutputDirectory){
      $modFolderM = 'drawable-mhdpi';
      make_path("$outputDirectoryName/$modFolderM");
  }	
  $outputFolder = "$outputDirectoryName/$modFolderM";
  resizeImage($image, $outputFileWidth, $outputFileHeight, $useAlpha, $outputFolder, $outputFileName);
}
if($createLDPI)
{
  if($generateOutputDirectory){
      $modFolderL = 'drawable-ldpi';
      make_path("$outputDirectoryName/$modFolderL");
  }	
  $outputFolder = "$outputDirectoryName/$modFolderL";
  resizeImage($image, $outputFileWidth * 1.5, $outputFileHeight * 1.5, $useAlpha, $outputFolder, $outputFileName);
}
