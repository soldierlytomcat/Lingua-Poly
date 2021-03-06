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

package Lingua::Poly::API::Users::Service::Database::Preparer;

use strict;

use DBI;

use Moose;
use namespace::autoclean;

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has database => (is => 'ro');
has statements => (is => 'ro');
has prepared => (is => 'rw', default => sub {{}});

sub get {
	my ($self, $name) = @_;

	my $prepared = $self->prepared;
	my $sql = $self->statements->{$name}
		or $self->fatal("Undefined SQL statement '$name'.");
	if (!exists $prepared->{$name}) {
		$self->debug("preparing SQL statement '$name'");
		$prepared->{$name} = $self->database->dbh->prepare($sql);
	};

	return $sql, $prepared->{$name};
}

__PACKAGE__->meta->make_immutable;

1;

