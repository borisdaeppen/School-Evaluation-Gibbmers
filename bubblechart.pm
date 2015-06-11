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

my $bad = [0, 0, 0, 0];
my $mid = [0, 0, 0, 0];
my $hig = [0, 0, 0, 0];
my $sup = [0, 0, 0, 0];

sub set_1bad_sizes {
}
sub set_2mid_sizes {
}
sub set_3hig_sizes {
}
sub set_4sup_sizes {
}

my $cc = Chart::Clicker->new(width => 500, height => 250, format => 'png');


my $values_bad = Chart::Clicker::Data::Series::Size->new(
    keys    => [qw(1 2 3 4)],
    values  => [qw(1 1 1 1)],
    sizes   => [qw(2 1 0 0)],
    name    => "Schlecht"
);

my $values_mid = Chart::Clicker::Data::Series::Size->new(
    keys    => [qw(1 2 3 4)],
    values  => [qw(2 2 2 4)],
    sizes   => [qw(1 5 2 1)],
    name    => "Naja"
);

my $values_hig = Chart::Clicker::Data::Series::Size->new(
    keys    => [qw(1 2 3 4)],
    values  => [qw(3 3 3 3)],
    sizes   => [qw(0 1 6 2)],
    name    => "Gut"
);

my $values_sup = Chart::Clicker::Data::Series::Size->new(
    keys    => [qw(1 2 3 4)],
    values  => [qw(4 4 4 4)],
    sizes   => [qw(0 0 4 3)],
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
$cnf->domain_axis->tick_values([qw(1 2 3 4)]);
$cnf->domain_axis->tick_labels(['kein Interesse', 'wenig Interesse', 'Interessant', 'Lieblingsfach']);
$cnf->renderer(Chart::Clicker::Renderer::Bubble->new);

$cc->write_output('bubble.png');
