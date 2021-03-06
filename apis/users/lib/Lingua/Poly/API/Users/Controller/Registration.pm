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

package Lingua::Poly::API::Users::Controller::Registration;

use strict;

use HTTP::Status qw(:constants);
use Data::Password::zxcvbn 1.0.4 qw(password_strength);

use Lingua::Poly::API::Users::Util qw(empty crypt_password check_password);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

sub createUser {
	my $self = shift->openapi->valid_input or return;

	my $userDraft = $self->req->json;

	my @errors;

	# Valid email address?
	my $email = $self->app->emailService->parseAddress($userDraft->{email});
	if (!$email) {
		delete $userDraft->{email};
		push @errors, 'Invalid email address specified.';
	} else {
		$userDraft->{email} = $email;
	}

	my $suggest_recover;
	my $renew_request;
	my $existing;
	if (exists $userDraft->{email}) {
		# Email already taken?
		$existing = $self->app->userService->userByUsernameOrEmail(
				$userDraft->{email});
		if ($existing) {
			if ($existing->confirmed) {
				# We must never report to the user the email address is already in
				# our system, as this would leak personal data.  Instead, we send
				# a mail but suggest to recover the password instead.
				$suggest_recover = 1;
			} else {
				# Probably something went wrong with the confirmation.  Simply
				# renew the request.
				$renew_request = 1;
			}
		}
	}

	# Password strong enough?
	my $analysis = password_strength $userDraft->{password};
	my $score = $analysis->{score};
	push @errors, "Password too weak." if $score < 3;

	if (@errors) {
		$self->app->database->rollback;
		my $errors = join "\n", @errors;
		my %options;
		if ($score < 3) {
			$options{details} = __x("Password strength was: {score}/4".
			                        score => $score);
		}
		return $self->errorResponse(HTTP_BAD_REQUEST, $errors, %options);
	}

	if ($suggest_recover) {
		$self->app->userService->resetPassword($self, $userDraft->{email}, 1);
		my %user = (email => $userDraft->{email});
		return $self->render(json => \%user, status => HTTP_CREATED);
	} else {
		my $token;
		my $tokenService = $self->app->tokenService;
		if ($renew_request) {
			($token) = $tokenService->byPurpose(
				registration => $userDraft->{email}, 0);
			if (empty $token) {
				die "no registration token for $userDraft->{email} found";
				$self->app->database->rollback;
			}
			$self->app->userService->changePassword($existing, $userDraft->{password});
			$tokenService->update(registration => $userDraft->{email});
		} else {
			# Create the user.
			$self->app->userService->create(
				$userDraft->{email},
				password => $userDraft->{password},
				confirmed => 0,
			);
			$token = $tokenService->create(registration => $userDraft->{email});
		}

		my $url = $self->siteURL;

		$self->app->userService->sendRegistrationMail(
			to => $userDraft->{email},
			token => $token,
			siteURL => $self->siteURL,
		);
	}

	$self->app->database->commit;

	my %user = (email => $userDraft->{email});

	$self->render(json => \%user, status => HTTP_CREATED);
}

sub confirm {
	my $self = shift->openapi->valid_input or return;

	my $in = $self->req->json;
	if (!exists $in->{token}) {
		return $self->errorResponse(HTTP_BAD_REQUEST, 'no token provided');
	}
	my $token = $in->{token};

	my $user = $self->app->userService->userByToken(registration => $token, 0);
	if (!$user) {
		$self->app->database->rollback;
		return $self->errorResponse(HTTP_GONE, 'token not found');
	}

	my %user = (email => $user->email, username => $user->username);
	foreach my $prop (keys %user) {
		delete $user{$prop} if !defined $user{$prop};
	}

	my $session = $self->stash->{session};
	$session->user($user);

	$self->app->userService->activate($user);
	$self->app->tokenService->delete($token);
	$self->app->sessionService->privilegeLevelChange($self);
	$self->app->database->commit;

	# FIXME! Inheritance does not work?
	$self->render(json => \%user, status => HTTP_OK);
}

1;
