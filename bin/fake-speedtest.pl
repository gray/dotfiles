#!/usr/bin/env perl
use strict;
use warnings;

use Carp qw(croak);
use Digest::MD5 qw(md5_hex);
use Geo::Distance;
use Getopt::Long qw(:config auto_help);
use LWP::UserAgent;
use Pod::Usage;
use XML::LibXML;

GetOptions(
    'download|d=f' => \my $down,
    'upload|u=f'   => \my $up,
    'ping|p=i'     => \my $ping,
) or pod2usage(2);
pod2usage(2) unless 3 == grep defined, $down, $up, $ping;
for ($down, $up) {
    pod2usage(2) unless 0 < $_ and 1_000 > $_;
}

my $ua = LWP::UserAgent->new(
    agent => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0) '
           . 'Gecko/20100101 Firefox/4.0',
);

my $time = time . sprintf "%03d", int rand(999);

my $dom = parse_config("http://speedtest.net/speedtest-config.php?x=$time");
my ($node) = $dom->findnodes('/settings/client');
my ($clat, $clon) = map { $node->findvalue("\@$_") } qw(lat lon);

# Choose the closest server.
# TODO: use AnyEvent::FastPing since flash client now chooses server by
#   best ping time.
$dom = parse_config("http://speedtest.net/speedtest-servers.php?x=$time");
my $geo = Geo::Distance->new;
my ($server, $distance);
for my $node ($dom->findnodes('/settings/servers/server')) {
    my ($id, $slat, $slon) = map { $node->findvalue("\@$_") } qw(id lat lon);
    my $d = $geo->distance(mile => $clon, $clat, $slon, $slat);
    if (not defined $distance or $d < $distance) {
        $server   = $id;
        $distance = $d;
    }
}
die 'No server' unless $server;

$_ *= 1_000 for ($up, $down);

my $salt = substr md5_hex('or4ng$'), 0, 8;
my $res = $ua->post(
    'http://www.speedtest.net/api/api.php',
    referer => 'http://c.speedtest.net/flash/speedtest.swf',
    Content => [
        hash      => md5_hex(sprintf '%s-%s-%s-%s', $ping, $up, $down, $salt),
        ping      => $ping,
        startmode => 'pingselect',
        upload    => $up,
        accuracy  => 9,  # ?
        download  => $down,
        recommendedserverid => $server,
        serverid  => $server,
    ]
);
die $res->dump if $res->is_error;

my %data = map { split '=' } split '&', $res->decoded_content;
die "Bad values rejected by SpeedTest.Net" unless $data{resultid};

printf "http://speedtest.net/result/%s.png\n", $data{resultid};

exit;


sub parse_config {
    my ($url) = @_;
    my $res = $ua->get($url);
    croak $res->status_line if $res->is_error;

    my $xml = $res->decoded_content;
    return eval { XML::LibXML->new->parse_string($xml) };
}

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
