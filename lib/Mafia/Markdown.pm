package Mafia::Markdown;

use base 'Text::Markdown';
use Regexp::Common qw/URI/;
use Digest::MD5 qw/md5_hex/;
use HTML::Entities;
use URI;
use v5.14;

my @uri_schemes = (
	qw/http https ftp mailto git 
	steam irc news mumble ssh ircs/
);

my $salt = rand();
foreach my $char (split //, '\\`*_{}[]()>#+-.!') {
  $Text::Markdown::g_escape_table{$char} = md5_hex($salt.$char);
}
my %g_escape_table = %Text::Markdown::g_escape_table;

sub _md5_utf8 {
	# Internal function used to safely MD5sum chunks of the input, which might be Unicode in Perl's internal representation.
	my $input = shift;
	return unless defined $input;
	if (Encode::is_utf8 $input) {
		return md5_hex($salt.Encode::encode('utf8', $input));
	}
	else {
		return md5_hex($salt.$input);
	}
}

sub _CleanUpRunData {
	my ($self, $options) = @_;
	# Clear the global hashes. If we don't clear these, you get conflicts
	# from other articles when generating a page which contains more than
	# one article (e.g. an index page that shows the N most recent
	# articles).
	$self->{_urls}        = $options->{urls} ? $options->{urls} : {}; # FIXME - document passing this option (tested in 05options.t).
	$self->{_titles}      = {};
	$self->{_html_blocks} = {};
	# Used to track when we're inside an ordered or unordered list
	# (see _ProcessListItems() for details)
	$self->{_list_level} = 0;
	$self->{_cites} = [];
}

sub _CleanUpDoc {
	my ($self, $text) = @_;

	# Standardize line endings:
	$text =~ s{\r\n}{\n}g;  # DOS to Unix
	$text =~ s{\r}{\n}g;    # Mac to Unix

	# Make sure $text ends with a couple of newlines:
	$text .= "\n\n";

	# Convert all tabs to spaces.
	$text = $self->_Detab($text);

	# Strip any lines consisting only of spaces and tabs.
	# This makes subsequent regexen easier to write, because we can
	# match consecutive blank lines with /\n+/ instead of something
	# contorted like /[ \t]*\n+/ .
	$text =~ s/^[ \t]+$//mg;

	# Decode HTML entities, safely allowing users to use HTML entities
	$text = HTML::Entities::decode_entities($text);

	# Encode unsafe HTML characters
	$text =~ s/</&lt;/g;

	return $text;
}

sub _RunSpanGamut {
#
# These are all the transformations that occur *within* block-level
# tags like paragraphs, headers, and list items.
#
	my ($self, $text) = @_;

	$text = $self->_DoCodeSpans($text);
	$text = $self->_EscapeSpecialCharsWithinTagAttributes($text);
	$text = $self->_EscapeSpecialChars($text);

	$text = $self->_DoAnchors($text);

	$text = $self->_DoAutoLinks($text);

	$text = $self->_EncodeAmpsAndAngles($text);

	$text = $self->_DoItalicsAndBold($text);

	$text =~ s/\n/\n<br$self->{empty_element_suffix}\n/g;

	return $text;
}

sub _DoHeaders {
	my ($self, $text) = @_;

	# Setext-style headers:
	#     Header 1
	#     ========
	#
	#     Header 2
	#     --------
	#
	$text =~ s{ ^(.+)[ \t]*\n=+[ \t]*\n+ }{
		$self->_GenerateHeader('1', $1);
	}egmx;

	$text =~ s{ ^(.+)[ \t]*\n-+[ \t]*\n+ }{
		$self->_GenerateHeader('2', $1);
	}egmx;


	# atx-style headers:
	#   # Header 1
	#   ## Header 2
	#   ## Header 2 with closing hashes ##
	#   ...
	#   ###### Header 6
	#
	my $l;
	$text =~ s{
			^(\#{1,6})  # $1 = string of #'s
			[ \t]+
			(.+?)       # $2 = Header text
			[ \t]*
			\#*         # optional closing #'s (not counted)
			\n+
		}{
			my $h_level = length($1);
			$self->_GenerateHeader($h_level, $2);
		}egmx;

	return $text;
}

sub _DoAutoLinks {
	my( $self, $text ) = @_;

	my $tokens = $self->_TokenizeHTML($text);

	$text = '';

	my $ignore_re = qr`<(/?)(?:pre|code|a)[\s>]`;

	my $ignoring = 0;
	for my $token ( @$tokens ) {
		if( $token->[0] eq 'tag' ) {
			if($token->[1] =~ $ignore_re) {
				$ignoring += $1 eq '/' ? -1 : 1;
			}
		}
		elsif( $ignoring <= 0 ) {
			$token->[1] =~ s`($RE{URI})`
				$self->_GenerateAnchor($1, $1, undef, $1)
			`eg;

			$token->[1] =~ s`#([0-9]+)\b`
				push $self->{_cites}, $1;
				qq!<a class="cite" href="/post/$1">#$1</a>!
			`eg;
		}
		$text .= $token->[1];
	}

	return $text;
}

sub _GenerateAnchor {
	my ($self, $whole_match, $link_text, $link_id, $url, $title, $attr) = @_;

	$attr //= '';

	if(!defined $url) {
		if( defined $self->{_urls}{$link_id} ) {
			$url = $self->{_urls}{$link_id};
		}
		else {
			return $whole_match;
		}
	}
	
	$link_text ||= $url;

	$url =~ s! \* !$g_escape_table{'*'}!gox;    # We've got to encode these to avoid
	$url =~ s!  _ !$g_escape_table{'_'}!gox;    # conflicts with other keywords.
	$url =~ s{^<(.*)>$}{$1};                    # Remove <>'s surrounding URL, if present


	$url = URI->new($url);
	return $whole_match unless $url->scheme ~~ @uri_schemes;

	my $result = qq{<a href="$url"};

	if ( !defined $title && defined $link_id && defined $self->{_titles}{$link_id} ) {
		$title = $self->{_titles}{$link_id};
	}

	if ( defined $title ) {
		$title =~ s/"/&quot;/g;
		$title =~ s! \* !$g_escape_table{'*'}!gox;
		$title =~ s!  _ !$g_escape_table{'_'}!gox;
		$result .=  qq{ title="$title"};
	}

	$result .= "$attr>$link_text</a>";

	return $result;
}

1;
