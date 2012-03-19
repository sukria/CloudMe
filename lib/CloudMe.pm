use Dancer;
use CloudMe::Builder;
use HTML::TagCloud::Centred;
use CGI::Util;

set charset => 'utf8';

get '/' => sub {
    template 'index';
};


get '/new' => sub {
    template 'new';
};

post '/new' => sub {
    my $text = param('story');
    my $nb_words = param('nb_words') || 50;
    my @ignore_words = split(',', param('ignore_words') || '');

    debug "ignore_words: ".join(', ', @ignore_words);

    my $cb = CloudMe::Builder->new(text => $text);
    $cb->add_stop_word($_) for @ignore_words;

    my $cloud = HTML::TagCloud::Centred->new(
                size_min_pc => 50,
                size_max_pc => 300,
#                scale_code => sub { 
#                    my $self = shift;
#                    ($self->{size_max_pc} - $self->{size_min_pc}) / 
#                    CORE::log(scalar($self->{words})) * 0.8 ;
#                },
                html_esc_code => sub { $_[0] },
                clr_max => '#FF0000',
                clr_min => '#550000',
        );

    $cloud->add($_, "javascript:zoom_in_cloud(\"$_\");") for keys %{ $cb->cloud($nb_words) };

    template 'new', { 
        cloud => $cloud->html_and_css,
        ignore_words => join(',', @ignore_words),
        text => $text,
    };
};

1;
