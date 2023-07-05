#!/usr/bin/perl
# usage: perl -w FindDbl ch01.txt
use strict;
use utf8;
$/ = ".\n"; # Sets a special ‘‘chunk-mode’’; chunks end with a period-newline combination
my $filename = $ARGV[0];
binmode(STDOUT, "encoding(UTF-8)");
open my $in,  '<:encoding(UTF-8)',  $filename  or die $!;
while (<$in>)
{
  next unless s{ # (regex starts here)
    ### Need to match one word:
    \b       # Start of word ...
    #( \p{L}[-\p{L}']* ) # Grab word, fillig $1 (and \1).
    ( \w+ ) # Grab word, filling $1 (and \1).
    ### Now need to allow any number of spaces and/or <TAGS>
    (   # Save what intervenes to $2.
      (?: # (Non-capturing parens for grouping the alternation)
        \s      # Whitespace (includes newline, which is good).
        |       # -or-
        <[^>]+> # Item like <TAG>.
        |       # -or-
        \\[a-z0-9]+\{ # TeX
      )+ # Need at least one of the above, but allow more.
    )
    ### Now match the first word again:
    (\1\b) # \b ensures not embedded. This copy saved to $3.
    # (r egex ends here)
    }
    # Above is the regex. The replacement string is below, followed by the modifiers, /i, /g, and /x
    {\e[7m$1\e[m$2\e[7m$3\e[m}igx; # add ANSI escape sequences that provide highlighting
    s/^(?:[^\e]+\n)+//mg; # Remove any unmarked lines.
    s/^/$filename: /mg; # Ensure lines begin with filename.
    print;
}
