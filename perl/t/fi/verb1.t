# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use utf8;
use Test::More;
use Lingua::Poly::FI::Word::Verb::Type1;

my $word;

$word = Lingua::Poly::FI::Word::Verb::Type1->new('asua');
is $word->inflect(1, 1), 'asun';
is $word->inflect(2, 1), 'asut';
is $word->inflect(3, 1), 'asuu';
is $word->inflect(1, 2), 'asumme';
is $word->inflect(2, 2), 'asutte';
is $word->inflect(3, 2), 'asuvat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('nukkua');
is $word->inflect(1, 1), 'nukun';
is $word->inflect(2, 1), 'nukut';
is $word->inflect(3, 1), 'nukkuu';
is $word->inflect(1, 2), 'nukumme';
is $word->inflect(2, 2), 'nukutte';
is $word->inflect(3, 2), 'nukkuvat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('oppia');
is $word->inflect(1, 1), 'opin';
is $word->inflect(2, 1), 'opit';
is $word->inflect(3, 1), 'oppii';
is $word->inflect(1, 2), 'opimme';
is $word->inflect(2, 2), 'opitte';
is $word->inflect(3, 2), 'oppivat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('ottaa');
is $word->inflect(1, 1), 'otan';
is $word->inflect(2, 1), 'otat';
is $word->inflect(3, 1), 'ottaa';
is $word->inflect(1, 2), 'otamme';
is $word->inflect(2, 2), 'otatte';
is $word->inflect(3, 2), 'ottavat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('lukea');
is $word->inflect(1, 1), 'luen';
is $word->inflect(2, 1), 'luet';
is $word->inflect(3, 1), 'lukee';
is $word->inflect(1, 2), 'luemme';
is $word->inflect(2, 2), 'luette';
is $word->inflect(3, 2), 'lukevat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('kylpeä');
is $word->inflect(1, 1), 'kylven';
is $word->inflect(2, 1), 'kylvet';
is $word->inflect(3, 1), 'kylpee';
is $word->inflect(1, 2), 'kylvemme';
is $word->inflect(2, 2), 'kylvette';
is $word->inflect(3, 2), 'kylpevät';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('pitää');
is $word->inflect(1, 1), 'pidän';
is $word->inflect(2, 1), 'pidät';
is $word->inflect(3, 1), 'pitää';
is $word->inflect(1, 2), 'pidämme';
is $word->inflect(2, 2), 'pidätte';
is $word->inflect(3, 2), 'pitävät';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('antaa');
is $word->inflect(1, 1), 'annan';
is $word->inflect(2, 1), 'annat';
is $word->inflect(3, 1), 'antaa';
is $word->inflect(1, 2), 'annamme';
is $word->inflect(2, 2), 'annatte';
is $word->inflect(3, 2), 'antavat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('kertoa');
is $word->inflect(1, 1), 'kerron';
is $word->inflect(2, 1), 'kerrot';
is $word->inflect(3, 1), 'kertoo';
is $word->inflect(1, 2), 'kerromme';
is $word->inflect(2, 2), 'kerrotte';
is $word->inflect(3, 2), 'kertovat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('kulkea');
is $word->inflect(1, 1), 'kuljen';
is $word->inflect(2, 1), 'kuljet';
is $word->inflect(3, 1), 'kulkee';
is $word->inflect(1, 2), 'kuljemme';
is $word->inflect(2, 2), 'kuljette';
is $word->inflect(3, 2), 'kulkevat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('särkeä');
is $word->inflect(1, 1), 'särjen';
is $word->inflect(2, 1), 'särjet';
is $word->inflect(3, 1), 'särkee';
is $word->inflect(1, 2), 'särjemme';
is $word->inflect(2, 2), 'särjette';
is $word->inflect(3, 2), 'särkevät';

done_testing;