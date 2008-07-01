\ $Id$

REQUIRE [UNDEFINED] lib/include/tools.f

[UNDEFINED] B@ [IF]

: B@ C@ ;
: B! C! ;
: B, C, ;

\ ������ ����, 'B' - byte ������������ �� �������� � 'B' - bit.
\ ����� ��� �����: BIT@ BIT! (?)

\ �����, ��� �������� �������� ���� ����������� '8': 8@ 8!
\ ��, �� �����, ���� ������� ����.

[THEN]


REQUIRE NDROP   ~pinka/lib/ext/common.f

[UNDEFINED] /CELL [IF]
1 CELLS CONSTANT /CELL [THEN]

[UNDEFINED] /CHAR [IF]
1 CHARS CONSTANT /CHAR [THEN]


REQUIRE EQUAL   ~pinka/spf/string-equal.f


[UNDEFINED] CELL-! [IF]
: CELL-! ( a -- ) -1 CELLS SWAP +! ; [THEN]

[UNDEFINED] CELL+! [IF]
: CELL+! ( a -- ) 1 CELLS SWAP +! ; [THEN]

[UNDEFINED] 1+! [IF]
: 1+! ( a -- )  1 SWAP +! ; [THEN]

[UNDEFINED] 1-! [IF]
: 1-! ( a -- ) -1 SWAP +! ; [THEN]


[UNDEFINED] ALLOCATED [IF]
: ALLOCATED ( u -- a u ) DUP ALLOCATE THROW SWAP ;
: FREE-FORCE ( a|0 -- ) DUP IF FREE THROW EXIT THEN DROP ;
[THEN]

[UNDEFINED] ALSO! [IF]
: ALSO! ( wid -- ) ALSO CONTEXT ! ; [THEN]


[UNDEFINED] lexicon.basics-aligned [IF]
TRUE CONSTANT lexicon.basics-aligned [THEN]
