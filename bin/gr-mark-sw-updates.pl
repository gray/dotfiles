#!/usr/bin/env perl
use 5.012;
use warnings;

use Acme::CPANAuthors::Utils qw(cpan_packages);
use CPAN::DistnameInfo;
use Cwd qw(realpath);
use DB_File;
use File::Find;
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

# Return a sub that checks if the given Perl dist is installed.
my $is_perl_dist_installed = do {
    # Find the list of installed modules.
    my (%modules, %prune);
    for my $top (reverse sort @INC) {
        next if '.' eq $top;
        my $len = length $top;
        find {
            wanted => sub {
                if ($File::Find::dir ~~ %prune) {
                    $File::Find::prune = 1;
                    return;
                }
                return unless '.pm' eq substr $_, -3, 3, '';
                return unless -f _;
                substr $_, 0, 1 + $len, '';
                s{[\\/]}{::}g;
                $modules{$_} = undef;
            },
            no_chdir => 1
        }, $top;
        $prune{$top} = undef;
    }

    # Determine the installed distributions, given the installed modules.
    my %dists;
    for my $dist (cpan_packages->latest_distributions) {
        for my $package (@{$dist->packages}) {
            $dists{$dist->dist} = undef if $package->package ~~ %modules;
        }
    }

    sub { $_[0] ~~ %dists; }
};

my %conf = (
    perl => {
        url  => 'http://feeds.feedburner.com/YetAnotherCpanRecentChanges',
        name => sub {
            CPAN::DistnameInfo->new($_[0]->title . '.tgz')->dist
        },
        whitelist => [ $is_perl_dist_installed ],
    },
    python => {
        url  => 'http://pypi.python.org/pypi?:action=rss',
        name => sub {
            my ($name) = $_[0]->link->href =~ m[
                ^http://pypi\.python\.org/pypi/([^/]+)
            ]x;
            return $name;
        },
        blacklist => [ qr/ (?:\b|_) (?:django | plone) (?:\b|_) /ix ],
    },
    ruby => {
        url  => 'http://feeds.feedburner.com/gemcutter-latest',
        name => sub {
            my ($name) = $_[0]->link->href =~ m[
                ^http://rubygems\.org/gems/([^?/]+)
            ]x;
            return $name;
        },
        blacklist => [ qr/ (?:\b|_) rails (?:\b|_) /ix ],
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
    },
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
            my $name    = $conf->{name}->($entry);
            my $title   = $entry->title;
            my $summary = $entry->summary || '';
            my $desc    = $entry->content || '';
            $desc &&= $desc->body;
            # say "$lang | $name | $title | $summary | $desc\n" and next;

            unless ($name) {
                warn "Couldn't extract name from $title\n";
                next;
            }

            my $listed;
            for my $w (@whitelist) {
                next if not $name ~~ $w;
                $listed = 1;
                VERBOSE && say "$lang - $name - whitelisted";
                last;
            }
            next if $listed;

            for my $b (@blacklist) {
                next if not [$name, $title, $summary, $desc] ~~ $b;
                $listed = 1;
                push @unwanted_entries, $entry;
                VERBOSE && say "$lang - $name - blacklisted";
                last;
            }
            next if $listed;

            if ("$lang|$name" ~~ %db and $title ne $db{"$lang|$name"}) {
                push @unwanted_entries, $entry;
                VERBOSE && say "$lang - $name - unwanted because seen";
            }
            else {
                $db{"$lang|$name"} = $title;
            }
        }

        sleep 0.25;
        redo if $reader->more($feed);
    }

    $reader->mark_read_entry(\@unwanted_entries);
}
