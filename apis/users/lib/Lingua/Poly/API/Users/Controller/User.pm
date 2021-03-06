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

package Lingua::Poly::API::Users::Controller::User;

use strict;

use HTTP::Status qw(:constants);
use URI;
use Data::Password::zxcvbn 1.0.4 qw(password_strength);
use Lingua::Poly::API::Users::Util qw(empty check_password);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

sub login {
	my $self = shift->openapi->valid_input or return;

	my $identity_provider = $self->app->sessionService->identityProvider(
		local => $self
	);

	my $json = $self->req->json;

	my $user = $identity_provider->authenticate($json);
	if (!$user) {
		return $self->errorResponse(HTTP_UNAUTHORIZED, 'invalid username or password');
	}

	my $session = $self->stash->{session};
	$session->user($user);

	$self->app->sessionService->remember($self, $user) if $json->{persistant};
	$self->app->sessionService->privilegeLevelChange($self);
	$self->app->database->commit;

	$self->res->headers('X-Session-TTL', $self->config->{session}->{timeout});
	my %user = $user->toResponse('private');

	# OpenAPI plug-in does not support inheritance?
	return $self->render(json => \%user, status => HTTP_OK);
}

sub logout {
	my $self = shift->openapi->valid_input or return;

	my $app = $self->app;

	my $provider = $self->stash->{session}->provider;
	my $identity_provider = $self->app->sessionService->identityProvider(
		$provider => $self
	);

	$identity_provider->signOut;

	$self->app->sessionService->privilegeLevelChange($self);
	$self->app->database->commit;

	return $self->emptyResponse;
}

sub delete {
	my $self = shift->openapi->valid_input or return;

	my $app = $self->app;

	my $session = $self->stash->{session};
	my $user = $session->user;

	$self->app->userService->delete($user);

	my $provider = $self->stash->{session}->provider;
	my $identity_provider = $self->app->sessionService->identityProvider(
		$provider => $self
	);

	$identity_provider->signOut;

	$self->app->sessionService->privilegeLevelChange($self);

	$self->app->database->commit;

	return $self->emptyResponse;
}

sub profile {
	my $self = shift->openapi->valid_input or return;

	my $user = $self->stash->{session}->user;

	my %user = $user->toResponse('self');

	$self->res->headers('X-Session-TTL', $self->config->{session}->{timeout});

	# OpenAPI plug-in does not support inheritance?
	return $self->render(json => \%user, status => HTTP_OK);
}

sub updateProfile {
	my $self = shift->openapi->valid_input or return;

	my $user = $self->stash->{session}->user;
	my $json = $self->req->json;
	my $db = $self->app->database;

	$user->username($json->{username});
	$user->homepage($json->{homepage});
	$user->description($json->{description});

	eval {
		$self->app->userService->updateUser($user);
	};
	if ($@) {
		$self->error($@);
		$db->rollback;
		return $self->errorResponse(HTTP_BAD_REQUEST, 'invalid user properties');
	}

	$db->commit;

	return $self->emptyResponse;
}

sub get {
	my $self = shift->openapi->valid_input or return;

	my $name = $self->param('name');

	my $user = $self->app->userService->userByUsernameOrEmail($name);
	if (!$user) {
		return $self->errorResponse(HTTP_NOT_FOUND, 'invalid username or password');
	}

	my %user = $user->toResponse;

	# OpenAPI plug-in does not support inheritance?
	return $self->render(json => \%user, status => HTTP_OK);
}

sub changePassword {
	my $self = shift->openapi->valid_input or return;

	my $json = $self->req->json;

	my $user = $self->stash->{session}->user;

	if (!$user->password) {
		return $self->errorResponse(HTTP_FORBIDDEN, 'user does not have a password');
	}

	if (!check_password $json->{oldPassword}, $user->password) {
		return $self->errorResponse(HTTP_FORBIDDEN, 'invalid password');
	}

	my $analysis = password_strength $json->{password};
	my $score = $analysis->{score};
	if ($score < 3) {
		return $self->errorResponse(HTTP_BAD_REQUEST, 'password too weak',
			"password strength: $score/4).");
	}

	$self->app->userService->changePassword($user, $json->{password});
	$self->app->sessionService->privilegeLevelChange($self);

	return $self->emptyResponse;
}

sub changePasswordWithToken {
	my $self = shift->openapi->valid_input or return;

	my $json = $self->req->json;

	if (empty $json->{token}) {
		return $self->errorResponse(HTTP_GONE, 'no token specified');
	}

	my $user = $self->app->userService->userByToken(
		passwordReset => $json->{token}, 1);

	if (!$user) {
		return $self->errorResponse(HTTP_GONE, 'invalid or expired token');
	}

	if (!$user->password) {
		return $self->errorResponse(HTTP_FORBIDDEN, 'user does not have a password');
	}

	my $analysis = password_strength $json->{password};
	my $score = $analysis->{score};
	if ($score < 3) {
		return $self->errorResponse(HTTP_BAD_REQUEST, 'password too weak',
			details => "password strenth: $score/4)."
		);
	}

	$self->app->userService->changePassword($user, $json->{password});
	$self->app->tokenService->delete($json->{token});
	$self->app->sessionService->privilegeLevelChange($self);
	$self->app->database->commit;

	my %user = $user->toResponse('private');
	return $self->render(json => \%user, status => HTTP_OK);
}

sub resetPassword {
	my $self = shift->openapi->valid_input or return;

	my $json = $self->req->json;

	$self->app->userService->resetPassword($self, $json->{id});
	$self->app->database->commit;

	return $self->emptyResponse;
}

1;
