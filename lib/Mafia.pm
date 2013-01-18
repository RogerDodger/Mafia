package Mafia;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = 'v0.1.1';

require DateTime;

__PACKAGE__->config(
    name => 'Mafia',

    default_view => 'TT',
	'View::TT' => { 
		INCLUDE_PATH => [ __PACKAGE__->path_to('root', 'src' ) ],
	},

    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1,
);

# Start the application
__PACKAGE__->setup();

=head1 NAME

Mafia - Catalyst based application

=head1 SYNOPSIS

    script/mafia_server.pl

=head1 SEE ALSO

L<Mafia::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
