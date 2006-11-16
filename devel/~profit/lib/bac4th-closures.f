\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE CONT ~profit/lib/bac4th-mem.f 
REQUIRE FREEB ~profit/lib/bac4th-mem.f 

: compiledCode ( addr u -- addr-code )  HERE >R
TRUE STATE ! \ �������� ����������
EVALUATE \ ��������� ������-��������
RET, \ ����������� �����������
STATE 0! \ ��������� ����������
HERE \ ������� �������� HERE, ����� ����������
R@ DP ! \ ��������������� HERE � ������������ ��������
R@ \ ������ �������� HERE, ����� ���
( ����� ������ )
- ( �����-������ ) \ ������������ ����� ���������������� ������������������
R> OVER ( ����� ������ ����� )
ALLOCATE THROW
DUP >R
( ����� ������ ����������-������ )
ROT CMOVE R> ( �����-�������-����-�-���� ) ;

\EOF
REQUIRE SEE lib/ext/disasm.f

: s ( n -- ) S" LITERAL +" compiledCode FREEB REST ;

: r 4 0 DO CR CR I . I s LOOP ;
r

MemReport