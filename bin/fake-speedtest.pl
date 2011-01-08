#!/usr/bin/env perl
use strict;
use warnings;

use Digest::MD5 qw(md5_hex);
use Geo::Distance;
use Getopt::Long qw(:config auto_help);
use LWP::UserAgent;
use Pod::Usage;
use XML::LibXML;

GetOptions(
    'help|h'       => \my $help,
    'download|d=f' => \my $down,
    'upload|u=f'   => \my $up,
    'ping|p=i'     => \my $ping,
) or pod2usage(2);
pod2usage(2) unless 3 == grep defined, $down, $up, $ping;
for ($down, $up) {
    pod2usage(2) unless 0 < $_ and 1_000 > $_;
}

my $ua = LWP::UserAgent->new(
    agent => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0b8) ' .
             'Gecko/20100101 Firefox/4.0b8',
);

my $time = time . sprintf "%03d", int rand(999);
my $conf = "http://speedtest.net/speedtest-config.php?x=$time";

my $res = $ua->get($conf);
die $res->status_line if $res->is_error;

my $xml = $res->decoded_content;
my $dom = eval { XML::LibXML->new->parse_string($xml) };
my ($node) = $dom->findnodes('/settings/client');
my ($clat, $clon) = map { $node->findvalue("\@$_") } qw(lat lon);

# Choose the closest server.
my $geo = Geo::Distance->new;
my ($server, $distance);
for my $node ($dom->findnodes('/settings/servers/server')) {
    my ($id, $slat, $slon) = map { $node->findvalue("\@$_") } qw(id lat lon);
    my $d = $geo->distance(mile => $clon, $clat, $slon, $slat);
    if (not $distance or $d < $distance) {
        $server   = $id;
        $distance = $d;
    }
}

$_ *= 1_000 for ($up, $down);

$res = $ua->post(
    'http://www.speedtest.net/api/api.php',
    {
        hash     => md5_hex(sprintf '%s-%s-%s-lol', $ping, $up, $down),
        serverid => $server,
        download => $down,
        upload   => $up,
        ping     => $ping,
        submit   => 'Generate',
    }
);
die $res->dump if $res->is_error;

my %data = map { split '=' } split '&', $res->decoded_content;
die "Bad values rejected by SpeedTest.Net" unless $data{resultid};

printf "http://speedtest.net/result/%s.png\n", $data{resultid};

__END__

=head1 NAME

fake-speedtest.pl

=head1 SYNOPSIS

  fake-speedtest.pl --down download --up upload --ping ping

  Options:

    -d --down  Download speed in Mb/s (0 < x < 1,000)
    -u --up    Upload speed in Mb/s   (0 < x < 1,000)
    -p --ping  Ping latency in ms

=cut
