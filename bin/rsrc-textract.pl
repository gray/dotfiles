#!/usr/bin/env perl
use 5.010;
use warnings;

use IPC::System::Simple qw(capture);

my $file = shift // die 'missing filename';
exit unless -s "$file/..namedfork/rsrc";

my $text = join '', map { (pack "H*", $_) =~ tr/\r/\n/r } map { split ' ' }
    capture(DeRez => qw(-only TEXT), $file) =~ m[^\t\$"([^"]+)"]gm;
say $text;
