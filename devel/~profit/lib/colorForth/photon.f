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

\ TODO: Cascading definitions (������������ ��������� SHEADER �
\ ��������� SFIND ������������� ����� ��� ��������)
\ BUG: ������ return �������������?.. � _������_ �����������?..

REQUIRE >L ~profit/lib/lstack.f

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
2DUP > 0= WHILE
DUP @ EXECUTE
['] NOOP OVER !
CELL-
REPEAT
2DROP ;

: setTab ( xt i -- )  CELLS tabsArr + ! ;

: OnTabulation ( -- flag ) GetChar SWAP 9 = AND ;

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

:NONAME RET, ;
:NONAME ;
control-flow return

:NONAME ( -- )
OnTabulation   IF tabsCount DUP curTab ! flushTabs [COMPILE] ] INTERPRET_ EXIT THEN
OnDelimiter    IF [COMPILE] [ INTERPRET_ EXIT THEN
CREATE [COMPILE] \ DOES> EXECUTE ;
CONSTANT photonInterpreter

;MODULE

photonInterpreter &INTERPRET !

 \ ˸���� ��������� ���� ���� ������������...
 \ ������������ ����... ���� ������������... 
 \ � ������� ����-�����!..

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

 \EOF

array                DOES>-�������� ��� ��������
	R>
	return

Arr ( -- arr )       �������, ��� ��������� � colorForth'�� ��� DOES>
	array  \ <-- ��� � ���� DOES>-��������
 11 , 22 , 33 , 44 , 55 ,

getArr ( i -- arr[i] )
	1- CELLS  Arr 1 +
	return

 1 getArr .
 SEE array
 SEE Arr