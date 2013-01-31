package Mafia::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

require DateTime;

=head1 NAME

Mafia::Controller::Root - Root Controller for Mafia

=head1 METHODS

=head2 index

The root page (/)

=cut

sub auto :Private {
	my ( $self, $c ) = @_;

	$c->stash(
		title => [ $c->config->{name} ],
		now   => DateTime->now,
		v     => $Mafia::VERSION,
	);

	$c->stash(
		player => {
			role => 'Townie',
		}
	);

}

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;

	push $c->stash->{title}, 'Index';
	$c->stash->{template} = 'index.html';
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
	my ( $self, $c ) = @_;

	open HTML, '<', $c->path_to('root', 'src', '404.html');
	$c->res->body(do { local $/; <HTML> });
	close HTML;

	$c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
