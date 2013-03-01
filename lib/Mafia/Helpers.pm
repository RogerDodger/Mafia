package Mafia::Helpers;
use utf8;
use base 'Exporter';

our @EXPORT_OK = qw/simple_uri/;

sub simple_uri {
	local $_ = join "-", @_;

	s/[\\\/—–]/ /g; #Turn punctuation that commonly divide words into spaces

	s/[^a-zA-Z0-9\-\x20]//g; # Remove all except English letters, 
	                         # Arabic numerals, hyphens, and spaces.
	s/^\s+|\s+$//g; #Trim
	s/[\s\-]+/-/g; #Collate spaces and hyphens into a single hyphen

	return $_;
}

1;

__END__

=pod

=head1 NAME

Mafia::Helpers - miscellenous subs used in L<Mafia>

=head1 METHODS

=head2 simple_uri

Performs one-way substitutions on arguments to return a URI-safe string for
human-readable (but lossy) URIs.

=head1 AUTHOR

Cameron Thornton E<lt>cthor@cpan.orgE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut