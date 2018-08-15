#!/usr/bin/perl
#Original Post: https://ubuntuforums.org/showthread.php?t=1110498
use File::Path;

my $ofh = select STDOUT; #Make stdout hot
$| = 1;
select STDOUT;

$getimages = 1000; #render out 1000 images
$deletefirst = 300; #delete the first 300
$totalimages = $getimages - $deletefirst; 
$minmatch = 2; #might use this later (not used now)

$searchdir = "/home/angus/tmp/"; #directory to scan
$basedir = "/tmp/hashchecker"; #working directory, this directory will get clobbered, make it something uniq in /tmp/

print "Cleaning up directories...\n";
rmtree($basedir); #see, I told you.

print "Rendering $getimages frame(s), skipping the first $deletefirst. ($totalimages end result)\n";

@videofiles=`find "$searchdir" -type f -printf "%p\n" | grep -Ei "\.(mp4|flv|wmv|mov|avi|mpeg|mpg|m4v|mkv|divx|asf)"`;
foreach $i (@videofiles)
{
 chomp $i;
 print "$i";
 @filename = split(/\//,$i);
 $imgdir = $basedir . "/$filename[-1]";
 mkpath($imgdir);
 $data=`cd "$imgdir"; mplayer -really-quiet -vo png -frames $getimages -ao null "$i" 2>&1`;
 @data=`find "$imgdir" -type f -name "*.png" | sort`;
 for ($deletecount=0; $deletecount < $deletefirst; $deletecount++)
 {
   chomp $data[$deletecount];
   unlink $data[$deletecount];
 }
 $data=`mogrify -resize 10x10! -threshold 50% -format bmp "$imgdir/*"`;
 $data=`find "$imgdir" -type f -name "*.png" -delete`;
 print "\n";
}
print "Calculating hash table...\n";
@md5table=`find "$basedir" -type f -name "*.bmp" -exec md5sum "{}" \\; | sort | uniq -D -w32`;
foreach $x (@md5table)
{
 chomp $x;
 $x =~ m/^([0-9a-f]{32})/i;
 $md5=$1;
 $x =~ m/^[0-9a-f]{32}[ \t]*(.*)/i;
 $fullpath=$1;
 @filename = split(/\//,$x);
 open (MYFILE, ">>$basedir/$md5.md5") or die "couldnt open file\n";
 print MYFILE "$fullpath\n";
 close (MYFILE);
}

@hashfiles=`find "$basedir" -type f -name "*.md5"`;
foreach $i (@hashfiles)
{
 chomp $i;
 @uniqfiles=`sort "$i" | uniq`;
 $uniqsize=@uniqfiles;
 if ($uniqsize > 1)
 {
   $firstpass = 1;
   foreach $x (@uniqfiles)
   {
     chomp $x;
     @filename=split(/\//,$x);
     if ($firstpass == 1)
     {
       $outfile=$filename[-2];
       $firstpass=0;
     }
     else
     {
       if ($outfile ne $filename[-2])
       {
         open (COUNTFILE, ">>$basedir/$outfile.count") or die "$outfile -> couldnt open file\n";
         print COUNTFILE "$filename[-2]\n";
         close (COUNTFILE);
       }
     }
   }

 }
}
print "Here come the delicious dupes:\n";
@hashfiles=`find "$basedir" -type f -name "*.count"`;
foreach $i (@hashfiles)
{
 chomp $i;
 print "$i\n";
 @uniqfiles=`sort "$i" | uniq -c`;
 foreach $x (@uniqfiles)
 {
    chomp $x;
    $x =~ m/^[ \t]*([0-9]{1,50})/i;
    $percent = $1/$totalimages*100;
    $x =~ m/^[ \t]*[0-9]{1,50}(.*)/i;
    $filename=$1;
    printf "\t%.2f% match with %s\n",$percent,$filename;
 }
 print "\n";

}
exit;
