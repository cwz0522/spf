CREATE L0   \ ������ �����
100 CELLS ALLOT  \ ������ 100 �����
VARIABLE LP    \ ��������� ������� �����

: LEMPTY  L0  LP ! ; \ ���������� ��������� ����� �� ���
: LDEPTH ( -- d ) LP @ L0 -  CELL / ; \ ��������� ������� �����
LEMPTY  

: LUNDROP CELL  LP +! ;
: LDROP CELL NEGATE LP +! ;
: L@ ( -- n ) LP @ CELL- @ ;  \ ����� � L-�����, ������� ����� �� ��������

: L> ( -- n ) \ ����� � L-�����
LDROP L@ ;

: >L ( n -- ) \ �������� �� L-����
LP @  ! LUNDROP ;

\EOF
REQUIRE SEE lib/ext/disasm.f
SEE L@