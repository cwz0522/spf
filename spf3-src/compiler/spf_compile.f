( ���������� ����� � ����� � �������.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999, ���� 2000
)

  USER CURRENT     \ ���� wid �������� ������� ����������

  VARIABLE (DP)    \ ����������, ���������� HERE �������� ������
5 CONSTANT CFL     \ ����� ����, �������������� CREATE � ������� CS.
  USER     DOES>A  \ ��������� ���������� - ����� ��� DOES>

: SET-CURRENT ( wid -- ) \ 94 SEARCH
\ ���������� ������ ���������� �� ������, ���������������� wid.
  CURRENT !
;

: GET-CURRENT ( -- wid ) \ 94 SEARCH
\ ���������� wid - ������������� ������ ����������.
  CURRENT @
;

: IS-TEMP-WL ( -- flag )
\ ���������, �������� �� ������� ������� ���������� ��������� (�������)
  GET-CURRENT CELL- @ -1 =
;
: DP ( -- addr ) \ ����������, ���������� HERE �������� ������
  IS-TEMP-WL
  IF GET-CURRENT 6 CELLS + ELSE (DP) THEN
;
: HERE ( -- addr ) \ 94
\ addr - ��������� ������������ ������.
  DP @
;

: ALLOT ( n -- ) \ 94
\ ���� n ������ ����, ��������������� n ���� ������������ ������. ���� n ������ 
\ ���� - ���������� |n| ���� ������������ ������. ���� n ����, �������� 
\ ��������� ������������ ������ ����������.
\ ���� ����� ����������� ALLOT ��������� ������������ ������ �������� � n
\ ������ ������� ������, �� �������� ����������� � ����� ALLOT.
\ ���� ����� ����������� ALLOT ��������� ������������ ������ �������� ��
\ ������� ������� � n ������ ������� �������, �� �������� ����������� ��
\ ������� ������� � ����� ALLOT.
  DP +!
;

: , ( x -- ) \ 94
\ ��������������� ���� ������ � ������� ������ � ��������� x � ��� ������.
  HERE 4 ALLOT !
;

: C, ( char -- ) \ 94
\ ��������������� ����� ��� ������� � ������� ������ � ��������� ���� char.
  HERE 1 ALLOT C!
;

: W, ( word -- )
\ ��������������� ����� ��� word � ������� ������ � ��������� ���� char.
  HERE 2 ALLOT W!
;

HEX

: COMPILE,  \ 94 CORE EXT
\ �������������: ��������� �� ����������.
\ ����������: ( xt -- )
\ �������� ��������� ���������� �����������, �������������� xt, � 
\ ��������� ���������� �������� �����������.
  0E8 C,              \ �������� ������� CALL
  HERE CELL+ - ,
;

: BRANCH, ( ADDR -> ) \ �������������� ���������� ADDR JMP
  0E9 C,
  HERE CELL+ - ,
;

: RET, ( -> ) \ �������������� ���������� RET
  0C3 C,
;

: LIT, ( W -> )
\  081 C, 0ED C, 4 ,    \ SUB EBP, # 4
  083 C, 0ED C, 4 C,   \ ����� ���������� �������, tnx Valentine Zaretsky
  0C7 C, 045 C, 0 C, , \ MOV [EBP], DWORD #
;

: DLIT, ( D -> )
  SWAP LIT, LIT,
;

\ : ?BRANCH, ( ADDR -> ) \ �������������� ���������� ADDR ?BRANCH
\   08B C, 045 C, 0 C, \ MOV EAX, [EBP]
\   083 C, 0C5 C, 4 C, \ ����� ���������� �������, tnx Valentine Zaretsky
\   00B C, 0C0 C,      \ OR  EAX, EAX
\   00F C, 084 C,      \ JZ
\   HERE CELL+ - ,
\ ;

: ?BRANCH, ( ADDR -> ) \ �������������� ���������� ADDR ?BRANCH
\  08B C, 045 C, 0 C, \ MOV EAX, [EBP]
\  081 C, 0C5 C, 4 ,  \ ADD EBP, # 4
  083 C, 0C5 C, 4 C, \ ����� ���������� �������, tnx Valentine Zaretsky
\  00B C, 0C0 C,      \ OR  EAX, EAX
  083 C, 07D C, 0FC C, 0 C, \ CMP [EBP-4], # 0 --- 4 ����� ������ ����.
                            \ tnx Dmitry V. Abramov
  00F C, 084 C,      \ JZ
  HERE CELL+ - ,
;


DECIMAL

: ", ( A -> ) \ ���������� ������ �� ���������, �������� ������� A
  HERE OVER C@ 1+ DUP ALLOT CMOVE
;
: S", ( addr u -- ) \ ���������� ������, �������� addr u, � ���� ������ �� ���������
  DUP C, HERE SWAP DUP ALLOT CMOVE
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
  MOD ?DUP IF - + ELSE DROP THEN
;
: ALIGN ( -- ) \ 94
\ ���� ��������� ������������ ������ �� �������� -
\ ��������� ���.
  HERE ALIGNED HERE - ALLOT
;


