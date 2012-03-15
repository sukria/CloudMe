use Image::WordCloud;
use File::Slurp;

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
 tre tr 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
 etait tire vers lorsqu eu oui 
    pr r sident europ g e t foi ais fran contr sident
    int tait rai cider prot soient aucune
enne rieur trise
    pronoc gle en fais avoir am bat re cisions diff tat b o ts mis al cr es march mais dit
    ni trop tatsunis toute inter

 );

my $wc = Image::WordCloud->new( 
    image_size => [800, 600],
    word_count => 130,
);
$wc->add_stop_words(@empty);

my $text = read_file($ARGV[0]);
$wc->words($text);

# Create the word cloud as a GD image
my $gd = $wc->cloud();

open(my $fh, '>', 'cloud.png');
binmode $fh;
print $fh $gd->png();
close($fh);

