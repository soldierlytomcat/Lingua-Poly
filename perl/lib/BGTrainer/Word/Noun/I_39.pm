#! /bin/false

package BGTrainer::Word::Noun::I_39;

use strict;

use utf8;

use base qw (BGTrainer::Word::Noun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $stem = $word;
    $stem =~ s/я$//;

    my $plural = $stem . 'и';

    my @stresses2 = @stresses;
    --$stresses2[-1] if @stresses2;

    return (
	    $self->_emphasize ($word, @stresses),
	    $self->_emphasize ($word . 'та', @stresses),
	    $self->_emphasize ($word . 'та', @stresses),
	    $self->_emphasize ($plural, @stresses2),
	    $self->_emphasize ($plural . 'те', @stresses2),
	    undef,
	    undef
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
