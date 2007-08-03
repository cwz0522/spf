\ 20-03-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� � ��������������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE ADDR     devel\~moleg\lib\util\addr.f

\ �� �������� �������� ����� USER ����������.
: >uaddr, ( user --> addr )
          0x8D C, 0x04 C, 0x07 C, \ LEA EAX, [EDI] [EAX]
          ; IMMEDIATE

\ ������� �����, ���������� ��������� �������:
\ ���� ����� ����������� ������� � ��������� ������ - ��������� ����� init
\ ����� ��������� ����� work. ���� ����� ��� ���������� � ��������� ������,
\ �� ��������� ������ ����� work
: ivect ( ' init ' work / name --> )
        CREATE A, A, USER-HERE , 1 USER-ALLOT
        DOES>
              DUP >R [ 2 CELLS ] LITERAL + @ >uaddr, C@
                  IF ELSE R@ CELL + A@ EXECUTE
                     TRUE R@ [ 2 CELLS ] LITERAL + @ >uaddr, C!
                  THEN
              R> A@ EXECUTE ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{
      1 DEPTH NIP
      : vinit  487562 ;
      : vwork  876398 ;

      ' vinit ' vwork ivect sample

      sample vwork <> THROW vinit <> THROW
      sample vwork <> THROW
      DEPTH <> THROW
  S" passed" TYPE
}test

\EOF ������ �������������

: vinit  ." initialize" CR ;
: vwork  ." working " CR ;

' vinit ' vwork ivect tester

tester CR tester
