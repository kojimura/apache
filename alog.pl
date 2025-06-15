#!/usr/bin/perl
# Format apache log by tab delimiter
#
# Output: IP timestamp request status byte time referer
#
# Usage:
# alog.pl logfile i.e. alog.pl access.log
# alog.pl < logfile > fmt.txt
# zcat logfile.gz | alog.pl
#
# LogFormat:
# pattern1:combined
# "%a %D %u %t \"%r\" %>s %b \"{Referer}i\" \"%{User-Agent}i\" \"-\J"" combined
#127.0.0.1 - - [12/Nov/2021:14:04:13 +0900] "GET /wp-content HTTP/1.0" 200 5021 "http://foo.com/home.htm" "Mozilla/5.0 (Windows NT 5.01; as-IN; rv:1.9.0.20) Gecko/2021-01-10 16:56:07 Firefox/14.0"
#
# pattern1:common
# "%h %l %u %t \"%r\" %>s %b" common
# 127.0.0.1 - - [10/Apr/2021:17:12:42 +0900] "GET /favicon.ico HTTP/1.1" 200 1150
#
use strict;
use warnings;
use Getopt::Long;

my $opt_fmt = "combined";
my $opt_help = 0;

GetOptions(
    "format=s" => \$opt_fmt,
    "help" => \$opt_help,
) or disp_usage();
disp_usage() if $opt_help;

sub disp_usage {
    print "format apacke log by tab delimiter\n";
    print "Usage: $0 [--format=common][--help] <filename> i.e. $0 --format=common access.log\n";
    exit;
}

#print "$opt_fmt\n";

my $fmt = qr/^(\S+) (\S+) (\S+) \[(.*?)\] "(\S+)?(\s\S+)?(\s\S+)?" (\d+) (\d+|-)$/;
if ($opt_fmt eq "combined" ) {
    $fmt = qr/^(\S+) (\S+) (\S+) \[(.*?)\] "(\S+)?(\s\S+)?(\s\S+)?" (\d+) (\d+|-) "([^"]*)" (.*)$/;
}

my ($ip,$ptime,$usr,$ts,$req,$url,$prt,$sts,$sz,$ref,$oth,$rlog);
my $tabstr;
while (<>) {
    if ($_ =~ /$fmt/) {
        if ($opt_fmt eq "combined" ) {
            ($ip,$ptime,$usr,$ts,$req,$url,$prt,$sts,$sz,$ref,$oth) = ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11);
            if (defined $req){
                $tabstr = join("\t",$ip,$ts,$req,$sts,$sz,$ptime,$ref);
            } else {
                $tabstr = join("\t",$ip,$ts,"",$sts,$sz,$ptime,$ref);
            }
        } else {
            ($ip,$rlog,$usr,$ts,$req,$url,$prt,$sts,$sz) = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
            $tabstr = join("\t",$ip,$ts,$req,$sts,$sz);
        }
        print "$tabstr\n";
    } else {
        print "Unmatch* $_";
    }
}
