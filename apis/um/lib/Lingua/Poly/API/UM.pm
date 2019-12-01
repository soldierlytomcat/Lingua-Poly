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

package Lingua::Poly::API::UM;

use strict;

use Mojo::Base ('Mojolicious', 'Lingua::Poly::API::UM::Logging');

use Time::HiRes qw(gettimeofday);
use YAML;
use HTTP::Status qw(:constants);
use Locale::TextDomain qw(Lingua-Poly-API-UM);
use Locale::Messages qw(turn_utf_8_off);
use CGI::Cookie;

# FIXME! RandomString no longer needed?
use Mojolicious::Plugin::Util::RandomString 0.08;
use Mojolicious::Plugin::RemoteAddr 0.03;

use Lingua::Poly::API::UM::Util qw(empty format_headers);

use Moose;

has configuration => (is => 'ro');
has database => (is => 'ro');
has logger => (is => 'rw');
has userService => (is => 'ro');
has sessionService => (is => 'ro');
has requestContextService => (is => 'ro');
has tokenService => (isa => 'Lingua::Poly::API::UM::Service::Token',
                     is => 'ro');

sub startup {
	my ($self) = @_;

	$self->moniker('lingua-poly-service-um');

	$self->plugin('Util::RandomString');
	$self->plugin('RemoteAddr');

	$self->config($self->configuration);

	$self->plugin(OpenAPI => {
		spec => $self->static->file('openapi.yaml')->path,
		schema => 'v3',
		security => {
			cookieAuth => sub {
				my ($c, $definition, $scopes, $cb) = @_;

				my $session = $c->stash->{session};
				return $c->$cb('You are not logged in.') if !$session->user;

				return $c->$cb;
			}
		}
	});

	my $config = $self->config;
	$self->hook(before_dispatch => sub { $self->__beforeDispatch(@_) });
	$self->hook(after_dispatch => sub { $self->__afterDispatch(@_) });
}

sub __beforeDispatch {
	my ($self, $ctx) = @_;

	$self->debug(format_headers '<<<', $ctx->req->headers);

	$self->sessionService->maintain;

	my $fingerprint = $self->requestContextService->fingerprint($ctx);
	my $session_id = $self->requestContextService->sessionID($ctx);
	$ctx->stash->{session}
		= $self->sessionService->refreshOrCreate($session_id, $fingerprint);
}

sub __afterDispatch {
	my ($self, $ctx) = @_;

	my $session = $ctx->stash->{session};
	$self->requestContextService->sessionCookie($ctx, $session)
		if $session;

	# This must come last in the after_dispatch hook.
	$self->debug(format_headers '>>>', $ctx->res->headers);
}

1;