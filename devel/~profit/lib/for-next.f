\ ���� FOR ... NEXT. ����� ������ ���� ���������� �����,
\ ������� �� ���������� �������� ��������� � ���� � ����� �������

\ ��-�� ���������� ����� I � SPF ����� �������� �������� ����������
\ ��� �� ������ I �� ���������, ���� ����� ����� R@

REQUIRE /TEST ~profit/lib/testing.f

: FOR POSTPONE >R HERE ;  IMMEDIATE

: NEXT  ?COMP
POSTPONE R> POSTPONE DUP POSTPONE 1- POSTPONE >R
POSTPONE 0= ?BRANCH,
POSTPONE RDROP
;  IMMEDIATE
DECIMAL

/TEST
: r 10 FOR R@ . NEXT ;

REQUIRE SEE lib/ext/disasm.f
SEE r

r