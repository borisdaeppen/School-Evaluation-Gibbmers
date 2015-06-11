use Mojolicious::Lite;
use Mojo::Cache;

my $cache = Mojo::Cache->new(max_keys => 30);

                      # interest   # topic      # bad # soso # good # super
$cache->set(poll =>
                    {   1 =>       { kid     => [ 0,    0,     0,     0 ],
                                     sheets  => [ 0,    0,     0,     0 ],
                                     class   => [ 0,    0,     0,     0 ],
                                     teacher => [ 0,    0,     0,     0 ],
                                   },
                        2 =>       { kid     => [ 0,    0,     0,     0 ],
                                     sheets  => [ 0,    0,     0,     0 ],
                                     class   => [ 0,    0,     0,     0 ],
                                     teacher => [ 0,    0,     0,     0 ],
                                   },
                        3 =>       { kid     => [ 0,    0,     0,     0 ],
                                     sheets  => [ 0,    0,     0,     0 ],
                                     class   => [ 0,    0,     0,     0 ],
                                     teacher => [ 0,    0,     0,     0 ],
                                   },
                    });

get '/' => {text => 'I ♥ Mojolicious!'};

get '/form' => {template => 'form'};
get '/vote' => sub {

    my $self = shift;

    my $client_ip = $self->tx->remote_address;

    if ($cache->get($client_ip)) {
        $self->stash( message => "Sie haben bereits teilgenommen!" );
        $self->render;
        # EXIT and render
    }

    $cache->set($client_ip => 1);

    my $interest = $self->param('interest');
    my $kid      = $self->param('kid');
    my $sheets   = $self->param('sheets');
    my $class    = $self->param('class');
    my $teacher  = $self->param('teacher');

    my $poll = $cache->get('poll');

    $poll->{$interest}->{kid}[$kid]++;
    $poll->{$interest}->{sheets}[$sheets]++;
    $poll->{$interest}->{class}[$class]++;
    $poll->{$interest}->{teacher}[$teacher]++;

#    use Data::Dumper;
#    print Dumper($poll);

    $cache->set('poll' => $poll);

    $self->stash( message => "Danke für die Teilnahme!" );
        
} => 'vote'; # template call

app->start;

__DATA__

@@ vote.html.ep
<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8"><title>Gibbmers</title></head>
<body>
<%= $message %>
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
 <input type="radio" name="kid" value="1">schlecht
 <input type="radio" name="kid" value="2">naja
 <input type="radio" name="kid" value="3">gut
 <input type="radio" name="kid" value="4">super
</p>

<h2>Frage 3</h2>
<p>
Wie geeignet sind die <b>offiziellen Modulunterlagen</b> auf dem Share für den Unterricht?
Wie finden Sie diese?
</p>
<p>
 <input type="radio" name="sheets" value="1">schlecht
 <input type="radio" name="sheets" value="2">naja
 <input type="radio" name="sheets" value="3">gut
 <input type="radio" name="sheets" value="4">super
</p>

<h2>Frage 4</h2>
<p>
Wie steht es um den Klassengeist?
Unterstützen Sie sich gegenseitig?
Ist der Umgang respektvoll?
Wie ist die <b>Stimmung</b> in der Klasse?
</p>
<p>
 <input type="radio" name="class" value="1">schlecht
 <input type="radio" name="class" value="2">naja
 <input type="radio" name="class" value="3">gut
 <input type="radio" name="class" value="4">super
</p>

<h2>Frage 5</h2>
<p>
Wie beurteilen Sie die <b>Unterstützung</b> im Lernprozess durch die Lehrperson?
</p>
<p>
 <input type="radio" name="teacher" value="1">schlecht
 <input type="radio" name="teacher" value="2">naja
 <input type="radio" name="teacher" value="3">gut
 <input type="radio" name="teacher" value="4">super
</p>
 <br />
 <input type="submit" value="Submit">
</form> 
</body>
</html>
