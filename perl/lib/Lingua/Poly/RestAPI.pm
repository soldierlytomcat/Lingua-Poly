#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::RestAPI;

use strict;

use Mojo::Base ('Mojolicious', 'Lingua::Poly::RestAPI::Logger');

sub realm { 'core' }

use Time::HiRes qw(gettimeofday);
use YAML;
use Plack::Request;
use Plack::Response;
use HTTP::Status qw(:constants);
use Locale::TextDomain qw(Lingua-Poly);
use Locale::Messages qw(turn_utf_8_off);
use CGI::Cookie;

use Lingua::Poly::Util::String qw(empty);
use Lingua::Poly::API::Session;
use Lingua::Poly::API::Error;

use Lingua::Poly::RestAPI::Logger;
use Lingua::Poly::RestAPI::DB;

sub startup {
	my ($self) = @_;

	$self->moniker('lingua-poly-api');

	eval {
		my $config = $self->plugin('YamlConfig');
	};
	if ($@) {
		$self->config({});
	}

	my $config = $self->config;
	$config->{database} //= {};
	$config->{database}->{dbname} //= 'linguapoly';
	$config->{database}->{username} //= '';

	$config->{session} //= {};
	$config->{session}->{timeout} ||= 2 * 60 * 60;

	my $db = Lingua::Poly::RestAPI::DB->new($self->app);
	$self->app->defaults(db => $db);

	$db->transaction(DELETE_SESSION_STALE => $config->{session}->{timeout});

	$self->plugin(OpenAPI => {
			spec => $self->static->file('openapi.yaml')->path,
			schema => 'v3',
	});
}

sub __session {
    my ($self, $session_id) = @_;

    if ($#_ > 0) {
        my $config = $self->config;

        my $path = $config->{prefix};
        $path = '/' if empty $path;

        $self->{__session} = Lingua::Poly::API::Session->new(
            session_id => $session_id);
        $session_id = $self->{__session}->id;
        $self->response->{cookies}->{tsid} = {
            path => $path,
            'max-age' => $config->{session}->{timeout},
            secure => $config->{session}->{ssl},
            httponly => 1,
            value => $session_id,
        };
    }

    return $self->{__session};
}

sub __initialize {
    my ($self) = @_;

    my $debug = $ENV{LINGUA_POLY_DEBUG} // '';
    my %debug = map { lc $_ => 1 } split /[ \t:,\|]/, $debug;
    $self->{__debug} = \%debug;

    $self->{__base_dir} = Cwd::abs_path(Cwd::getcwd);

    $self->{__config} = $self->__readConfig;

    $self->{__db} = Lingua::Poly::API::DB->new($self->{__config}->{database});

    # Throw away old sessions.
    $self->{__db}->transaction(DELETE_SESSION_STALE
                               => 24 * 6 * $self->config->{session}->{timeout});

    $self->{__initialized} = 1;

    return $self;
}

1;
