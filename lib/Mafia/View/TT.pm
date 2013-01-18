package Mafia::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

require Mafia::Helpers;
require DateTime;
require DateTime::Format::Human::Duration;

__PACKAGE__->config(
	TEMPLATE_EXTENSION => '.html',
	DEFAULT_ENCODING   => 'utf-8',
	WRAPPER            => 'wrapper.html',
	expose_methods     => [ qw/html_title simple_uri format_dt/ ],
	render_die         => 1,
	TIMER              => 1,
);

sub simple_uri {
	shift @_ for 0, 1;

	return Mafia::Helpers::simple_uri(@_);
}

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

my $RFC2822 = '%a, %d %b %Y %T %Z';

sub format_dt {
	my( $self, $c, $dt, $fmt ) = @_;

	return '' unless ref $dt eq 'DateTime';

	return sprintf '<time title="%s" datetime="%sZ">%s</time>',
		$dt->set_time_zone('UTC')->strftime($RFC2822), 
		$dt->iso8601, 
		DateTime::Format::Human::Duration->new->format_duration_between(
			DateTime->now,
			$dt,
			past => '%s ago',
			future => 'in %s',
			no_time => 'just now',
			significant_units => 2,
		);
}

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
