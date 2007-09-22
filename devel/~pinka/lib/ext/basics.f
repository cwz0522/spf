REQUIRE [UNDEFINED] lib/include/tools.f

: B@ C@ ;
: B! C! ;
: B, C, ;

\ ������ ����, 'B' - byte ������������ �� �������� � 'B' - bit.
\ ����� ��� �����: BIT@ BIT! (?)

\ �����, ��� �������� �������� ���� ����������� '8': 8@ 8!
\ ��, �� �����, ���� ������� ����.

REQUIRE NDROP  ~pinka/lib/ext/common.f

[UNDEFINED] EQUAL [IF]
: EQUAL ( addr1 u1 addr2 u2 -- flag )
  DUP 3 PICK <> IF 2DROP 2DROP FALSE EXIT THEN
  COMPARE 0=
;
[THEN]

[UNDEFINED] CELL-! [IF]
: CELL-! ( a -- ) -1 CELLS SWAP +! ; [THEN]

[UNDEFINED] CELL+! [IF]
: CELL+! ( a -- ) 1 CELLS SWAP +! ; [THEN]

[UNDEFINED] ALLOCATED [IF]
: ALLOCATED ( u -- a u ) DUP ALLOCATE THROW SWAP ; [THEN]

[UNDEFINED] ALSO! [IF]
: ALSO! ( wid -- ) ALSO CONTEXT ! ; [THEN]

[UNDEFINED] lexicon.basics-aligned [IF]
TRUE CONSTANT lexicon.basics-aligned [THEN]
