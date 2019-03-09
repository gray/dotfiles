#!/usr/bin/env perl
use 5.012;
use warnings;

use Config::Tiny;
use CPAN::DistnameInfo;
use Cwd qw(realpath);
use DB_File;
use DBM_Filter;
use File::Find;
use FindBin;
use List::Util qw(any);
use PerlIO::gzip;
use WebService::Google::Reader;

use constant VERBOSE => not $ENV{CRON};

my $creds = Config::Tiny->read("$ENV{HOME}/.inoreader")
    or die Config::Tiny->errstr;
my $appid    = $creds->{_}{appid}    // die 'Missing appid';
my $appkey   = $creds->{_}{appkey}   // die 'Missing appkey';
my $username = $creds->{_}{username} // die 'Missing username';
my $password = $creds->{_}{password} // die 'Missing password';

my $db = tie my %db, DB_File => "$FindBin::Bin/.unwanted-modules.bdb";
$db->Filter_Push('utf8');

my $reader = WebService::Google::Reader->new(
    host     => 'www.inoreader.com',
    username => $username,
    password => $password,
    appid    => $appid,
    appkey   => $appkey,
    https    => 1,
);

my $conf = read_conf();
my $feed = $reader->tag(Modules =>
    count      => 500,
    exclude    => { state => 'read' },
    order      => 'asc',
    VERBOSE ? () : ( start_time => $db{_last_time} ),
);
die $reader->error unless $feed;

my (%unread, %unseen, @unwanted_entry);

ENTRY:
for my $entry ($feed->entries) {
    my $source  = substr $entry->source->get_attr('gr:stream-id'), 5;
    my $conf    = $conf->{$source}
        or warn "Unexpected feed: $source\n" and next;
    my $lang    = $conf->{lang} // next;
    my $title   = $entry->title;
    my $name    = $conf->{name}($entry)
        or warn "Couldn't extract name from $title\n" and next;
    my $summary = $entry->summary // '';
    my $desc    = $entry->content // '';
       $desc  &&= $desc->body;

    my $sw = "$lang|$name";
    if (my $entry = $unread{$sw}) {
        push @unwanted_entry, $entry;
        say "$lang - $name - discarding in favor of newer unread entry"
            if VERBOSE;
    }
    $unread{$sw} = $entry;

    for my $rule (@{$conf->{blacklist} || []}) {
        my $ref = ref $rule;
        if ('CODE' eq $ref) {
            next unless $rule->($entry);
        }
        elsif ('Regexp' eq $ref) {
            next unless any { /$rule/ } $name, $title, $summary, $desc;
        }
        else {
            warn 'Unexpected blacklist filter type: ',
                $ref ? "$ref ref" : 'SCALAR';
            next;
        }
        push @unwanted_entry, $entry;
        VERBOSE && say "$lang - $name - blacklisted";
        next ENTRY;
    }

    for my $rule (@{$conf->{whitelist} || []}) {
        my $ref = ref $rule;
        if ('CODE' eq $ref) {
            next unless $rule->($name);
        }
        else {
            warn 'Unexpected whitelist filter type: ',
                $ref ? "$ref ref" : 'SCALAR';
            next;
        }
        VERBOSE && say "$lang - $name - whitelisted";
        next ENTRY;
    }

    if (! $unseen{$sw} and exists $db{$sw} and $title ne $db{$sw}) {
        push @unwanted_entry, $entry;
        VERBOSE && say "$lang - $name - unwanted because seen";
    }
    else {
        $unseen{$sw} = 1;
        $db{$sw} = $title;
    }
}

sleep 0.25;
goto ENTRY if $reader->more($feed);

$reader->mark_read_entry(\@unwanted_entry) or die $reader->error;

$db{_last_time} = time;

exit;


