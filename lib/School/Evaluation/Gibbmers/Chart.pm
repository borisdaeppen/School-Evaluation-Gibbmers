package School::Evaluation::Gibbmers::Chart;

use strict;
use warnings;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series::Size;
use Geometry::Primitive::Rectangle;
use Chart::Clicker::Renderer::Bubble;
use Graphics::Color::RGB;
use Geometry::Primitive::Circle;


sub new {
    my $class = shift;
    my $self  = {
                    bad => [0, 0, 0],
                    mid => [0, 0, 0],
                    hig => [0, 0, 0],
                    sup => [0, 0, 0],
        };
    bless ($self, $class);
}
sub set_1bad_sizes {
    my $self = shift;
    $self->{bad} = shift;
}
sub set_2mid_sizes {
    my $self = shift;
    $self->{mid} = shift;
}
sub set_3hig_sizes {
    my $self = shift;
    $self->{hig} = shift;
}
sub set_4sup_sizes {
    my $self = shift;
    $self->{sup} = shift;
}

sub render_chart {
    my $self = shift;
    my $filename = shift;

    my $cc = Chart::Clicker->new(   width  => 400,
                                    height => 300,
                                    format => 'png');
    
    my $values_bad = Chart::Clicker::Data::Series::Size->new(
        keys    => [qw(1 2 3)],
        values  => [qw(1 1 1)],
        sizes   => $self->{bad},
        name    => "Schlecht"
    );
    
    my $values_mid = Chart::Clicker::Data::Series::Size->new(
        keys    => [qw(1 2 3)],
        values  => [qw(2 2 2)],
        sizes   => $self->{mid},
        name    => "Naja"
    );
    
    my $values_hig = Chart::Clicker::Data::Series::Size->new(
        keys    => [qw(1 2 3)],
        values  => [qw(3 3 3)],
        sizes   => $self->{hig},
        name    => "Gut"
    );
    
    my $values_sup = Chart::Clicker::Data::Series::Size->new(
        keys    => [qw(1 2 3)],
        values  => [qw(4 4 4)],
        sizes   => $self->{sup},
        name    => "Super"
    );
    
    $cc->title->text('Unterlagen Modul');
    $cc->title->padding->bottom(5);
    
    my $ds = Chart::Clicker::Data::DataSet->new(
        series => [ $values_bad,
                    $values_mid,
                    $values_hig,
                    $values_sup,
                  ]);
    
    $cc->add_to_datasets($ds);
    
    my $cnf = $cc->get_context('default');
    
    $cnf->range_axis->fudge_amount(.2);
    $cnf->domain_axis->fudge_amount(.2);
    $cnf->range_axis->hidden(0);
    $cnf->domain_axis->hidden(0);
    $cnf->range_axis->tick_values([qw(1 2 3 4)]);
    $cnf->range_axis->tick_labels(['Schlecht', 'Naja', 'Gut', 'Super']);
    $cnf->domain_axis->tick_values([qw(1 2 3)]);
    $cnf->domain_axis->tick_labels(['wenig Interesse', 'Interessant', 'Lieblingsfach']);
    $cnf->renderer(Chart::Clicker::Renderer::Bubble->new);
    
    $cc->write_output($filename);
}

1;

