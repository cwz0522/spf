\ 2012
\ ������������� ������ �� ����� ��������� � �������������� ������������� ��� ������.
\ $Id$

\ ����� RBUF ( u -- addr u ) ���������� ������������� ���� ������.
\ ������ ������������� ��� ������ �� ���� �����, � ������� ������� RBUF
\ ����������� ����������� ������������ ����� ������ ������.
\ ���� ���������� ������������ ������������, �� ���������� ���������� ���������� STACK_OVERFLOW


: (FREE-RBUF) 
  R> RFREE
;
: RBUF ( u -- addr u )
  R>
  OVER CELL+ 1- >CELLS DUP RALLOT SWAP >R  ( u r a )
  ['] (FREE-RBUF) >R
  SWAP >R
  SWAP
;
: RDROP-BUF ( -- ) ( R: i*x -- )
  R> RDROP R> RFREE >R
;

: RCARBON ( addr u -- addr2 u )
  R>
  OVER CHAR+ CELL+ 1- >CELLS DUP RALLOT SWAP >R  ( u r a )
  ['] (FREE-RBUF) >R
  SWAP >R ( addr u a )
  SWAP ( addr a u )
  2DUP 2>R MOVE 2R> 2DUP + 0 SWAP C!
;

: ENSURE-ASCIIZ-R ( addr u -- addr2 u ) ( R: addr -- i*x addr )
\ ���� ������� ������ �� ����� 0 �� ��������� ��������,
\ �� ��������� ����� ������ � ������� ASCIIZ �� ����� ���������
\ ������� ������������� ������������� ��� ������ �� �����,
\ � ������� ������� ENSURE-ASCIIZ-R
  OVER 0= IF EXIT THEN
  2DUP + C@ 0= IF EXIT THEN
  R> -ROT RCARBON ROT >R
;

\EOF

: test
    RP@ .
  12 RBUF ( addr u )
    OVER . DUP . 2DUP + . CR
    RP@ . CR
  2DUP DUMP
  2DUP ERASE
;

  test DUMP
