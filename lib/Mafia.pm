package Mafia;
use Moose;
use namespace::autoclean;
use v5.14;

our $VERSION = 'v0.3.1';

use Catalyst::Runtime 5.80;

use Catalyst;

extends 'Catalyst';

my $config = Mafia::Config->load;

$ENV{TZ} = $config->{timezone} || 'UTC';

__PACKAGE__->config($config);

if( !$ENV{CATALYST_DEBUG} ) {
	require Mafia::Log;

    my $logger = Mafia::Log->new;
    $logger->path(__PACKAGE__->path_to('log'));

    __PACKAGE__->log($logger);
}

__PACKAGE__->setup(qw/
    Static::Simple
	Unicode::Encoding
	
	Session
	Session::Store::FastMmap
	Session::State::Cookie

	Authentication

	+Mafia::URI
/);

=head1 NAME

Mafia - Catalyst based application

=head1 SYNOPSIS

    script/mafia_server.pl

=head1 SEE ALSO

L<Mafia::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

Copyright (c) 2012-2013 Cameron Thornton 

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
