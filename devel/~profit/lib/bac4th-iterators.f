REQUIRE /TEST ~profit/lib/testing.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE compiledCode ~profit/lib/bac4th-closures.f

: iterateBy1  ( start len step --> i \ i <-- i ) PRO LOCAL step step !
OVER + SWAP ?DO
I CONT DROP
step @ +LOOP ;

: iterateBy2  ( start len step --> i \ i <-- i ) PRO LOCAL step step !
OVER + 1- LOCAL end end !
BEGIN
CONT
step @ +
DUP end @ > UNTIL
DROP ;

\ ���� ��� ����� �������������� ����� compiledCode ����� �������� ����

\ ���������, ������ ������:

: iterateBy3  ( start len step --> i \ i <-- i ) PRO
OVER 0 > 0= IF 2DROP EXIT THEN \ ���� ����� ������� ��� ������, ������ ������ ������ ��� ������..
>R
OVER + 1- ( start end  R: step )
SWAP R> SWAP ( end step start )
" PRO
( start ) LITERAL
BEGIN [ 2SWAP ] ( ����-��-��-���, ��-��-���!.. �� ��� ������ ��� control-flow ���� == ���� ���������� -- ��� ������ !.?. )
CONT
( step ) LITERAL +
DUP ( end ) LITERAL > UNTIL
DROP "
STRcompiledCode ENTER CONT ;

\ �� �� ������ �� ������, �� ����������� *���������* ��� DO LOOP !

\ ������, ��������� ��� ������:
: t  ROT >R 2SWAP R> ;

: iterateBy4  ( start len step --> i \ i <-- i )
OVER 0 > 0= IF 2DROP EXIT THEN \ ���� ����� ������� ��� ������, ������ ������ ������ ��� ������..
>R
OVER + 1- ( start end  R: step )
SWAP R> SWAP ( end step start )
R> SWAP ( end step succ-xt start )

"
( start ) LITERAL
BEGIN [ t ]
( succ-xt ) [ COMPILE, ]
( step ) LITERAL +
DUP ( end ) LITERAL > UNTIL
DROP "
STRcompiledCode ( xt )  >R ;

\ ��� �����... �������...

: iterateBy ( start len step --> i \ i <-- i ) PRO
2DUP 6 LSHIFT ( 2* 2* 2* 2* 2* 2* ) <
\ ������: ���� ���-�� �������� � ����� ����� ������ ���, ������ 64 (����� � �������),
IF iterateBy2 CONT EXIT THEN
\ �� ������� ����������,
   iterateBy4 CONT ;
\ �����, ���� ������ ��� 64, -- �� ���������� ���� � ������� � ��

: iterateByBytes ( addr u <--> caddr ) PRO 1 iterateBy CONT ;
: iterateByWords ( addr u <--> waddr ) PRO 2 iterateBy CONT ;
: iterateByCells ( addr u <--> addr )  PRO CELL iterateBy CONT ;
: iterateByDCells ( addr u <--> qaddr ) PRO 2 CELLS iterateBy CONT ;

: iterateByByteValues ( addr n <--> caddr ) PRO       iterateByBytes DUP C@ CONT DROP ;
: iterateByWordValues ( addr n <--> waddr ) PRO 2*    iterateByWords DUP W@ CONT DROP ;
: iterateByCellValues ( addr n <--> addr )  PRO CELLS iterateByCells DUP @ CONT DROP ;

/TEST
: r S" abc" iterateByByteValues DUP EMIT ." _" ;
r

: s 100 0 DO +{ 1 200000 1 iterateBy DUP }+ . LOOP ;
\ ResetProfiles s .AllStatistic

\  ������� ������ ����� s �� ������ ��������� iterateBy

\  1 (DO LOOP) __________________________________________________ 43,394,789,947
\  2 (STRcompiledCode � CONT) ___________________________________ 56,321,774,280
\  3 (STRcompiledCode � ������ ���������� ������ ���� ������) ___ 50,266,760,943
\  3 c DIS-OPT (sic!) � ~pinka/spf/quick-swl.f __________________ 10,369,798,311
\  _____________________________________________________________________________
\  ����: ����� ���

\ ������ ���� � ������� ������ ����� WINAPI_������� ALLOCATE ������� ������ 
\ STRcompiledCode

\ ��� ���� �� � ALLOCATE, ���� � EVALUATE