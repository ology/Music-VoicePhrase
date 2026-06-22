#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'Music::VoicePhrase';

subtest defaults => sub {
    my $obj = new_ok 'Music::VoicePhrase';
    is $obj->base, 'C', 'base';
    is $obj->scale, 'major', 'scale';
    is $obj->octave, 0, 'octave';
    is scalar $obj->pitches->@*, 14, 'pitches';
    is_deeply $obj->intervals, [-3,-2,-1,1,2,3], 'intervals';
    isa_ok $obj->_voice, 'Music::VoiceGen';
    is $obj->size, 4, 'size';
    is_deeply $obj->pool, [qw(dhn hn qn)], 'pool';
    is $obj->verbose, 0, 'verbose';
};

done_testing();
