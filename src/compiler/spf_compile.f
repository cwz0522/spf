( ���������� ����� � ����� � �������.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999, ���� 2000
)

HEX

: HERE ( -- addr ) \ 94
\ addr - ��������� ������������ ������.
  DP @ DUP TO :-SET
;

: _COMPILE,  \ 94 CORE EXT
\ �������������: ��������� �� ����������.
\ ����������: ( xt -- )
\ �������� ��������� ���������� �����������, �������������� xt, �
\ ��������� ���������� �������� �����������.
  SetOP
  0E8 C,              \ �������� ������� CALL
  DP @ CELL+ - ,
  DP @ TO LAST-HERE
;

: COMPILE,  \ 94 CORE EXT
\ �������������: ��������� �� ����������.
\ ����������: ( xt -- )
\ �������� ��������� ���������� �����������, �������������� xt, �
\ ��������� ���������� �������� �����������.
    CON>LIT 
    IF  MACRO?
      IF     MACRO,
      ELSE   _COMPILE,
      THEN
    THEN
;

: BRANCH, ( ADDR -> ) \ �������������� ���������� ADDR JMP
  E9 C,
  HERE CELL+ - ,
;

: RET, ( -> ) \ �������������� ���������� RET
  ?SET SetOP 0xC3 C, OPT OPT_CLOSE 
;

: LIT, ( W -> )
  ['] DUP  MACRO,
  OPT_INIT
  SetOP 0B8 C,  , OPT  \ MOV EAX, #
  OPT_CLOSE
;

: DLIT, ( D -> )
  SWAP LIT, LIT,
;

: RLIT, ( u -- )
\ �������������� ��������� ���������:
\ �������� �� ���� ��������� ������� u
   68 C, ,  \ push dword #
;

: ?BRANCH, ( ADDR -> ) \ �������������� ���������� ADDR ?BRANCH
  084 TO J_COD
  OPT_INIT SetOP 0xC00B W,    \ OR EAX, EAX
  OPT? IF ?BR-OPT THEN
  J_COD          \  JX ��� 0x0F
  0x0FFC458B     \  MOV     EAX , FC [EBP] � ����� �� JX
  ['] NIP MACRO, ,  C,
  HERE CELL+ - ,
;

DECIMAL

: ", ( A -> ) \ ���������� ������ �� ���������, �������� ������� A
  HERE OVER C@ 1+ DUP ALLOT QCMOVE
;

: S", ( addr u -- ) \ ���������� ������, �������� addr u, � ���� ������ �� ���������
  DUP C, HERE SWAP DUP ALLOT QCMOVE
;

\ orig - a, 1 (short) ��� a, 2 (near)
\ dest - a, 3

: >MARK ( -> A )
  HERE 4 -
;

: >RESOLVE1 ( A -> )
  HERE OVER - 4 -
  SWAP !
;

: <MARK ( -> A )
  HERE
;

: >RESOLVE ( A, N -- )
  DUP 1 = IF   DROP >RESOLVE1
          ELSE 2 <> IF -2007 THROW THEN \ ABORT" Conditionals not paired"
               >RESOLVE1
          THEN
;

\ ����� ��� ������������ (ALOGN*) � SPF �� ������������.
\ ��������� ��� ������������ ��������� ANS 94.

USER ALIGN-BYTES

: ALIGNED ( addr -- a-addr ) \ 94
\ a-addr - ������ ����������� �����, ������� ��� ������ addr.
  ALIGN-BYTES @ 2DUP
  MOD DUP IF - + ELSE 2DROP THEN
;
: ALIGN ( -- ) \ 94
\ ���� ��������� ������������ ������ �� �������� -
\ ��������� ���.
  HERE ALIGNED HERE - ALLOT
;

: ALIGN-NOP ( n -- )
\ ��������� HERE �� n � ��������� NOP
  HERE DUP ROT 2DUP
  MOD DUP IF - + ELSE 2DROP THEN
  OVER - DUP ALLOT 0x90 FILL
;
