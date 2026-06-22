package Music::VoicePhrase;

# ABSTRACT: Construct a phrase of rhythmic voices

our $VERSION = '0.0100';

use Moo;
use strictures 2;
use Carp qw(croak);
use Music::Duration::Partition ();
use Music::Scales qw(get_scale_MIDI);
use Music::VoiceGen ();
use namespace::clean;

=head1 SYNOPSIS

  use Music::VoicePhrase ();

  my $mvp = Music::VoicePhrase->new(verbose => 1);

=head1 DESCRIPTION

A C<Music::VoicePhrase> constructs a phrase of rhythmic voices.

=head1 ATTRIBUTES

=head2 base

  $base = $mvp->base;

Base scale note.

Default: C<C>

=cut

has base => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a valid note" unless $_[0] =~ /^[A-G][#b]$/i },
    default => sub { 'C' },
);

=head2 scale

  $scale = $mvp->scale;

Scale name known to the L<Music::Scales> module.

Default: C<major>

=cut

has scale => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a valid scale name" unless $_[0] =~ /^\w+$/ },
    default => sub { 'major' },
);

=head2 octave

  $octave = $mvp->octave;

Octave integer from C<0> to C<9>.

Default: C<0>

=cut

has octave => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a valid octave" unless $_[0] =~ /^[0-9]$/ },
    default => sub { 0 },
);

=head2 pitches

  $pitches = $mvp->pitches;

Scale name known to the L<Music::Scales> module.

Default: 2 consecutive octaves given the B<base> note, B<scale> name, and starting B<octave>.

=cut

has pitches => (
    is      => 'lazy',
    isa     => sub { croak "$_[0] is not an array-ref" unless ref $_[0] eq 'ARRAY' },
    builder => '_build_pitches',
);

sub _build_pitches ($self) {
  my @pitches = (
    get_scale_MIDI($self->base, $self->octave, $self->scale),
    get_scale_MIDI($self->base, $self->octave + 1, $self->scale),
  );
  return \@pitches;
}

=head2 intervals

  $intervals = $mvp->intervals;

Intervals that define the L<Music::VoiceGen> selection.

Default: [-3, -2, -1, 1, 2, 3]

=cut

has intervals => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not an array-ref" unless ref $_[0] eq 'ARRAY' },
    default => sub { [-3, -2, -1, 1, 2, 3] },
);

has _voice => (
    is      => 'lazy',
    builder => '_build__voice',
);

sub _build__voice ($self) {
    my $voice = Music::VoiceGen->new(
        pitches   => $self->pitches,
        intervals => $self->intervals,
    );
    return $voice;
}

=head2 size

  $size = $mvp->size;

Size of a measure.

Default: C<4>

=cut

has size => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a valid size" unless $_[0] =~ /^\d+$/ },
    default => sub { 4 },
);

=head2 pool

  $pool = $mvp->pool;

The pool of note durations, given in Perl L<MIDI> abbreviated
notation, that define the L<Music::Duration::Partition> phrase.

Default: ['dhn', 'hn', 'qn']

=cut

has pool => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not an array-ref" unless ref $_[0] eq 'ARRAY' },
    default => sub { [qw(dhn hn qn)] },
);

=head2 weights

  $weights = $mvp->weights;

Weights that define the L<Music::Duration::Partition> phrase.

Default: [ 1, 2, 2 ]

=cut

has weights => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not an array-ref" unless ref $_[0] eq 'ARRAY' },
    default => sub { [1, 2, 2] },
);

=head2 groups

  $groups = $mvp->groups;

Groups that define the L<Music::Duration::Partition> phrase.

Default: [ 0, 0, 0 ]

=cut

has groups => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not an array-ref" unless ref $_[0] eq 'ARRAY' },
    default => sub { [0, 0, 0] },
);

has _rhythm => (
    is      => 'lazy',
    builder => '_build__rhythm',
);

sub _build__rhythm ($self) {
  my $mdp = Music::Duration::Partition->new(
      size    => $self->size,
      pool    => $self->pool,
      weights => $self->weights,
      groups  => $self->groups,
  );
}

=head2 motifs

  $motifs = $mvp->motifs;

The rhythmic motifs given by L<Music::Duration::Partition>.

This is a computed attribute from the C<build_motifs()> method.

Default: C<4> motifs

=cut

has motifs => (
    is       => 'rw',
    init_arg => undef
);

=head2 motif_num

  $motif_num = $mvp->motif_num;

The number of motifs to generate by the C<build_motifs()> method.

Default: C<4>

=cut

has motif_num => (
    is      => 'rw',
    isa     => sub { croak "$_[0] is not an integer" unless $_[0] =~ /^\d+$/ },
    default => sub { 4 },
);

=head2 verbose

  $verbose = $mvp->verbose;

Show progress.

Default: C<0>

=cut

has verbose => (
    is      => 'ro',
    isa     => sub { croak "$_[0] is not a boolean" unless $_[0] =~ /^[01]$/ },
    default => sub { 0 },
);

=head1 METHODS

=head2 new

  $mvp = Music::VoicePhrase->new(%arguments);

Create a new C<Music::VoicePhrase> object.

=for Pod::Coverage BUILD

=cut

sub BUILD ($self, $args) {
    $self->build_motifs;
}

=head2 build_motifs

  $motifs = $mvp->build_motifs;

Build a list of motifs given the B<motif_num>.

=cut

sub build_motifs ($self) {
    my $motifs = $self->_rhythm->motifs($self->motif_num);
    $self->motifs($motifs);
    return $motifs;
}

1;
__END__

=head1 SEE ALSO

L<Moo>

L<Music::Duration::Partition>

L<Music::Scales>

L<Music::VoiceGen>

=cut
