#!/usr/bin/env perl
use strict;
use warnings;
use CPAN::DistnameInfo;
use Cwd qw(realpath);
use DB_File;
use File::Spec::Functions qw(catfile catpath splitpath);
use WebService::Google::Reader;

use constant VERBOSE => not $ENV{CRON};

my $dir = catpath((splitpath(realpath __FILE__))[0, 1]);
my $file = catfile($dir, '.unwanted-modules.bdb');
my $db = tie my %db, DB_File => $file;

my $reader = WebService::Google::Reader->new(
    username => $ENV{GOOGLE_USERNAME},
    password => $ENV{GOOGLE_PASSWORD},
);

my %conf = (
    perl => {
        url  => 'http://search.cpan.org/uploads.rdf',
        name => sub {
            CPAN::DistnameInfo->new($_[0]->title . '.tgz')->dist
        },
        whitelist => [ qr/^(?:AnyEvent|Digest)\b/, ]
    },
    python => {
        url       => 'http://pypi.python.org/pypi?:action=rss',
        blacklist => [ qr/\bdjango\b/i ],
        name      => sub {
            my ($name) = $_[0]->link->href =~ m[
                ^http://pypi\.python\.org/pypi/([^/]+)
            ]x;
            return $name;
        },
    },
    ruby => {
        url       => 'http://feeds.feedburner.com/gemcutter-latest',
        blacklist => [ qr/\brails\b/i ],
        name      => sub {
            my ($name) = $_[0]->link->href =~ m[
                ^http://rubygems\.org/gems/([^?/]+)
            ]x;
            return $name;
        },
    },
    haskell => {
        url  => 'http://hackage.haskell.org/packages/archive/recent.rss',
        name => sub { ($_[0]->title =~ m[^\s*(\S+)])[0] },
    },
    vimscripts => {
        url => 'http://feed43.com/vim-scripts.xml',
        name => sub {
            my ($title, $name) = $_[0]->title =~ m[^\s*((.*?)\s+\S+) --];
            $_[0]->title($title);
            return $name;
        },
    }
);

# Get list of feed subscription times.
my %subs;
for my $sub ($reader->feeds) {
    (my $id = $sub->id) =~ s[^feed/][] or next;
    $subs{$id} = int $sub->firstitemmsec / 1000;
}

while (my ($lang, $conf) = each %conf) {
    my $feed = $reader->feed(
        $conf->{url},
        count      => 100,
        exclude    => { state => 'read' },
        start_time => $subs{$conf->{url}},
    );
    die $reader->error unless $feed;

    my @blacklist = @{ $conf->{blacklist} || [] };
    my @whitelist = @{ $conf->{whitelist} || [] };

    my @unwanted_entries;
    {
        for my $entry ($feed->entries) {
            my $name  = $conf->{name}($entry);
            my $title = $entry->title;
            # print "$lang | $name | $title\n" and next;
            unless ($name) {
                warn "Couldn't extract name from $title\n";
                next;
            }

            my $whitelisted;
            for my $w (@whitelist) {
                if ('Regexp' eq ref $w ? $name =~ $w : $name eq $w) {
                    $whitelisted = 1;
                    last;
                }
            }
            next if $whitelisted;

            my $blacklisted;
            for my $b (@blacklist) {
                if ('Regexp' eq ref $b ? $name =~ $b : $name eq $b) {
                    $blacklisted = 1;
                    last;
                }
            }

            if ($blacklisted or exists $db{"$lang|$name"}
                and $title ne $db{"$lang|$name"}
            ) {
                push @unwanted_entries, $entry;
            }
            else {
                $db{"$lang|$name"} = $title;
            }
        }

        sleep 0.25;
        redo if $reader->more($feed);
    }

    $reader->mark_read_entry(\@unwanted_entries);
    VERBOSE && print $_->title, "\n" for @unwanted_entries;
}
