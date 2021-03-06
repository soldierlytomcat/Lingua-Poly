# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.012.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "User management API for Lingua-Poly.",
  "AUTHOR" => "Guido Flohr <guido.flohr\@cantanea.com>",
  "BUILD_REQUIRES" => {
    "Module::Build" => "0.28"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "Module::Build" => "0.28"
  },
  "DISTNAME" => "Lingua-Poly-API-User",
  "LICENSE" => "unrestricted",
  "NAME" => "Lingua::Poly::API::User",
  "PREREQ_PM" => {
    "CGI::Cookie" => 0,
    "DBI" => 0,
    "Data::Password::zxcvbn" => "1.0.4",
    "Digest::SHA" => 0,
    "Email::Address" => "1.912",
    "Email::Sender::Simple" => "1.300031",
    "Email::Sender::Transport::SMTP" => "1.300031",
    "Email::Simple" => "2.216",
    "Encode" => 0,
    "Exporter" => 0,
    "HTTP::Request" => 0,
    "HTTP::Status" => 0,
    "JSON" => 0,
    "LWP::UserAgent" => 0,
    "List::Util" => 0,
    "Locale::Messages" => 0,
    "Locale::TextDomain" => 0,
    "MIME::Base64" => 0,
    "Mojo::Base" => 0,
    "Mojo::Log" => 0,
    "Mojo::URL" => 0,
    "Mojolicious::Plugin::RemoteAddr" => "0.03",
    "Mojolicious::Plugin::Util::RandomString" => "0.08",
    "Moose" => 0,
    "Password::OWASP::Argon2" => 0,
    "Session::Token" => "1.503",
    "Time::HiRes" => 0,
    "URI" => 0,
    "YAML" => 0,
    "YAML::XS" => 0,
    "base" => 0,
    "constant" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0
  },
  "TEST_REQUIRES" => {
    "Mojo::JWT" => 0,
    "Test::More" => 0
  },
  "VERSION" => "1.0",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "CGI::Cookie" => 0,
  "DBI" => 0,
  "Data::Password::zxcvbn" => "1.0.4",
  "Digest::SHA" => 0,
  "Email::Address" => "1.912",
  "Email::Sender::Simple" => "1.300031",
  "Email::Sender::Transport::SMTP" => "1.300031",
  "Email::Simple" => "2.216",
  "Encode" => 0,
  "Exporter" => 0,
  "HTTP::Request" => 0,
  "HTTP::Status" => 0,
  "JSON" => 0,
  "LWP::UserAgent" => 0,
  "List::Util" => 0,
  "Locale::Messages" => 0,
  "Locale::TextDomain" => 0,
  "MIME::Base64" => 0,
  "Module::Build" => "0.28",
  "Mojo::Base" => 0,
  "Mojo::JWT" => 0,
  "Mojo::Log" => 0,
  "Mojo::URL" => 0,
  "Mojolicious::Plugin::RemoteAddr" => "0.03",
  "Mojolicious::Plugin::Util::RandomString" => "0.08",
  "Moose" => 0,
  "Password::OWASP::Argon2" => 0,
  "Session::Token" => "1.503",
  "Test::More" => 0,
  "Time::HiRes" => 0,
  "URI" => 0,
  "YAML" => 0,
  "YAML::XS" => 0,
  "base" => 0,
  "constant" => 0,
  "namespace::autoclean" => 0,
  "strict" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
