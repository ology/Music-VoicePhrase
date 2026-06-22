package Music::VoicePhrase;

# ABSTRACT: Construct a phrase of rhythmic voices

our $VERSION = '0.0100';

use Moo;
use strictures 2;
use Carp qw(croak);
use namespace::clean;

=head1 SYNOPSIS

  use Music::VoicePhrase ();

  my $x = Music::VoicePhrase->new(verbose => 1);

=head1 DESCRIPTION

A C<Music::VoicePhrase> constructs a phrase of rhythmic voices.

=head1 ATTRIBUTES

=head2 verbose

  $verbose = $x->verbose;

Show progress.

=cut

has verbose => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a boolean" unless $_[0] =~ /^[01]$/ },
    default => sub { 0 },
);

=head1 METHODS

=head2 new

  $x = Music::VoicePhrase->new(verbose => 1);

Create a new C<Music::VoicePhrase> object.

=for Pod::Coverage BUILD

=cut

1;
__END__

=head1 SEE ALSO

L<Moo>

L<http://somewhere.el.se>

=cut
