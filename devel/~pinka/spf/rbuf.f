\ 2012

\ ������������� ������ �� ����� ��������� � �������������� ������������� ��� ������.
\ ����� RBUF ( u -- addr u ) ���������� ������������� ���� ������.
\ ������ ������������� ��� ������ �� ���� �����, � ������� ������� RBUF
\ ����������� ����������� ������������ ����� �������.
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
