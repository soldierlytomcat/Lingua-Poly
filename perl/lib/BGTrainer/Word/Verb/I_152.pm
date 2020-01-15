#! /bin/false

package BGTrainer::Word::Verb::I_152;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_151);

use BGTrainer::Util qw (bg_count_syllables);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $stem = $word;
    $stem =~ s/а$//;

    $self->{_stem} = $stem;

    undef $self->{_aorist_stresses};

    $self->{_imperfect_stem1} = $self->{_imperfect_stem2} = $stem . 'е';

    undef $self->{_perfect_stresses};

    undef $self->{_gerund_stem};

    return $self;
}

sub past_passive_participle {
    my ($self) = @_;

    my @aorist = $self->past_aorist;

    my $stem1 = $aorist[1];
    my $stem2 = $stem1;
    
    my $stem3 = $stem1;

    if (1 == bg_count_syllables $stem2) {
	$stem2 .= 'ю';
	$stem2 = $self->_emphasize ($stem2, 1);
	chop $stem2;
    }

    if (1 == bg_count_syllables $stem3) {
	$stem3 .= 'ю';
	$stem3 = $self->_emphasize ($stem3, 1);
	chop $stem3;
    }

    return ($stem1 . 'т',
	    $stem2 . 'тия',
	    $stem2 . 'тият',
	    $stem2 . 'та',
	    $stem2 . 'тата',
	    $stem2 . 'то',
	    $stem2 . 'тото',
	    $stem3 . 'ти',
	    $stem3 . 'тите');
}

sub present_active_participle {
    return (undef) x 9;
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
