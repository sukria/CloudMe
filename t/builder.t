use strict;
use warnings;
use CloudMe::Builder;
use File::Basename 'dirname';
use File::Spec;
use File::Slurp;
use Test::More;

my $file = File::Spec->catfile(dirname(__FILE__), 'fixtures', 'discours-sarkozy-1.txt');
my $text = read_file($file);

my $cb = CloudMe::Builder->new(text => $text);

my $cloud = $cb->cloud(10);
is_deeply $cloud, {
    'Israël' => 33,
    'France' => 22,
    'Gilad' => 13,
    'Dit' => 12,
    'Dire' => 10,
    'Histoire' => 9,
    'Façon'  => 8,
    'Président' => 8,
    'Affaire' => 8,
    'Simplement' => 7,
};

$cb = CloudMe::Builder->new(text => $text);
$cb->add_stop_word('Israël');
$cb->add_stop_word('France');
$cb->add_stop_word('Gilad');
$cb->add_stop_word('Dit');
$cb->add_stop_word('Dire');
$cb->add_stop_word('Affaire');

$cloud = $cb->cloud(5);
is_deeply $cloud, {
    'Histoire' => 9,
    'Président' => 8,
    'Façon' => 8,
    'Chose' => 7,
    'Simplement' => 7,
    
    };

done_testing;
