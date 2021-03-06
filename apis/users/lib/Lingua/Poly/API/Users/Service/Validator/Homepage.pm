#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#			   All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::Users::Service::Validator::Homepage;

use strict;

use URI;

sub new {
	my ($class) = @_;

	my $self = '';

	bless \$self, $class;
}

sub check {
	my ($self, $url, %options) = @_;

	my $uri = URI->new($url)->canonical;

	# Remove trailing dot from host name.
	my $host = $uri->host;
	$host =~ s/\.$// if $host;
	$uri->host($host);

	$self->__checkScheme($uri);
	$self->__checkHostname($uri);

	return $uri;
}

sub __checkScheme {
	my ($self, $uri) = @_;

	my $scheme = $uri->scheme;
	die "scheme\n" if !$scheme;

	grep { $scheme eq $_ } ('http', 'https') or die "scheme\n";

	return $self;
}

sub __checkHostname {
	my ($self, $uri) = @_;

	my $host = $uri->host;

	# No empty hostname.
	die "host\n" if '' eq $host;

	# One trailing dot means that there had been two trailing dots.
	die "host\n" if '.' eq substr $host, -1, 1;

	return $self;
}

1;
