package Mafia;
use Moose;
use namespace::autoclean;
use v5.14;

our $VERSION = 'v0.2.4';

use Catalyst::Runtime 5.80;

use Catalyst;

extends 'Catalyst';

__PACKAGE__->config(
    %{ Mafia::Config->load },
);

__PACKAGE__->setup(qw/
    -Debug
    Static::Simple

	Session
	Session::Store::FastMmap
	Session::State::Cookie

	Authentication
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
