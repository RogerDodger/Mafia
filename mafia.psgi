use strict;
use warnings;

use Mafia;

my $app = Mafia->apply_default_middlewares(Mafia->psgi_app);
$app;

