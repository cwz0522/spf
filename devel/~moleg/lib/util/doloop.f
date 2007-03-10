\ 22-02-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ 横�� DO LOOP ��� ���

\ lib\ext\disasm.f

\ ������ � ��, �� � ['] name COMPILE,
: COMPILE ( --> )
          ?COMP
          ' LIT, ['] COMPILE, COMPILE,
         ; IMMEDIATE

\ ---------------------------------------------------------------------------

\ ���㫨 ���稪 ⥪�饣� 横��
: I ( --> index )
    \ 2R> R@ -ROT 2>R
    8 RP+@ ;

\ ������ ���稪 ���譥�� 横��.
: J ( --> ext_index ) 24 RP+@ ;

\ ���७�� ��室 �� 横��
: LEAVE ( --> ) RDROP RDROP RDROP RDROP ;

\ ��⠭����� ��ࠬ���� 横�� - �믮������ ���� ࠧ �� �室�
: (DO) ( up low --> ) R> -ROT 2>R ['] LEAVE >R >R ;

\ ���饭�� ���稪� 横��, �஢�ઠ �᫮��� ��室� �� 横��.
: (+LOOP) ( n --> flag ) 2R> ROT R> + R@ OVER >R > -ROT 2>R ;

\ ---------------------------------------------------------------------------

\ ����� �믮������ 横��, ���樠���஢��� ���稪 横��
: DO ( up low --> )
     ?COMP
     HERE 0 RLIT, 1 + \ ����㧪� ���� ��室� �� LEAVE
     0
     COMPILE (DO)
     [COMPILE] BEGIN ; IMMEDIATE

\ ����� �믮������ 横�� � �।�᫮���� - �᫨ up ����� low
\ �믮������ 横�� �⬥�����
: ?DO ( up low -->  )
      ?COMP
      HERE 0 RLIT, 1 + \ ����㧪� ���� ��室� �� LEAVE
      COMPILE 2DUP COMPILE > [COMPILE] IF
      COMPILE (DO)
      [COMPILE] BEGIN ; IMMEDIATE

\ ���� �����襭�� ��� ����७�� 横��, ���⮣� ����⥫�� DO ��� ?DO
\ ���饭�� ���稪� 横�� ��।������ ᮤ�ন�� ���孥��
\ ����� �⥪� ������
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

\ ���� �����襭�� ��� ����७�� 横��, ���⮣� ����⥫�� DO ��� ?DO
\ ���饭�� ���稪� 横�� = 1
: LOOP ( --> ) ?COMP 1 LIT, [COMPILE] +LOOP ; IMMEDIATE

\ ����� ��ࠬ���� 横�� ⥪�饣� �஢��. UNLOOP �ॡ���� ��� �������
\ �஢�� �������� 横��� ��। ��室�� �� ��।������ �� EXIT.
: UNLOOP ( --> ) R> RDROP RDROP RDROP RDROP >R ;

\ EOF -- ��⮢�� ᥪ�� -----------------------------------------------------

DECIMAL CR

: test  CR 10 0 ." a " ?DO I . LOOP ." c " ;         test
: testa CR 0 0  ." a " ?DO I . LOOP ." c " ;         testa
: testb CR 10 0 ." a " ?DO I . EXIT LOOP ." c " ;    testb
: testc CR 10 0 ." a " ?DO I . LEAVE LOOP ." c " ;   testc

: testd CR 10 0 DO 10 0 DO J . I . SPACE LOOP CR LOOP ; testd
: teste CR 10 0 DO 10 0 DO J . I . SPACE LEAVE LOOP CR LOOP ; teste

: testf CR ." a " 10 0 DO ." b " I . I 5 = IF UNLOOP EXIT THEN LOOP ." c " ;
testf
