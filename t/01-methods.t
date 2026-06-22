#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'Music::VoicePhrase';

subtest defaults => sub {
    my $obj = new_ok 'Music::VoicePhrase';
    is $obj->verbose, 0, 'verbose';
};

done_testing();
