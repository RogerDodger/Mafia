package Mafia::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mafia::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 login

=head2 logout

=cut

sub login :Local :Args(0) {
    my ( $self, $c ) = @_;

    my $username = $c->req->param('username') || 'user';
    my $password = $c->req->param('password') || 'user';

    $c->authenticate({ name => $username, password => $password });

	$c->res->redirect( $c->req->referer || $c->uri_for('/') );
}

sub logout :Local :Args(0) {
	my ( $self, $c ) = @_;

	$c->logout;

	$c->res->redirect( $c->req->referer || $c->uri_for('/') );
}


=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
