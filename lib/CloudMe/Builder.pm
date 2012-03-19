package CloudMe::Builder;
use Moo;

has text => (
    is => 'ro',
    required => 1,
);

my $_STOP_WORDS = [qw(
 à de le la les des de du l d et ou où a pour par ont a sont est elle il nous
 vous tu ne vous c on que qui je pas c'est en ce être leur leurs avec ces ses
 trop ici là aujourd
 qu n dans se sa s mes sont y fait il tout toute toutes tous notre votre une veux un ai si
 au plus parce mais son ils sur doit aux comme était nos faut soit même cette
 cela peu puis cet quelque quelques suis vraiment pis
 peut serait ceux m avons  tant depuis été me quand alors avait faire ans
 dont celui car sans mêmes mieux toutes années lui veulent aurait ma aucun
 entre deux cinq mon dix afin très sera ainsi chaque non autre autres seront va 
 hui aussi via donc « »
)];

has stop_words => (
    is => 'rw',
    default => sub { $_STOP_WORDS },
);

sub add_stop_word {
    my ($self, $word) = @_;
    push @{$self->stop_words}, lc($word);
}

has stats => (
    is => 'rw',
    lazy => 1,
    builder => '_build_stats',
    clearer => 'clear_stats',
);

has total_words => (
    is => 'rw',
    default => sub { 0 },
);

sub _build_stats {
    my ($self) = @_;
    my $stats = { };
    $self->total_words(0);
    my $text = $self->text;

    for my $w (split /[\/\[\]\+\-\*\(\),:.;!\?\s"’'\r\n]+/, $text ) {
        $w = lc $w;
        next if length($w) < 3;
        next if grep /^$w$/, @{ $self->stop_words };
        $w = ucfirst $w;

        $stats->{$w}++;
        $self->total_words($self->total_words + 1);
    }

    return $stats;
}

has top_words => (
    is => 'rw',
    lazy => 1,
    builder => '_build_top_words',
);

sub _build_top_words {
    my ($self) = @_;
    my $stats = $self->stats;
    [ sort { $stats->{$b} <=> $stats->{$a} } keys %$stats ];
}

sub cloud {
    my ($self, $nb_words) = @_;
    my $cloud = {};
    
    my $stats     = $self->stats;
    my @top_words = @{ $self->top_words };
    my $total     = $self->total_words;

    for (my $n=0; $n<$nb_words; $n++) {
        my $word = $top_words[$n];
        $cloud->{$word} = $stats->{$word};
    }

    return $cloud;
}

1;
