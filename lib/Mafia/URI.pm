package Mafia::URI;

use Path::Class;
use File::Glob 'bsd_glob';
use namespace::autoclean;

sub uri_for_glob {
	my $self = shift;

	my $root  = $self->path_to('root');
	my $path  = $root->subdir(@_);
	my @files = 
		sort { $a->stat->mtime <=> $b->stat->mtime } 
		map  { file($_) } 
		bsd_glob($path);

	my $uri = $self->uri_for($files[-1]->relative($root));

	return $uri;
}

1;