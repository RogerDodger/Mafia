use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Mafia';
use Mafia::Controller::Post;

ok( request('/post')->is_success, 'Request should succeed' );
done_testing();
