
use School::Evaluation::Gibbmers::Chart;

my $chart = School::Evaluation::Gibbmers::Chart->new();

$chart->set_1bad_sizes([1, 0, 0]);
$chart->set_2mid_sizes([2, 2, 0]);
$chart->set_3hig_sizes([1, 5, 0]);
$chart->set_4sup_sizes([0, 3, 2]);

$chart->render_chart('bubble.png');
