\ REQUIRE { ~nn/lib/locals.f
REQUIRE { lib/ext/locals.f
REQUIRE S>NUM ~nn/lib/s2num.f
REQUIRE S>TEMP ~nn/lib/memory/tempalloc.f
\ : first-char TIB >IN @ + C@ ;

: get-qstring { ch -- a u }
  ch PARSE
  2DUP + C@ ch = 
  IF EXIT THEN \ ���� ������� �� ����� ������
  \ � ��� ������������� �����, ���� �� ����, ��� ��� �������
  \ ��������:
  \ 1. ���� �������� ��������� �����?
  \    ����� HERE+x? (�� ����� ������ � ������ ���������������)
  \    ����� ����� �������������?
;

: get-string ( -- a u)
  BL SKIP 
  GetChar
  IF 
     DUP [CHAR] " =         \ "
     OVER [CHAR] ' = OR
     IF >IN 1+! 
     ELSE DROP BL THEN
  ELSE
     DROP 0
  THEN
  PARSE
\  DUP IF 2DUP + 0 SWAP C! THEN
;

: get-double get-string S>DOUBLE ;
: get-number get-double D>S ;

: get-boolean get-string S" ON" COMPARE 0= ;

: number, get-number POSTPONE LITERAL ;

: get-string0 get-string S>TEMP ;


REQUIRE <EOF> ~nn/lib/eof.f
<EOF>
: t
    get-string TYPE CR
;

t "hello my friends"
t "hello my friends,
my dear dear fiends"
