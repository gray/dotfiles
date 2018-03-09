#!/usr/bin/env perl
use strict;
use warnings;

use open qw(:std :utf8);

# Export playlists from iTunes:
#   File > Library > Export Playlist
# Force iTunes to update ID3 tags within files:
#   File > Convert > Convert ID3 Tags > ID3 tag version: v2.3
# m3u-itunes2sandisk.pl *.m3u{,8}
# rsync -amrtuv --modify-window=2 --del --include='*.mp3' --include='*/' --exclude='*' ~/Music/iTunes/'iTunes Music'/ /Volumes/'SPORT PLUS/MUSIC/'
# rsync -av *.m3u{,8} /Volumes/'SPORT PLUS/Playlists/'

local @ARGV = grep /\.m3u8?$/i, @ARGV
    or exit;

# Convert line endings from mac to dos, edit files in place.
local ($/, $\, $^I) = ("\r", "\n", '');

while (<ARGV>) {
    s/^\n+//;
    tr'/'\\' if s'^/Users/[^/]+/Music/iTunes/iTunes (?=Music/)'/';
    print if length;
}
