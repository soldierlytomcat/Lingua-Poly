#! /bin/false

package BGTrainer::Word::Noun::I_2;

use strict;

use utf8;

use base qw (BGTrainer::Word::Noun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $stem = $word;
    $stem =~ s/я(.)$/е${1}/;

    my $plural = $stem . 'ове';

    return (
	    $self->_emphasize ($word, @stresses),
	    $self->_emphasize ($stem . 'а', -1),
	    $self->_emphasize ($stem . 'ът', -1),
	    $self->_emphasize ($plural, -1),
	    $self->_emphasize ($plural . 'те', -2),
	    $self->_emphasize ($word . 'а', @stresses),
	    undef,
	    );
}

1;

#Local Variables:
#mode: perl
#perl-indent-level: 4
#perl-continued-statement-offset: 4
#perl-continued-brace-offset: 0
#perl-brace-offset: -4
#perl-brace-imaginary-offset: 0
#perl-label-offset: -4
#cperl-indent-level: 4
#cperl-continued-statement-offset: 2
#tab-width: 8
#coding: utf-8
#End:
