use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Mafia';
use Mafia::Controller::User;

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
