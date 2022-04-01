#!/usr/bin/env perl
use strict;
use warnings;
use 5.012;

use Capture::Tiny qw(capture);
use File::Which;
use Getopt::Long;
use Path::Tiny;
use Pod::Usage;
use Set::IntSpan::Fast;

for (qw(pdfgrep mutool)) {
    die "`$_` isn't installed" unless defined which $_;
}

GetOptions(
    'help|man|?'  => \my $help,
    'example|e=s' => \my @example
) or pod2usage();
pod2usage(-verbose => 2) if $help;
pod2usage() unless @ARGV;
pod2usage("Example pages can only be used when a single file is given")
    if @example and (1 < @ARGV or ! -f $ARGV[0]);

for my $file (@ARGV) {
    my $path = path($file);
    if (-d $path) {
        $path->visit(\&process_path, { recurse => 1 });
    }
    else {
        process_path($path);
    }
}

exit;


sub run_cmd {
    my @cmd = @_;
    my ($out, $err) = capture { system @cmd };

    # Propogate control-c from the child process.
    for ($? & 127) { exit $_ if 2 == $_ or 3 == $_ }

    $err = 'unknown error' unless length $err;
    if ($? >>= 8) { $@ = "$cmd[0]: $err" }

    return $out;
}


sub process_path {
    my $path = shift;
    return unless $path =~ /\.pdf$/ and -f $path and ! -l $path;

    my $info = run_cmd mutool => qw(info -M), $path, 'N';
    return 0, warn "$path : $@\n" if $?;
    my ($max_page) = $info =~ /^Pages: \s+ (\d+)/mx;
    return 0, warn "$path : failed to determine page count\n"
        unless $max_page;
    my $set = Set::IntSpan::Fast->new("1-$max_page");

    my $blank = Set::IntSpan::Fast->new;
    if (@example) {
        @example = map { split /,/ } @example;
        die "Invalid example page number: $_\n"
            for grep { ! /^[0-9]+$/ or ! $_ or $max_page < $_ } @example;
        $blank->add(@example);
        @example = $blank->as_array;  # remove duplicates
    }
    my $todo = $set->diff($blank);

    my $pattern = '^\s*this page(?:is|has been)? intentionally left blank\s*$';
    my $out = run_cmd qw(pdfgrep -iPp), $blank->is_empty ? ()
        : (qw(--page-range), $todo->as_string), $pattern, $path;
    return 0, warn "$path : $@\n" if 2 == $?;
    $blank->add($out =~ /^(\d+):/mg);
    $todo = $set->diff($blank);

    my $dir = Path::Tiny->tempdir;
    my @cmd = (qw(mutool convert -F png -o), "$dir/%d.png", $path);
    if (! $blank->is_empty) {
        $set = $todo->copy;
        $set->add(@example) if @example;
        push @cmd, $set->as_string;
    }
    $out = run_cmd @cmd;
    return 0, warn "$path : $@\n" if $?;
    my @page; @page[$set->as_array] = (1 .. $set->cardinality);

    for (@example) {
        $_ = Imager->new(file => "$dir/$page[$_].png") or return 0,
            warn "page $_: ", Imager->errstr // 'unknown error', "\n";
    }
    my $img = Imager->new;
    for my $p ($todo->as_array) {
        $img->read(file => "$dir/$page[$p].png") or return 0,
            warn "page $p: ", $img->errstr // 'unknown error', "\n";
        if (is_blank($img)) { $blank->add($p); next }
        for (@example) {
            if (is_example($img, $_)) { $blank->add($p); last }
        }
    }

    say "$path : ", $blank->as_string
        if ! $blank->is_empty;
}


my $dir; BEGIN { $dir = path('~/.perl/Inline'); $dir->mkpath }
use Inline config => autoname => 0, directory => $dir;
use Inline with => 'Imager';
use Inline C => <<'EOF';

#define IMAGER_NO_CONTEXT

int
is_blank(Imager::ImgRaw img) {
    int x, y, width = img->xsize, height = img->ysize;
    i_color cur, prev;

    i_gpix(img, 0, 0, &prev);
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            i_gpix(img, x, y, &cur);
            if (cur.rgb.r != prev.rgb.r || cur.rgb.g != prev.rgb.g
                    || cur.rgb.b != prev.rgb.b)
                return 0;
        }
    }

    return 1;
}

int
is_example(Imager::ImgRaw img1, Imager::ImgRaw img2) {
    int x, y, width = img1->xsize, height = img1->ysize;
    i_color c1, c2;

    if (width != img2->xsize || height != img2->ysize) return 0;

    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            i_gpix(img1, x, y, &c1);
            i_gpix(img2, x, y, &c2);
            if (c1.rgb.r != c2.rgb.r || c1.rgb.g != c2.rgb.g
                    || c1.rgb.b != c2.rgb.b)
                return 0;
        }
    }

    return 1;
}

EOF

__END__

=head1 NAME

pdf-find-blank-pages.pl

=head1 SYNOPSIS

  pdf-find-blank-pages.pl [path ...]
  pdf-find-blank-pages.pl -e page [file]

=head1 DESCRIPTION

This program finds blanks pages in PDF files and reports the page numbers.

=head2 OPTIONS

=over

=item B<-e>, B<--example>

By default, blank pages are assumed to be entire pages rendered of the same
color or containing text indicating it's blank. Use this option to specify
a page number of an example page against which other pages should be further
compared as rendered images.

Multiple pages may be specified (ex. -e 3,17 or -e 3 -e 17).

This option can only be used if a single file is given as input.

=back

=cut
