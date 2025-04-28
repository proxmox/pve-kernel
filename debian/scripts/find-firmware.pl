#!/usr/bin/perl

use strict;
use warnings;

my $dir = shift;

die "no directory to scan" if !$dir;

die "no such directory" if ! -d $dir;

warn "\n\nNOTE: strange directory name: $dir\n\n" if $dir !~ m|^(.*/)?(\d+.\d+.\d+\-\d+\-pve)(/+)?$|;

my $apiver = $2;

open(my $FIND_KO_FH, "find '$dir' -name '*.ko'|");
while (defined(my $fn = <$FIND_KO_FH>)) {
    chomp $fn;
    my $relfn = $fn;
    $relfn =~ s|^\Q$dir\E/*||;

    my $cmd = "/sbin/modinfo -F firmware '$fn'";
    open(my $MOD_FH, "$cmd|");
    while (defined(my $fw = <$MOD_FH>)) {
	chomp $fw;
	print "$fw $relfn\n";
    }
    close($MOD_FH);

}
close($FIND_KO_FH);

exit 0;
