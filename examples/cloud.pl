use strict;
use warnings;
use List::Util 'shuffle';
use Scalar::Util 'looks_like_number';

my $words = {};
my $nb_words = 100;

my @empty = qw(
 à de le la les des de du l d ' et ou où a pour par ont a sont est elle il nous
 vous tu ne vous c on que qui je pas c'est en ce être leur leurs avec ces ses
 qu n dans se sa s mes sont y fait il tout tous notre votre une veux un ai si
 au j plus parce mais son ils sur doit aux comme était nos faut soit même cette
 peut serait ceux m avons « » tant depuis été me quand alors avait faire ans
 dont celui car sans mêmes mieux toutes années lui veulent aurait ma aucun
 entre devait voulons deux cinq veut mon dix afin très sera tion ainsi chaque
 non rendre notamment p autre autres seront va ferai mettrai réformerai
 proposerai  renforcerai créerai contre engagerai hui aussi via donc ayant
 moins plus devra aujourd fin mettre etc
 );

my $total_words = 0;
while (<STDIN>) {
    my @words = split /[\/\[\]%\+\-\*\(\),:.;!\?\s’']+/;

    for my $w (@words) {
        $w = lc $w;
        $w =~ s/É/é/g;
        $w =~ s/crises/crise/g;

        next if grep /^$w$/, @empty;
        next if $w =~ /^\d+$/;
        $w = ucfirst $w;
        $words->{$w}++;
        $total_words++;
    }
}

my @top = sort { $words->{$b} <=> $words->{$a} } keys %$words;

my $count = 0;

my $cloud = {};

my $total = 0;

foreach my $w (@top) {
    
    $cloud->{$w} = $words->{$w};
    $total += $cloud->{$w};

    last if $count++ > $nb_words;
}

print "<html>
<head>

<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> 

</head>

<body>

<h1>Discours de Nicolas Sarkozy en 100 mots.</h1>
<p>
Source: <a href=\"http://www.u-m-p.org/sites/default/files/fichiers_joints/articles/11_03_discours_villepinte.pdf\">Discours du 11 mars 2012, Villepinte</a>.
</p>

<style type=\"text/css\">

div#cloud {
    font-family: sans-serif;
    font-weight: bold;
    color: #000000;
    margin: 1em;
    width: 500px;
    padding: 1em;
    font-size: 16px;
}

.huge {
        font-size: 300%;
    color: #AA0000;
}

.big {
        font-size: 200%;
    color: #0000AA;
}

.normal { 
        font-size: 100%;
}

.small {
        font-size: 65%;
}

.tiny {
        font-size: 30%;
}

</style>

<div id=\"cloud\">
";


my $avg = $total / $nb_words ;

print "
<pre>
    avg : $avg
    total : $total
    nb_words : $nb_words
    total_words : $total_words
</pre>
";

foreach my $word (shuffle (keys (%$cloud))) {
    my $percent = $cloud->{$word} * 100 / $total;

    my $class = '';
    if ($percent > $avg * 0.25) {
        $class = 'huge';
    }
    elsif ($percent > ($avg * 0.15)  ) {
        $class = 'big';
    }
    elsif ($percent >= ($avg * 0.07) ) {
        $class = 'normal';
    }
    elsif ($percent > ($avg * 0.01) ) {
        $class = 'small';
    }
    else {
        $class = 'tiny';
    }

    print "<span class='$class'>$word</span>\n";
}

print "</div></body></html>";

