\ 20-03-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� � ��������������

REQUIRE ?: devel\~moleg\lib\util\ifcolon.f
?: A@ @ ; ?: A, , ;

\ �� �������� �������� ����� USER ����������.
: >uaddr, ( user --> addr )
          0x8D C, 0x04 C, 0x07 C, \ LEA EAX, [EDI] [EAX]
          ; IMMEDIATE

\ ������� �����, ���������� ��������� �������:
\ ���� ����� ����������� ������� � ��������� ������ - ��������� ����� init
\ ��������� ����� work.
: ivect ( ' init ' work / name --> )
        CREATE A, A, USER-HERE , 1 USER-ALLOT
        DOES>
              DUP [ 2 CELLS ] LITERAL + @ >uaddr, C@
                  IF ELSE DUP CELL + A@ EXECUTE
                     TRUE OVER [ 2 CELLS ] LITERAL + @ >uaddr, C!
                  THEN
              A@ EXECUTE ;

\EOF �������� ������

: vinit  ." initialize" CR ;
: vwork  ." working " CR ;

' vinit ' vwork ivect tester

tester CR tester

