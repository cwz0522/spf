\ ��������� ��� �������� ����������� �������.
\ ������� ������� �������, ������� ������������� � ����. 
\ ��� ������ ������� �������� ������� � ���� ���������.

\ S" 2 DUP * ." axt ( xt ) -- ������ �� ���� ����� ����
\ ������� ������������ ���� ������������� ��� ����������
\ ������

\ ������ ����� ������� ������� ���� ���������� �������
\ ������ DESTROY-VC �� ~profit/lib/compile2Heap.f

\ ����� ������� ������� ���� �������������, ��� ������ 
\ �� �������� ����������� (��� ��� �������� "�� �������"
\ bac4th-������) ����� ������������ axt=>
\ S" 2 DUP * ." axt=> ( xt )

\ �������� ����� ������� ���� ������ � ��������� �����
\ ����� ������������ ������ ~ac/lib/str5.f
\ (�� ������� ������):
\ " 2 DUP
\ * . " straxt=> ( xt )

\ ��� ���� � ������������ ������� ���� ���� ����� ����������������
\ ���� �����, ������� �� �� ����� � �������� �������������� ��������
\ IMMEDIATE-������� ��������� LITERAL , ��� ����� ��� �������� �����
\ �� ����� � ������������� �������.
\ ��� �� ����� ������� �������� � ����� ������������� ������� [ � ] 
\ (��. ������� �����)

\ ����� �������� ��������, ������ "���������", ������������
\ ���������� ������ ������ 3.2.3.2 ANS-94:

\ "���� ������-����������, �����, �� �� �����������, ��������� 
\ ������������ � ����������. ���� �� ����������, �� ����� ����,
\ �� �� �����������, ���������� � �������������� ����� ������.
\ ������ ����� ������-���������� -- ������������  �����������.
\ ��� ��� ���� ������-����������  ����� ���� ���������� � 
\ �������������� ����� ������, ��������, ���������� �� ���� 
\ ������ ���������� ��� �������� ����� ��������� ���������
\ �� ���� ������-����������, � �������� ����������� �� �������� 
\ ��������� ����� ������-����������."

\ REQUIRE MemReport ~day/lib/memreport.f

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
\ REQUIRE EVALUATED-HEAP ~profit/lib/evaluated.f
REQUIRE VC-COMPILED ~profit/lib/compile2Heap.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE A_BEGIN ~mak/lib/a_if.f

MODULE: bac4th-closures

\ ���������� ��������� ���������� � ��������� control-flow stack
: BEGIN [COMPILE] A_BEGIN ; IMMEDIATE
: WHILE	[COMPILE] A_WHILE ; IMMEDIATE
: AHEAD	[COMPILE] A_AHEAD ; IMMEDIATE
: IF 	[COMPILE] A_IF ; IMMEDIATE
: ELSE	[COMPILE] A_ELSE ; IMMEDIATE
: THEN	[COMPILE] A_THEN ; IMMEDIATE
: AGAIN	[COMPILE] A_AGAIN ; IMMEDIATE
: REPEAT [COMPILE] A_REPEAT ; IMMEDIATE
: UNTIL [COMPILE] A_UNTIL ; IMMEDIATE

EXPORT

: axt ( addr u -- xt ) LOCAL t
CREATE-VC t ! \ ������ ����������� ��������
ALSO bac4th-closures \ ���������� ������� � ������ ����������� ����������
t @ VC-COMPILED \ ����������� ������ � ����������� ��������
PREVIOUS \ ��������� ��� �� ��������� ����������
t @ VC-RET, \ ������ ������� ������
t @ \ ���� ����������� ����� ������ ���������
;


: axt=> ( addr u --> xt \ <-- ) PRO
axt \ ����������� ������, ���� ����������� ����� ����
BACK DESTROY-VC TRACKING RESTB \ �� ��������� ��������� �������� ��������
CONT \ � ������ ��� ������
;

\ �� �� ����� ��� � compiledCode , �� � ������������� �������� �� ~ac/lib/str4.f
\ ��� ��������� ������ ��� � ��������� �����
: straxt=> ( s --> xt \ <-- ) PRO LOCAL s DUP s ! STR@ axt=> s @ STRFREE CONT ;

: compiledCode ( addr u --> xt \ <-- ) \ ������� ��� axt=>
RUSH> axt=> ;

: STRcompiledCode  ( s --> xt \ <-- ) RUSH> straxt=> ;

;MODULE

/TEST
REQUIRE SEE lib/ext/disasm.f

: showMeTheCode ( addr u -- ) compiledCode XT-VC DUP REST EXECUTE CR CR ;

$> 4 2 1 S" LITERAL LITERAL + LITERAL * ." showMeTheCode

$> 100 S" 0 BEGIN DUP 10 < WHILE LITERAL . 1+ REPEAT DROP " showMeTheCode