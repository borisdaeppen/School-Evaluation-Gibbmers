use Mojolicious::Lite;

get '/' => {text => 'I ♥ Mojolicious!'};

get '/form' => {template => 'form'};
get '/vote' => sub {

    my $self = shift;
    $self->stash( message => "Danke für die Teilnahme!" );
        
} => 'vote';

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
Wie geeignet sind die <b>offiziellen Modulunterlagen</b> auf dem Share für den Unterricht?
Wie finden Sie diese?
</p>
<p>
 <input type="radio" name="sheets" value="1">schlecht
 <input type="radio" name="sheets" value="2">naja
 <input type="radio" name="sheets" value="3">gut
 <input type="radio" name="sheets" value="4">super
</p>

<h2>Frage 3</h2>
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

<h2>Frage 4</h2>
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
