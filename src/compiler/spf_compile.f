( ���������� ����� � ����� � �������.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999, ���� 2000
)

HEX

: _COMPILE,  \ 94 CORE EXT
\ �������������: ��������� �� ����������.
\ ����������: ( xt -- )
\ �������� ��������� ���������� �����������, �������������� xt, �
\ ��������� ���������� �������� �����������.
  SetOP
  0E8 C,              \ �������� ������� CALL
  HERE CELL+ - ,
  HERE TO LAST-HERE
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
  C3 C,
;

: LIT, ( W -> )
  ['] DUP  MACRO,
  OPT_INIT
  SetOP 0B8 C,  , OPT  \ MOV EAX, #
  OPT_CLOSE
;

: DLIT, ( D -> )
  89 C, 45 C, FC C,        \ mov -4 [ebp], eax
  C7 C, 45 C, F8 C, SWAP , \ mov -8 [ebp], # low
\  HERE TO :-SET
  SetOP  B8 C, ,                  \ mov eax, # high
  SetOP  8D C, 6D C, F8 C,        \ lea ebp, -8 [ebp]
  HERE TO LAST-HERE
;

: RLIT, ( u -- )
\ �������������� ��������� ���������:
\ �������� �� ���� ��������� ������� u
   68 C, ,  \ push dword #
;

: ?BRANCH, ( ADDR -> ) \ �������������� ���������� ADDR ?BRANCH
  084 TO J_COD
  OPT_INIT SetOP 0xC00B W,    \ OR EAX, EAX
  OPT? 
  IF BEGIN ?BR-OPT-STEP
     UNTIL
  THEN
\  OPT_CLOSE
  EVEN-EBP
  HERE TO :-SET
  HERE TO LAST-HERE
  ['] DROP MACRO,
  0F C, J_COD C,   \  JZ
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