sub read_conf {
    return {
        'https://metacpan.org/feed/recent' => do {
            my $dist;
            {
                lang => 'perl',
                name => sub {
                    $dist = CPAN::DistnameInfo->new($_[0]->title . '.tgz');
                    $dist->dist;
                },
                whitelist => [
                    sub {
                        state $is_installed = is_perl_dist_installed();
                        'released' eq $dist->maturity
                            and $is_installed->($_[0]);
                    },
                ],
                blacklist => [
                    sub {
                        return 1 unless defined $dist->version;
                        return 1 if $dist->distvname !~ tr/-//;
                        return 1 if $dist->dist =~ m[
                            ^ (?:
                                acme | biox? | dancer2? | device | dist-zilla
                                | map | panda | rtx? | task-belike | util
                            ) (?:-|$)
                        ]ix;
                        return 1 if $dist->dist =~ m[
                            (?:^|-) (?:
                                alien | bundle | catalystx? | catmandu | cgi
                                | kensho | mojo[^-]* | moo(?:se)?x? | poex?
                                | win(?: 32 | dows)[^-]*
                            ) (?:-|$)
                        ]ix;
                        # Ignore foreign languages.
                        return 1 if $dist->dist =~ m[
                            ^Lingua- (?: (?!en)(?=\w{2}-) | (?!eng)(?=\w{3}-) )
                        ]ix;
                        # Prolific purveyors of piffleware.
                        my %blacklist = map { $_ => 1 } qw(
                            ahernit adoptme akalinux alambike amaltsev aspose
                            athreef aubertg awncorp bayashi bkb binary
                            bluefeet capoeirab corliss csson curtis dannyt
                            dbook dfarrell diederich djerius dragosv etj
                            faraco ferreira gene geotiger getty gryphon
                            hanenkamp idoperel ina lnation ingy ironcamel
                            ivanwills jasei jberger jeffober jeffzhang jgni
                            jhthorsen jlmartin jmaslak jpr jv jvbsoft
                            kaavannan kentnl kfly khedin kimoto lskatz
                            madskill manwar maty mauke melezhik mhcrnl miko
                            mqtech newellc niczero orange orkun pavelsr
                            pekingsam perlancar plicease prbrenan psixdists
                            reedfish reneeb rrwo rsavage sharyanto sillymoos
                            skim sms spebern steffenw steveb szabgab tabulo
                            tapper team tobyink tulamili turnerjw voj wangq
                            vvelox woldrich yanick zdm znmstr zoffix
                        );
                        return 1 if $blacklist{ lc $_[0]->author->name };

                        # Ignore ego dists; they're likely useless to others.
                        return 1 if $dist->dist =~ m[
                            \b @{[ $_[0]->author->name ]} \b
                        ]ix;

                        return 0;
                    },
                    sub { 'released' ne $dist->maturity },
                ],
            }
        },

        'http://pypi.python.org/pypi?:action=rss' => {
            lang => 'python',
            name => sub {
                my ($name) = $_[0]->link->href =~ m[
                    ^http://pypi\.python\.org/pypi/([^/]+)
                ]x;
                return $name;
            },
            blacklist => [
                qr/ (?:\b|_) (?:django | flask | plone | zope) (?:\b|_) /ix,
                qr/ ^nknu /ix,  # spammer
                sub {
                    my $s = $_[0]->summary;
                    return 1 unless $s;
                    return 1 if 'unknown' eq lc $s;
                    return 1 if $s =~ /\b [nt]est /ix;
                    return 1 if $s =~ /\b print /ix
                        and $s =~ /\b (?: list | array ) /ix;
                },
            ],
        },

        'http://feeds.feedburner.com/gemcutter-latest' => {
            lang => 'ruby',
            name => sub {
                my ($name) = $_[0]->link->href =~ m[
                    ^http://rubygems\.org/gems/([^?/]+)
                ]x;
                return $name;
            },
            blacklist => [
                qr/ (?:\b|_) (?:
                    rails | sinatra | active\W?record
                ) (?:\b|_) /ix,
            ],
        },

        'http://hackage.haskell.org/packages/archive/recent.rss' => {
            lang => 'haskell',
            name => sub { ($_[0]->title =~ m[^\s*(\S+)])[0] },
        },

        'http://feed43.com/vim-scripts.xml' => {
            lang => 'vimscripts',
            name => sub {
                my ($title, $name) = $_[0]->title =~ m[^\s*((.*?)\s+\S+) --];
                $_[0]->title($title);
                return $name;
            },
        },

        'http://registry.npmjs.org/-/rss?descending=true&limit=50' => {
            lang => 'node',
            name => sub { $_[0]->title =~ m[ (.*) \@ ]x; $1 },
            blacklist => [ sub { not $_[0]->summary } ],
        },

        # These feeds only contain new packages, so no filtering is needed.
        map({ $_ => {} } qw(
            http://dirk.eddelbuettel.com/cranberries/cran/new/index.rss
        )),
    };
}


# Return a sub that checks if the given Perl dist is installed.
sub is_perl_dist_installed {
    # Find the list of installed modules.
    my (%module, %prune);
    for my $top (reverse sort @INC) {
        next if '.' eq $top;
        my $len = length $top;
        find {
            wanted => sub {
                if (exists $prune{$File::Find::dir}) {
                    $File::Find::prune = 1;
                    return;
                }
                return unless '.pm' eq substr $_, -3, 3, '';
                return unless -f _;
                substr $_, 0, 1 + $len, '';
                s{[\\/]}{::}g;
                $module{$_} = undef;
            },
            no_chdir => 1
        }, $top;
        $prune{$top} = undef;
    }

    # Fetch the file that maps packages to distributions.
    my $file = '02packages.details.txt.gz';
    my $url = "http://www.cpan.org/modules/$file";
    $file = "/tmp/$file";
    if (not -r $file or 1 < -M _) {
        my $ua = $reader->ua->clone;
        $ua->default_header(accept_encoding => undef);
        my $res = $ua->mirror($url, $file);
        die "Failed to mirror $file: ", $res->status_line if $res->is_error;
    }
    open my $fh, '<:gzip', $file or die "$file: $!";

    # Skip header.
    while (<$fh>) { last if "\n" eq $_ }

    # Determine the installed distributions, given the installed modules.
    my %dist;
    while (my $line = <$fh>) {
        my ($package, $version, $dist) = split /\s+/, $line;
        next unless exists $module{$package};
        my $info = CPAN::DistnameInfo->new($dist)->dist;
        next unless $info;
        $dist{$info} = undef;
    }
    close $fh;

    sub { exists $dist{$_[0] } }
};
