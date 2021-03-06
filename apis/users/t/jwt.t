#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use Test::More;

use Lingua::Poly::API::Users::Util qw(decode_jwt);
use Mojo::JWT;

my $claims_in = {
	sub => 'test',
	aud => 'testers',
	iss => 'Lingua::Poly test',
	name => 'Lingua::Poly',
};

my $claims_out;
my $jwt;

$jwt = Mojo::JWT->new(
	algorithm => 'none',
	claims => $claims_in,
)->encode;
$claims_out = decode_jwt $jwt;
is $claims_out->{sub}, $claims_in->{sub}, 'sub';
is $claims_out->{aud}, $claims_in->{aud}, 'aud';
is $claims_out->{iss}, $claims_in->{iss}, 'iss';
is $claims_out->{name}, $claims_in->{name}, 'name';

$claims_in->{name} = 'not expired';
$jwt = Mojo::JWT->new(
	algorithm => 'none',
	claims => $claims_in,
	expires => 7200 + time,
)->encode;
$claims_out = decode_jwt $jwt;
is $claims_out->{name}, 'not expired', 'not expired';

$claims_in->{name} = 'not expired';
$jwt = Mojo::JWT->new(
	algorithm => 'none',
	claims => $claims_in,
	expires => 7200 + time,
)->encode;
$claims_out = decode_jwt $jwt;
is $claims_out->{name}, 'not expired', 'not expired';

$claims_in->{name} = 'expired';
$jwt = Mojo::JWT->new(
	algorithm => 'none',
	claims => $claims_in,
	expires => -1 + time,
)->encode;
eval { $claims_out = decode_jwt $jwt };
like $@, qr/expired/, 'expired';

$claims_in->{name} = 'not before';
delete $claims_in->{exp};
$jwt = Mojo::JWT->new(
	algorithm => 'none',
	claims => $claims_in,
	not_before => -7200 + time,
)->encode;
$claims_out = decode_jwt $jwt;
is $claims_out->{name}, 'not before', 'not before';

$claims_in->{name} = 'not yet valid';
$jwt = Mojo::JWT->new(
	algorithm => 'none',
	claims => $claims_in,
	not_before => 7200 + time,
)->encode;
eval { $claims_out = decode_jwt $jwt };
like $@, qr/not yet valid/, 'not yet valid';

done_testing;
