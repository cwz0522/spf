REQUIRE /TEST ~profit/lib/testing.f
REQUIRE LOCAL ~profit/lib/static.f

\ �������� ����� �� �������. a , b -- ��� ��������� �������� 
\ ������������� ��������, ���������� ������� f , ������� 
\ ������������ xt �����. ���������
\ ��� ������� ��������� ���� ���� ����������� �������� �� �����
\ � ����� +1|0|-1 , ���������� -- ����, +1 -- ������, -1 -- 
\ ������.
\ �� ������ ���� � ��������� �������� ��������� ������� f ��� �������
\ f=0, ���� ���� 0 ���� ����� �������� ��������� �� �������.
: binary-search ( a b f -- i 0|-1 ) LOCAL f f ! \ f ( i -- +1|0|-1)
BEGIN 2DUP < WHILE
2DUP + 2/
DUP f @ EXECUTE ( +1|0|-1 ) \ ������|�����|��������
DUP 0= IF DROP NIP NIP TRUE EXIT THEN \ ���� ����������
0< IF NIP 1- ELSE ROT DROP 1+ SWAP THEN \ �����
REPEAT

DUP f @ EXECUTE 0= IF NIP TRUE EXIT THEN \ ���. �������� �� ������� ������
2DROP 0 FALSE ;

/TEST

: SGN ( x -- sgn(x)
DUP 0= IF EXIT THEN
0< IF -1 EXIT THEN 1  ;

CREATE tmp
HERE
$> 0 , 1 , 3 , 5 , 6 , 10 , 20 , 33 , 123 , 231 , 400 ,
HERE SWAP - CELL / VALUE len

0 VALUE n

: 3DUP 2OVER 2OVER 3 ROLL DROP ;

0 len
:NONAME ( i -- f )  CELLS tmp + @ n - NEGATE SGN ;
3DUP 3DUP
$> 10 TO n binary-search . .
$> 400 TO n binary-search . .
$> 8 TO n binary-search . .