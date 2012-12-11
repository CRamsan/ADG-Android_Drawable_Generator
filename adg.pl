#!/usr/bin/perl

use strict;
use warnings;

use Image::Magick;
use File::Path qw(make_path remove_tree);
use Getopt::Long;
use Cwd;

sub resizeImage{
  my $width = 0;
  my $height = 0;
  my $filename = $_[0];
  my $subDir = $_[1];
  my $newName = $_[4];
  my $outputDirectory = $_[5];
  if($subDir eq 'drawable'){
    print "Default size is "; $width = $_[2]; $height = $_[3]; }
  elsif($subDir eq 'drawable-ldpi')
    { print "LDPI size is "; $width = $_[2] * 0.75; $height = $_[3] * 0.75;}
  elsif($subDir eq 'drawable-mdpi')
    { print "MDPI size is "; $width = $_[2]; $height = $_[3];} 
  elsif($subDir eq 'drawable-hdpi')
    { print "HDPI size is "; $width = $_[2] * 1.5; $height = $_[3] * 1.5;} 
  elsif($subDir eq 'drawable-xhdpi')
    { print "XHDPI size is "; $width = $_[2] * 2; $height = $_[3]  * 2;}
  else
    { print "No correct argument"; return;}

  print "$width"."x"."$height\n";


  my $image = Image::Magick->new;

  print "Opening image $filename\n";
  $image->read($filename);   
  if($newName ne ''){
    $filename = $newName;
  }  
  $image->Set( Gravity => 'Center' );
  $image->Set(alpha=>'On');
  $image->Resize( geometry => "$width"."x"."$height" );
  #$image->Extent( geometry => "$width"."x"."$height" );
  print "Saving file to $outputDirectory/$subDir/$filename\n";
  $image->Write( "$outputDirectory/$subDir/$filename" );
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
my $outputFileSize = '0';
my $outputDirectoryName = '';

my $generateOutputDirectory = '1';
my $createLDPI = '0';
my $createMDPI = '0';
my $createHDPI = '0';
my $createXHDPI = '0';

#Variable
my $inputFileName = '';

my $result = GetOptions ('outName:s'=> \$outputFileName,
						 "outWidth=i" => \$outputFileWidth,
						 "outHeight=i" => \$outputFileHeight,
						 "outSize=i" => \$outputFileSize,
						 'outDir:s' => \$outputDirectoryName,
						 'genOutDir!' 	=> \$generateOutputDirectory,
						 'ldpi'  	=> \$createLDPI,
						 'mdpi'  	=> \$createMDPI,
						 'hdpi' 	=> \$createHDPI,
						 'xhdpi'  	=> \$createXHDPI);

if ($result)
{
  print "Error while reading arguments\n";
  print "Use --help to check the valid syntax\n";
  exit;
}

$inputFileName = ARG[0]

#Main body
print "Starting script\n";

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

if($generateDirectory){
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

  print "Creating directories\n";

  if($createLDPI)
  {
    make_path("$outputDirectory/drawable-ldpi");
  }
  if($createMDPI)
  {
    make_path("$outputDirectory/drawable-mdpi");
  }
  if($createHDPI)
  {
    make_path("$outputDirectory/drawable-hdpi");
  }
  if($createXHDPI)
  {
    make_path("$outputDirectory/drawable-xhdpi");
  }
}
else
{
  print "Directories will not be created\n";
}

resizeImage($filePath, 'drawable-ldpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);
resizeImage($filePath, 'drawable-mdpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);
resizeImage($filePath, 'drawable-hdpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);
resizeImage($filePath, 'drawable-xhdpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);

