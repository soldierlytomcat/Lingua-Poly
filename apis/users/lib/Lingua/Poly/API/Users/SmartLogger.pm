#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::Users::SmartLogger;

use strict;

use base qw(Mojo::Log);

use Lingua::Poly::API::Users::Util qw(empty);

sub new {
	my ($class, %args) = @_;

	return $class if ref $class;

	# FIXME! Set log level!
	my $self = Mojo::Log->new->context("[$args{realm}]");

	bless $self, $class;
}

sub debug {
	my ($self, @lines) = @_;

	my $level = $self->level;

	return $self if $level ne 'debug';

	# FIXME! The default should be derived from the debugging level but not
	# hard-coded.
	my $debug = $ENV{LINGUA_POLY_USERS_DEBUG};
	return $self if empty $debug;

	my %debug = map { lc $_ => 1 } split /[ \t:,\|]/, $debug;

	if (!($debug{all})) {
		my $realm = $self->context;
		$realm =~ s/.(.*).$/$1/;
		return $self if !$debug{$realm};
	}

	# Performance tweak. We allow logging multiple at once, so that we can
	# exit early if the debugging level is not sufficient.
	foreach my $line (@lines) {
		$self->SUPER::debug($line);
	}

	return $self;
}

1;
