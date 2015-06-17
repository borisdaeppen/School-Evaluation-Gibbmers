use Mojolicious::Lite;
use Mojo::Cache;
use School::Evaluation::Gibbmers::Chart;

# this cache will hold all the data during a poll
# each poll needs to have a freshly started server
# we will assume, that there won't be mor than 30 clients
my $cache = Mojo::Cache->new(max_keys => 30);

# data structure:      # topic     # value      # interests
$cache->set(poll =>
                    {   Teilnehmer    =>    { 1    => [ 0,    0,     0 ],
                                       2    => [ 0,    0,     0 ],
                                       3    => [ 0,    0,     0 ],
                                       4    => [ 0,    0,     0 ],
                        },
                        Unterlagen =>    { 1    => [ 0,    0,     0 ],
                                       2    => [ 0,    0,     0 ],
                                       3    => [ 0,    0,     0 ],
                                       4    => [ 0,    0,     0 ],
                        },
                        Klasse  =>    { 1    => [ 0,    0,     0 ],
                                       2    => [ 0,    0,     0 ],
                                       3    => [ 0,    0,     0 ],
                                       4    => [ 0,    0,     0 ],
                        },
                        Lehrperson=>    { 1    => [ 0,    0,     0 ],
                                       2    => [ 0,    0,     0 ],
                                       3    => [ 0,    0,     0 ],
                                       4    => [ 0,    0,     0 ],
                        },
                    });

# start page with menu links
get '/' => {template => 'root'};

# page with questions in a form to fill out
# for clients
get '/form' => {template => 'form'};

# page triggered by the form-page
# evaluate what clients said
get '/vote' => sub {

    my $self = shift;

    my $client_ip = $self->tx->remote_address;

    if ($cache->get($client_ip)) {
        $self->stash( message => "Sie haben bereits teilgenommen!" );
        return $self->render;
        # EXIT and render
    }

    $cache->set($client_ip => 1);

    my $interest = $self->param('interest');
    my $Teilnehmer      = $self->param('Teilnehmer');
    my $Unterlagen   = $self->param('Unterlagen');
    my $Klasse    = $self->param('Klasse');
    my $Lehrperson  = $self->param('Lehrperson');

    my $poll = $cache->get('poll');

    foreach my $topic (keys $poll) {
        $poll->{$topic}->{$Teilnehmer}    ->[$interest-1]++ if($topic eq 'Teilnehmer');
        $poll->{$topic}->{$Unterlagen} ->[$interest-1]++ if($topic eq 'Unterlagen');
        $poll->{$topic}->{$Klasse}  ->[$interest-1]++ if($topic eq 'Klasse');
        $poll->{$topic}->{$Lehrperson}->[$interest-1]++ if($topic eq 'Lehrperson');
    }

    #use Data::Dumper;
    #print Dumper($poll);

    $cache->set('poll' => $poll);

    $self->stash( message => "Danke für die Teilnahme!" );
        
} => 'vote'; # template call

# page to collect the results
# best used after all clients have sent data
# will create pictures on the harddrive
get '/poll' => sub {

    my $self = shift;

    my $poll = $cache->get('poll');

    foreach my $topic (keys $poll) {
        my $chart = School::Evaluation::Gibbmers::Chart->new();
        
        $chart->set_1bad_sizes($poll->{$topic}->{1});
        $chart->set_2mid_sizes($poll->{$topic}->{2});
        $chart->set_3hig_sizes($poll->{$topic}->{3});
        $chart->set_4sup_sizes($poll->{$topic}->{4});

        $chart->render_chart("Auswertung $topic", 'public/' . $topic . '.png');
    }

} => 'poll';

app->start;

__DATA__

@@ root.html.ep
<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8"><title>Gibbmers</title></head>
<body>
<h1>GIBBmers - Unterrichtsauswertung</h1>
<ul>
<li><a href="/form">Fragebogen</li>
<li><a href="/poll">Auswertung</li>
</body>
</html>

@@ vote.html.ep
<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8"><title>Gibbmers</title></head>
<body>
<%= $message %>
</body>
</html>

@@ poll.html.ep
<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8"><title>Gibbmers</title></head>
<body>
 <h1>Auswertung</h1>
 <img src="Teilnehmer.png" alt="Selbsteinschätzung"> 
 <img src="Klasse.png" alt="Klassenklima"><br />
 <img src="Unterlagen.png" alt="Modulunterlagen"> 
 <img src="Lehrperson.png" alt="Lehrperson"> 
</body>
</html>

@@ form.html.ep
<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8"><title>Gibbmers</title></head>
<body>
<h1>Umfrage Semester</h1>
<form action="/vote">

<h2>Frage 1</h2>
<p>
Wie stark haben Sie an dem Fach ein <b>persönliches</b> Interesse
(unabhängig von anderen Faktoren, wie Unterlagen oder Lehrperson)?
</p>
<p>
 <input type="radio" name="interest" value="1">wenig
 <input type="radio" name="interest" value="2">mittel
 <input type="radio" name="interest" value="3">viel
</p>

<h2>Frage 2</h2>
<p>
Wie gross ist Ihr Einsatz für das Fach (Aufmerksamkeit im Unterricht und bei Aufgaben, Arbeiten ausserhalb der Schule)?
</p>
<p>
 <input type="radio" name="Teilnehmer" value="1">schlecht
 <input type="radio" name="Teilnehmer" value="2">naja
 <input type="radio" name="Teilnehmer" value="3">gut
 <input type="radio" name="Teilnehmer" value="4">super
</p>

<h2>Frage 3</h2>
<p>
Wie geeignet sind die <b>offiziellen Modulunterlagen</b> auf dem Share für den Unterricht?
Wie finden Sie diese?
</p>
<p>
 <input type="radio" name="Unterlagen" value="1">schlecht
 <input type="radio" name="Unterlagen" value="2">naja
 <input type="radio" name="Unterlagen" value="3">gut
 <input type="radio" name="Unterlagen" value="4">super
</p>

<h2>Frage 4</h2>
<p>
Wie steht es um den Klassengeist?
Unterstützen Sie sich gegenseitig?
Ist der Umgang respektvoll?
Wie ist die <b>Stimmung</b> in der Klasse?
</p>
<p>
 <input type="radio" name="Klasse" value="1">schlecht
 <input type="radio" name="Klasse" value="2">naja
 <input type="radio" name="Klasse" value="3">gut
 <input type="radio" name="Klasse" value="4">super
</p>

<h2>Frage 5</h2>
<p>
Wie beurteilen Sie die <b>Unterstützung</b> im Lernprozess durch die Lehrperson?
</p>
<p>
 <input type="radio" name="Lehrperson" value="1">schlecht
 <input type="radio" name="Lehrperson" value="2">naja
 <input type="radio" name="Lehrperson" value="3">gut
 <input type="radio" name="Lehrperson" value="4">super
</p>
 <br />
 <input type="submit" value="Submit">
</form> 
</body>
</html>
