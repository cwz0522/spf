\ ��������� ��� �������� ����������� �������.
\ ������� ������� �������, ������� ������������� � ����. 
\ ��� ������ ������� �������� ������� � ���� ���������.

\ �������������� ������� ��� IMMEDIATE-������� ��������� LITERAL ,
\ ������ ��� �������� ����� �� ����� � ������������� ������� ���
\ ������ ������ � ����� ������������� ������� [ � ]


\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE A_BEGIN ~mak/lib/a_if.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
\ REQUIRE EVALUATED-HEAP ~profit/lib/evaluated.f
REQUIRE VC-COMPILED ~profit/lib/compile2Heap.f
REQUIRE STR@ ~ac/lib/str4.f

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

: compiledCode ( addr u --> addr-code \ <-- ) PRO LOCAL t
CREATE-VC t ! \ ������ ����������� ��������
ALSO bac4th-closures \ ���������� ������� � ������ ����������� ����������
t @ VC-COMPILED \ ����������� ������ � ����������� ��������
PREVIOUS \ ��������� ��� �� ��������� ����������
t @ VC-RET, \ ������ ������� ������
t @ XT-VC CONT \ ���� ����������� ����� ������ ��������� � ������ ��� ������
t @ DESTROY-VC ; \ �� ��������� ��������� �������� ��������

\ �� �� ����� ��� � compiledCode , �� � ������������� �������� �� ~ac/lib/str4.f
\ ��� ��������� ������ ��� � ��������� �����
: STRcompiledCode ( s --> ) PRO LOCAL s DUP s ! STR@ compiledCode s @ STRFREE CONT ;

;MODULE

/TEST
REQUIRE SEE lib/ext/disasm.f

: showMeTheCode ( addr u -- ) compiledCode REST CR CR ;

$> 4 2 1 S" LITERAL LITERAL + + LITERAL * " showMeTheCode

$> 100 S" 0 BEGIN DUP 10 < WHILE LITERAL . 1+ REPEAT DROP " showMeTheCode