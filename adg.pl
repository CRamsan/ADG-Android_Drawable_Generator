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

##MAIN

if ( @ARGV == 0 )
{
  print "No arguments passed\n";
  print "Parameters required: [image] [default width] [default height]\n";
  exit;
}

print "Starting script\n";
my $filePath = $ARGV[0];
my $defaultWidth = $ARGV[1];
my $defaultHeight = $ARGV[2];

my $outputFileName = '';
my $outputDirectory = '';

my $result = GetOptions ("file:s" => \$outputFileName, # numeric
			 "output:s"   => \$outputDirectory);# string

if($outputDirectory =~ m/\/$/){
  chop($outputDirectory);
  if($outputDirectory =~ m/\/$/){
    print "Output directory is not well formatted\n";
    exit;
  }
}

if($outputDirectory eq ''){
  $outputDirectory = cwd;
}

print "Creating directories\n";
make_path("$outputDirectory/drawable-ldpi", "$outputDirectory/drawable-mdpi", "$outputDirectory/drawable-hdpi", "$outputDirectory/drawable-xhdpi");

resizeImage($filePath, 'drawable-ldpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);
resizeImage($filePath, 'drawable-mdpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);
resizeImage($filePath, 'drawable-hdpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);
resizeImage($filePath, 'drawable-xhdpi', $defaultWidth, $defaultHeight, $outputFileName, $outputDirectory);

