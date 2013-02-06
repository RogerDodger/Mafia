package Mafia::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

require Mafia::Helpers;
require Mafia::DateTime;
require Text::Markdown;
use HTML::Tidy;

__PACKAGE__->config(
	TEMPLATE_EXTENSION => '.html',
	DEFAULT_ENCODING   => 'utf-8',
	expose_methods     => [ qw/html_title/ ],
	render_die         => 1,
	WRAPPER            => 'wrapper.html',
	TIMER              => 1,
	FILTERS            => {
		simple_uri => \&Mafia::Helpers::simple_uri,
		dt         => \&dt_filter,
		markdown   => Text::Markdown->new->can('markdown'),
	},
);

$Template::Stash::SCALAR_OPS->{ucfirst} = sub {
	return ucfirst shift;
};

$Template::Stash::SCALAR_OPS->{lcfirst} = sub {
	return lcfirst shift;
};

my $tidy = HTML::Tidy->new({
	new_blocklevel_tags => 'article, aside, details, figcaption, figure, footer, header, hgroup, nav, section, summary',
	new_inline_tags     => 'time',
	preserve_entities   => 1,
	char_encoding       => 'utf8',
	output_html         => 1, 
	tidy_mark           => 0,
	indent              => 1,
	wrap                => 110,
});

sub html_title {
	my( $self, $c ) = @_;

	my $title = $c->stash->{title};

	if(ref $title eq 'ARRAY') {
		return join " &ndash; ", map { Template::Filters::html_filter($_) } reverse @$title;
	}
	else {
		return Template::Filters::html_filter( $title || $c->stash->{name} );
	}
}

after 'process' => sub {
	my( $self, $c ) = @_;

	my $clean = $tidy->clean($c->res->body);
	$c->res->body($clean);

	1;
};

=head1 NAME

Mafia::View::TT - TT View for Mafia

=head1 DESCRIPTION

TT View for Mafia.

=head1 SEE ALSO

L<Mafia>

=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
