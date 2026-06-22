#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'Music::VoicePhrase';

new_ok 'Music::VoicePhrase';

my $obj = new_ok 'Music::VoicePhrase' => [
    verbose => 1,
];

is $obj->verbose, 1, 'verbose';

done_testing();
