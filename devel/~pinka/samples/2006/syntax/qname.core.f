\ 10.Feb.2006 Fri 20:05

REQUIRE /CHAR ~pinka\samples\2005\ext\size.f 
REQUIRE T-SLIT ~pinka\samples\2006\core\trans\common.f 

: TAIL ( a u -- a1 u1 )
  SWAP /CHAR + SWAP /CHAR -
;

: I-QName ( a-text u-text -- a1 u1 true | a u false )
\ �������� ���������������� text ��� ������������� �������� ����� ��� "`name"
\ ���� ��� (��� ������) ��� ������.
  DUP /CHAR U> 0= IF FALSE EXIT THEN
  OVER C@  [CHAR] ` = IF TAIL TRUE EXIT THEN
  FALSE
;
: AsQName ( a-text u-text -- i*x true | a u false )  \ T-QName
\ �������� ������������� ��� ������������� ���(������), ������������� �������� �����
  I-QName IF T-SLIT TRUE EXIT THEN
  FALSE
;
