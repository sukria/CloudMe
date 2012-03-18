use Dancer;
use CloudMe::Builder;
use Data::Dumper;

get '/' => sub {
    template 'index';
};


get '/new' => sub {
    template 'new';
};

post '/new' => sub {
    my $text = param('story');
    my $cloud = CloudMe::Builder->new(text => $text);
    template 'new', { 
        top_words => $cloud->top_words,
        cloud => Dumper($cloud->cloud(50)),
        total => $cloud->total_words, 
    };
};

1;
