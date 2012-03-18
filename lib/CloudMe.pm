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
    my $cb = CloudMe::Builder->new(text => $text);

    my $cloud = HTML::TagCloud::Centred->new(
                size_min_pc => 50,
                size_max_pc => 300,
                scale_code => sub { 
                    my $self = shift;
                    ($self->{size_max_pc} - $self->{size_min_pc}) / 
                    CORE::log(scalar($self->{words})) * 0.8 ;
                },
                html_esc_code => sub { $_[0] },
                clr_max => '#FF0000',
                clr_min => '#550000',
        );
    $cloud->add($_) for keys %{ $cb->cloud(30) };

    template 'new', { 
        cloud => $cloud->html_and_css,
        text => $text,
    };
};

1;
