\ 22-02-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� DO LOOP ��� ��� - ������������ �������.

\ �������� ��� ������������� � ����������� lib\ext\locals.f
\ ���������� ���������� locals � ��������� �������:
\ : DO    POSTPONE DO     [  4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\ : ?DO   POSTPONE ?DO    [  4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\ : LOOP  POSTPONE LOOP   [ -4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\ : +LOOP POSTPONE +LOOP  [ -4 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\ �� ���� �������, ��� �� ����� ��������� ����������� �� ���, ��� ������,
\ � ������ ���������.

\ lib\ext\disasm.f
\ ��� ����������� ���� ���������� ����:
REQUIRE ?: devel\~moleg\lib\util\ifcolon.f

\ ������ �� ��, ��� � ['] name COMPILE,
?: COMPILE ( --> )
           ?COMP
           ' LIT, ['] COMPILE, COMPILE,
          ; IMMEDIATE

\ ---------------------------------------------------------------------------

\ �� ����� ��������� ����� 4-�� ���������.
\ ����� ������ �� �����
\ ������� ������ �����
\ ������� �����
\ ����� ������ �� LOOP �����

\ ������� ������� �������� �����
: I ( --> index )
    \ 2R> R@ -ROT 2>R
    8 RP+@ ;

\ ������� ������� �������� �����.
: J ( --> ext_index ) 24 RP+@ ;

\ ���������� ����� �� �����
: LEAVE ( --> ) RDROP RDROP RDROP RDROP ;

\ ���������� ��������� ����� - ����������� ���� ��� �� �����
: (DO) ( up low --> ) R> -ROT 2>R ['] LEAVE >R >R ;

\ ���������� �������� �����, �������� ������� ������ �� �����.
: (+LOOP) ( n --> flag ) 2R> ROT R> + R@ OVER >R > -ROT 2>R ;

\ ---------------------------------------------------------------------------

\ ������ ���������� �����, ��������������� ������� �����
: DO ( up low --> )
     ?COMP
     HERE 0 RLIT, 1 + \ �������� ������ ������ �� LEAVE
     0
     COMPILE (DO)
     [COMPILE] BEGIN ; IMMEDIATE

\ ������ ���������� ����� � ������������ - ���� up ������ low
\ ���������� ����� ����������
: ?DO ( up low -->  )
      ?COMP
      HERE 0 RLIT, 1 + \ �������� ������ ������ �� LEAVE
      COMPILE 2DUP COMPILE > [COMPILE] IF
      COMPILE (DO)
      [COMPILE] BEGIN ; IMMEDIATE

\ ����� ���������� ��� ���������� �����, �������� ���������� DO ��� ?DO
\ ���������� �������� ����� ������������ ���������� ��������
\ �������� ����� ������
: +LOOP ( n --> )
        ?COMP
        COMPILE (+LOOP)
        [COMPILE] UNTIL
                  COMPILE RDROP COMPILE RDROP COMPILE RDROP COMPILE RDROP

        DUP IF [COMPILE] ELSE COMPILE 2DROP COMPILE RDROP [COMPILE] THEN
             ELSE DROP
            THEN
        HERE SWAP !

        ; IMMEDIATE

\ ����� ���������� ��� ���������� �����, �������� ���������� DO ��� ?DO
\ ���������� �������� ����� = 1
: LOOP ( --> ) ?COMP 1 LIT, [COMPILE] +LOOP ; IMMEDIATE

\ ������ ��������� ����� �������� ������. UNLOOP ��������� ��� �������
\ ������ �������� ������ ����� ������� �� ����������� �� EXIT.
: UNLOOP ( --> ) R> RDROP RDROP RDROP RDROP >R ;

\EOF -- �������� ������ -----------------------------------------------------

DECIMAL CR

: test  CR 10 0 ." a " ?DO I . LOOP ." c " ;         test
: testa CR 0 0  ." a " ?DO I . LOOP ." c " ;         testa
: testb CR 10 0 ." a " ?DO I . EXIT LOOP ." c " ;    testb
: testc CR 10 0 ." a " ?DO I . LEAVE LOOP ." c " ;   testc

: testd CR 10 0 DO 10 0 DO J . I . SPACE LOOP CR LOOP ; testd
: teste CR 10 0 DO 10 0 DO J . I . SPACE LEAVE LOOP CR LOOP ; teste

: testf CR ." a " 10 0 DO ." b " I . I 5 = IF UNLOOP EXIT THEN LOOP ." c " ;
testf
