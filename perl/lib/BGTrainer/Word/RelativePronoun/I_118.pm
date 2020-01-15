#! /bin/false

package BGTrainer::Word::RelativePronoun::I_118;

use strict;

use utf8;

use base qw (BGTrainer::Word::RelativePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('който', @stresses),
	    $self->_emphasize ('когото', -2),
	    $self->_emphasize ('комуто', -2),
	    $self->_emphasize ('когото', -2),
	    $self->_emphasize ('която', -2),
	    $self->_emphasize ('което', -2),
	    $self->_emphasize ('които', -2),
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
