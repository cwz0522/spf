\ 25-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ��������, ���� ����� �� �������

\ ������� TRUE ���� ��������� ����� ������� � ���������
: ?WORD ( / token --> flag )
        SP@ >R  NextWord SFIND
        IF R> SP! TRUE
         ELSE R> SP! FALSE
        THEN ;

\ ��������� ��������� �� token ���, ���� token �� ������ � ���������
: ?DEFINED ( / token --> ) ?WORD IF [COMPILE] \ THEN ; IMMEDIATE

\ ��������� ��������� �� token ���, ���� token ������ � ���������
: N?DEFINED ( / token --> ) ?WORD IF ELSE [COMPILE] \ THEN ; IMMEDIATE

?DEFINED test{ \EOF

test{  S" passed" TYPE }test

\EOF -- sample --------------------------------------------------------------

?DEFINED A@  : A@ @ ; : A! ! ; : A, , ; : ADDR CELL ;

