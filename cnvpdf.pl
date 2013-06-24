#!/usr/bin/perl
######################################################
# PDF Conveyr v.1.0
# PDF to TXT batch conversion script
# PUBLIC DOMAIN!
# Free for any legal purpose!
# NO WARRANTIES OR SUPPORT OF ANY KIND!
# USE AT YOUR OWN RISK!
# You can modify it and redistibute it by any means!
# Author: Dimitar D. Mitov ddmitov@yahoo.com
######################################################

use Shell;

# PDF listing file:
open (INFO, "$ARGV[0]");
@array=<INFO>;
close (INFO);

# PDF conversion:
foreach $line (@array){
chomp $line;
# Do not use '-' in a program filename!
# Rename file if necessary!
pdftotext ("$line", "$line.txt");
}
