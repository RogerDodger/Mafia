package Mafia::Controller::Post;
use Moose;
use namespace::autoclean;
require Text::Markdown;
require Text::SmartyPants;
use DR::SunDown;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Mafia::Controller::Post - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Mafia::Controller::Post in Post.');
}

sub preview :Local :Args(0) {
	my ( $self, $c ) = @_;

	local $_ = $c->req->param('text') || '';

	s/</&lt;/g;
	s`>>([0-9]+)`<a class="cite" href="/post/\1">&gt;&gt;\1</a>`g;
	
	$_ = Text::Markdown->new->markdown($_);
	# $_ = markdown2html $_;
	$_ = Text::SmartyPants::process($_, 2);

	$c->res->body($_);
}

=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
