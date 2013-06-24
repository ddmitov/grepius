#!/usr/bin/perl
######################################################
# GREPIUS v.1.0 - Perl script for Linux
# GNU GREP Search Results Formatter
# PUBLIC DOMAIN!
# Free for any legal purpose!
# NO WARRANTIES OR SUPPORT OF ANY KIND!
# USE AT YOUR OWN RISK!
# You can modify it and redistibute it by any means!
# Author: Dimitar D. Mitov ddmitov@yahoo.com
# This script is in Unicode (UTF-8) encoding!
######################################################
# HTML interface language:
$lang = $ARGV[4];
######################################################
# Labels - English:
if($lang =~ 'en'){
$label_title_caps = 'GNU GREP SEARCH RESULTS';
$label_query = 'QUERY:';
$label_dir = 'ROOT FOLDER:';
$label_files = 'ALL FILES:';
$label_filter = 'FILE FILTER:';
$label_results = 'FILES WITH HITS:';
$label_maxnum = 'FILES WITH HITS TO BE DISPLAYED:';
$label_nr = 'Nr.';
$label_hit = 'hit';
$label_hits = 'hits';
$label_end = 'END OF GNU GREP SEARCH RESULTS';
$label_end_restrict= 'END OF DISPLAYED GNU GREP SEARCH RESULTS';
}
####################################################
# Надписи - български:
if($lang =~ 'bg'){
$label_title_caps = 'РЕЗУЛТАТИ ОТ ТЪРСЕНЕТО С GNU GREP';
$label_query = 'ЗАЯВКА:';
$label_dir = 'ГЛАВНА ДИРЕКТОРИЯ:';
$label_files = 'ОБЩО ФАЙЛОВЕ:';
$label_filter = 'ФАЙЛОВ ФИЛТЪР:';
$label_results = 'ФАЙЛОВЕ С ПОПАДЕНИЯ:';
$label_maxnum = 'ПОКАЗАНИ ФАЙЛОВЕ С ПОПАДЕНИЯ:';
$label_nr = 'Номер';
$label_hit = 'попадение';
$label_hits = 'попадения';
$label_end = 'КРАЙ НА РЕЗУЛТАТИТЕ ОТ ТЪРСЕНЕТО С GNU GREP';
$label_end_restrict= 'КРАЙ НА ПОКАЗАНИТЕ РЕЗУЛТАТИ ОТ ТЪРСЕНЕТО С GNU GREP';
}
####################################################

# Search query:
$query = $ARGV[0];

# Search root folder:
$dir = $ARGV[1];

# Maximal number of files for the HTML results file:
$maxnum = $ARGV[2];

# Display .pdf.txt files:
$index = $ARGV[5];

# Text results file:
open (INFO, "results.txt");
@array=<INFO>;
close (INFO);

# Counting all files:
$files = @array;

# File filter:
$filter = $ARGV[3];
$filter =~ tr/A-Z/a-z/;
$filter =~ s/html/htm/;

# Splitting filenames and hits, filtering filenames:
if($filter ne 'no'){
foreach $line (@array){
($file,$hits)=split(/:/,$line);
$file =~ tr/A-Z/a-z/;
if($hits > 0){
if($file =~ $filter){
push(@results, $line);
}}}}

# Splitting filenames and hits, no filename filtering:
if($filter eq 'no'){
foreach $line (@array){
($file,$hits)=split(/:/,$line);
if($hits > 0){
push(@results, $line);
}}}

# No file filter Bulgarian label:
if($filter eq 'no' && $lang eq 'bg'){
$label_filter_2 = 'няма';
}else{
$label_filter_2 = $filter
}

# Counting files with hits:
$results = @results;

# Sorting filenames by hits - Schwartzian transform:
@sorted_results = map{$_->[0]}
sort multisort map {[$_, split /:/]} @results;

# HTML results file:
open (RESULTS, ">results.htm");

# Results header:
print RESULTS "<html><head><title>SearchResults</title>\n";
print RESULTS "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head>\n";
print RESULTS "<style type=text/css>a:hover {color: #ff3830}</style>\n";;
print RESULTS "<body bgcolor='#ffffff' text='#000000' link='#000000' vlink='#000000' alink='#ff3830'>\n";

print RESULTS "<font size='4' face='Helvetica'><b>$label_title_caps</b></font><br><br>\n";
print RESULTS "<font size='3' face='Helvetica'><b>$label_query</b> &nbsp $query<br>\n";
print RESULTS "<b>$label_dir</b> &nbsp $dir<br>\n";
print RESULTS "<b>$label_files</b> &nbsp $files<br>\n";
if($filter ne ''){
print RESULTS "<b>$label_filter</b> &nbsp $label_filter_2<br>\n";
}
print RESULTS "<b>$label_results</b> &nbsp $results<br>\n";
if($results > $maxnum){
print RESULTS "<b>$label_maxnum</b> &nbsp $maxnum<br>\n";
}
print RESULTS "<br>\n";

# Results body - text files.
# Index files will be displayed:
if($index =~ 'yes'){
foreach $line (@sorted_results){
($sorted_file,$sorted_hits)=split(/:/,$line);
$number++;
if($number <= $maxnum){
if($sorted_hits == 1){
print RESULTS "<b>$label_nr $number - $sorted_hits $label_hit</b><br>\n";
print RESULTS "<a href='$sorted_file'> $sorted_file </a><br><br>\n";
}else{
print RESULTS "<b>$label_nr $number - $sorted_hits $label_hits</b><br>\n";

# Results body - PDF files converted to text files:
if($sorted_file =~ '.pdf.txt' || $sorted_file =~ '.PDF.txt'){
($name,$extension_one,$extension_two)=split(/\./,$sorted_file);
print RESULTS "<a href='$name.$extension_one'> $name.$extension_one </a><br>\n";
}

print RESULTS "<a href='$sorted_file'> $sorted_file </a><br>\n";
print RESULTS "<br>\n";
}}}}

# Results body - text files.
# Index files will not be displayed:
if($index =~ 'no'){
foreach $line (@sorted_results){
($sorted_file,$sorted_hits)=split(/:/,$line);
$number++;
if($number <= $maxnum){

if($sorted_hits == 1){
print RESULTS "<b>$label_nr $number - $sorted_hits $label_hit</b><br>\n";
}else{
print RESULTS "<b>$label_nr $number - $sorted_hits $label_hits</b><br>\n";
}

# Results body - PDF files converted to text files:
if($sorted_file =~ '.pdf.txt' || $sorted_file =~ '.PDF.txt'){
($name,$extension_one,$extension_two)=split(/\./,$sorted_file);
print RESULTS "<a href='$name.$extension_one'> $name.$extension_one </a><br>\n";
}else{
print RESULTS "<a href='$sorted_file'> $sorted_file </a><br>\n";
}

print RESULTS "<br>\n";
}}}

# Results footer:
if($results > $maxnum){
print RESULTS "</font>\n";
print RESULTS "<font size='3' face='Helvetica'><b>$label_end_restrict</b></font><br>\n";
}else{
print RESULTS "</font>\n";
print RESULTS "<font size='3' face='Helvetica'><b>$label_end</b></font><br>\n";
}
print RESULTS "</font></body></html>\n";

close (RESULTS);

# Multisort subroutine - Schwartzian transform:
sub multisort {
lc($b->[2]) <=> ($a->[2]) ||
lc($a->[1]) cmp lc($b->[1]) }
