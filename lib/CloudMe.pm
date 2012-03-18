use Dancer;

get '/' => sub {
    template 'index';
};

1;
