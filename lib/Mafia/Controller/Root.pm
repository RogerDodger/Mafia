package Mafia::Controller::Root;
use Moose;
use namespace::autoclean;
no warnings 'uninitialized';

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

	my $so = $c->req->uri->host eq eval { URI->new( $c->req->referer )->host };

	$c->log->info( sprintf "[%s] %s (%s) - %s" . ( $so ? "" : " - %s" ), 
		$c->req->method, 
		$c->req->address,
		( $c->user ? $c->user->get('name') : 'guest' ),
		$c->req->uri->path,
		$c->req->referer || 'no referer',
	) unless $so && $c->stash->{no_req_log};

	if($c->req->method eq 'POST') {
		$c->req->{parameters} = {} if $c->config->{read_only};
		$c->detach('index') if !$so;
	}

	$c->stash(
		player => {
			role => 'Townie',
			team => 'Town',
		}
	);

	require Text::Lorem::More;
	my $lorem = Text::Lorem::More->new;
	$c->stash(
		posts => { all => [
			{
				id => 2,
				user => {
					name => 'Nolegs',
				},
				show_username => 1,
				class => 'day',
				gamedate => 1,
				plain => $lorem->paragraphs(2),
				created => DateTime->now->subtract(hours => 2, minutes => 4, seconds => 57),
			}, 
			{
				id => 3,
				class => 'day system',
				gamedate => 1,
				plain => $lorem->sentence,
				created => DateTime->now->subtract(hours => 1, minutes => 3, seconds => 32),
			},
			{
				id => 4,
				user => {
					name => 'Geoff',
				},
				player => {
					alias => 'Geoffery',
				},
				class => 'day',
				gamedate => 1,
				plain => $lorem->paragraphs(3),
				created => DateTime->now->subtract(hours => 1, minutes => 14, seconds => 2),
			},
			{
				id => 7,
				user => {
					name => 'Nolegs',
				},
				show_username => 1,
				class => 'day',
				gamedate => 1,
				plain => $lorem->paragraph,
				created => DateTime->now->subtract(hours => 1, minutes => 12, seconds => 11),
			},
			{
				id => 9,
				class => 'day system',
				gamedate => 1,
				plain => $lorem->sentence,
				created => DateTime->now->subtract(hours => 1, minutes => 3, seconds => 32),
			},
			{
				id => 11,
				user => {
					name => 'Sadida',
				},
				player => {
					alias => 'Alfred',
				},
				show_username => 1,
				class => 'day',
				gamedate => 1,
				plain => $lorem->paragraphs(3),
				created => DateTime->now->subtract(minutes => 27, seconds => 43),
			},
			{
				id => 12,	
				class => 'day system',
				gamedate => 1,
				plain => $lorem->sentence,
				created => DateTime->now->subtract(minutes => 27, seconds => 42),
			},
			{
				id => 15,
				user => {
					name => 'Sadida',
				},
				player => {
					alias => 'Alfred',
				},
				show_username => 1,
				class => 'night',
				gamedate => 1,
				plain => $lorem->paragraphs(4),
				created => DateTime->now->subtract(minutes => 24, seconds => 7),
			},
			{
				id => 18,
				user => {
					name => 'Sadida',
				},
				player => {
					alias => 'Alfred',
				},
				show_username => 1,
				class => 'night',
				gamedate => 1,
				plain => $lorem->paragraphs(2),
				created => DateTime->now->subtract(minutes => 14),
			},
		]}
	);

	$c->stash->{no_sidebar} = $c->req->param('no_sidebar');

	1;
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
