\ colorlessForth ��� �����. ���� -- Chuck Moore � Terry Loveall.
\ �� ���� ��� ��� ����������� ������ ������������ �������� � 
\ ������� (��� ���� ������� �������� ����� ��������� �������
\ control-flow ������).

\ ������������� ��� ���������. ���� ������ ���������� � �������,
\ ������ � ����� ���������. ���� ������ ���������� � ���������,
\ �� ����������� � ��������� �������� �� ������� ���������.
\ �� ���� ��������� ������� ������ ��������� ������������, �����
\ �� ������ ������ ������ ����� � �������� ��� ���� ��������� 
\ ������, ������ ����� ������ ������������.

\ ������� ��� ��� ��� ����� ������ "����������" ������ ������,
\ ����� � ������ ���� ������ ����������� ������ ����� �����������
\ � ��� ��������� ���������� (������� ���� �����������) ����� 
\ ����������� ��������-���������� ���.

\ ������, ��� ������ �������� ����� ��� �� ����� ��������... ��� �
\ ���� �����-�� ������ ����������, ������-������ ����� ��������
\ �������� "�� ����� ��������" (�)...

\ ������: ��������, ����� ����������������� ���������� ����� ������
\ ����� �����... ��������, ������ # ������� ������ (���� �� ����������
\ �������������, �� ������-���-������...).

\ �����������. ���� � �� ���������� ������� � �������, ��� ���
\ � ���� �������������� ��� ��� control-flow ������������� ������
\ ���������� ����� ���� ������ ������������

\ TODO: ������� ����������� ��������� ����������� ����� �������
\ TODO: ������� �������� ������������� ����������� ���� SPF � Photon'�
\ TODO: ����� �� ��������� WARNING ?

REQUIRE >L ~profit/lib/lstack.f
REQUIRE NOT ~profit/lib/logic.f
REQUIRE cascaded ~profit/lib/colorForth/cascaded.f
MODULE: photon

40 CONSTANT maxTabs
CREATE tabsArr \ ������ �������� ���������
maxTabs CELLS ALLOT

: clearTabs  tabsArr maxTabs CELLS OVER + SWAP DO
['] NOOP I ! \ ��� ������ ��������, �.�. ������� ��������
CELL +LOOP ;
clearTabs

: flushTabs ( i -- )
CELLS tabsArr +  tabsArr maxTabs CELLS +  ( tabsArr[i] end )
BEGIN
2DUP <= WHILE
DUP @ EXECUTE
['] NOOP OVER !
CELL-
REPEAT
2DROP ;

: setTab ( xt i -- )  CELLS tabsArr + ! ;

: OnTabulation ( -- flag ) GetChar SWAP 9 = AND ;
: OnBlank ( -- flag ) EndOfChunk ;

VARIABLE curTab
curTab 0!

: tabsCount ( -- n ) 0  BEGIN OnTabulation WHILE 1+  1 >IN +! REPEAT ;

: control-flow ( xt-before xt-after -- )
\ ����������: ( -- xt-after )
CREATE IMMEDIATE
SWAP , ,
DOES> [COMPILE] \ 2@ EXECUTE curTab @ setTab ;

EXPORT

:NONAME [COMPILE] DO >L >L  ;
:NONAME L> L> [COMPILE] LOOP ;
control-flow do


:NONAME [COMPILE] IF DROP >L ;
:NONAME L> 1 [COMPILE] THEN ;
control-flow if

:NONAME HERE 5 - C@ 0xE8 = IF 0xE9 HERE 5 - C! \ �������� CALL �� JMP
ELSE RET, \ ��� ������� EXIT
THEN ; 
:NONAME ;
control-flow return

ALSO dontHide \ ����� ���������� ������ :

:NONAME ( -- )
OnBlank        IF EXIT THEN
OnTabulation   IF tabsCount DUP curTab ! flushTabs [COMPILE] ] INTERPRET_ EXIT THEN
OnDelimiter    IF [COMPILE] [ INTERPRET_ EXIT THEN
[COMPILE] :
[COMPILE] \ ;
CONSTANT photonInterpreter

PREVIOUS

;MODULE

ALSO cascaded NEW: photonWords
\ ����� ��������� ����������� ���������� ��������� ���������
\ �� ���������
PREVIOUS

: startPhoton
ALSO photonWords DEFINITIONS \ �������� ��������� �����������
photonInterpreter &INTERPRET ! \ �������� ����������� �������������
;

/TEST
startPhoton
 \ ˸���� ��������� ���� ���� ������������...
 \ ������������ ����... ���� ������������... 
 \ � ������� ����-�����!..
 \ ====================== ����� ���������� ��� =====================

2x2.
	2 2 * . return      �������� �������� ��� ����� ���� control-flow ����� ������ �� ��� ������...

 CR .( 2x2. ) 2x2.


test
	DUP 2 MOD 0= if    ׸���� ����� �������, �������� -- ����������
			DUP .
	DROP
	return

 CR .( 1 test ) 1 test
 CR .( 2 test ) 2 test

1-10. ( -- )                    ���������� ����� �� 1 �� 10-�
	10 0 do			���� �� ������ �� ������
		I 2 MOD 0= if	׸�-�����
				I .
	return

 CR .( 1-10. ) 1-10.

 \ ����������� �������:
fact ( n -- fact(n)
	?DUP 0= if
		1 return
	DUP 1- fact * return

 CR 3 DUP .  .( fact=) fact .

 \ ��������� �� �����. ���� � colorForth'�� ����� 
 \ ����������� � ��������� if'� (���� ��� else),
 \ ��������� ����������� (��� �� -- GOTO) �
 \ ��������� ����������� (��� �� -- �����).
 \ ������ ����� � �������...
fact ( n -- fact(n)
	1 SWAP                \  ������ ����������� �� ���� ���������� �������
fact0 ( acc n )                  ��� ����� ������������� � ��� ������� � ��� �����
	?DUP 0= if               ������� ������ "��������" (�� �� ������� ������ �� �����)
		return
	TUCK * SWAP 1-
	fact0 return             ��� GOTO fact0 , ��-����

 CR 6 DUP .  .( fact=) fact .

array                DOES>-�������� ��� ��������
	R>
	return

Arr ( -- arr )       �������, ��� ��������� � colorForth'�� ��� DOES>
	array  \ <-- ��� � ���� DOES>-��������
 11 , 22 , 33 , 44 , 55 ,

 \ �� ����: ...-CODE-�������� �� ����������� �������

getArr ( i -- arr[i] )
	1- CELLS  Arr +
	return

 CR 4 DUP . .( arr=) getArr @ .