package CS::Model::Scoreboard;
use Mojo::Base 'MojoX::Model';

use List::Util 'first';

sub generate {
  my $self = shift;
  my $db   = $self->app->pg->db;

  my $scoreboard = $db->query(
    'select * from scoreboard as s join teams as t on s.team_id = t.id
      where round = (select max(round) from scoreboard) order by n'
  )->expand->hashes;
  my $round = $db->query('select max(n) from rounds')->array->[0];

  return ({scoreboard => $scoreboard->to_array, round => $round});
}

1;
