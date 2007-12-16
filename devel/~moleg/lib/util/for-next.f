\ 02-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������� ������ FOR NEXT ��� ���
\ c ������������ ������������� �� ����� ���������� (�.� ��� STATE = 0)

\ ��� ���������� ������ � ��������� ���������� �������� ��������� ���:
\  ALSO vocLocalsSupport DEFINITIONS ALSO FORTH
\     : FOR    FORTH::POSTPONE DO     [  1 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\     : NEXT   FORTH::POSTPONE ?DO    [ -1 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\     : TILL   FORTH::POSTPONE ?DO    [ -1 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
\  PREVIOUS PREVIOUS DEFINITIONS

 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f
 REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE controls devel\~moleg\lib\util\run.f

\ ������ ����������� ����� �� ���������
: FOR ( n --> )
      STATE @ IFNOT init: THEN 3 controls +!
      <MARK COMPILE >R  ; IMMEDIATE

\ ���� ������� ����� �� ����� ���� ������� � �����, ���������� ������ FOR
\ �����, ���������� ���������� ��������� �� ����� �� NEXT
: NEXT ( --> )
       ?COMP -3 controls +!
       COMPILE R> COMPILE DUP 1 LIT, COMPILE - COMPILE SWAP
       N?BRANCH, COMPILE DROP
       controls @ IFNOT [COMPILE] ;stop THEN ; IMMEDIATE

\ ���������� NEXT ��������� ��������� ����� �� ���������,
\ ������ ���� ������� �� ���������� 1, � �� 0
: TILL ( --> )
       ?COMP -3 controls +!
       COMPILE R> 1 LIT, COMPILE - COMPILE DUP
       N?BRANCH, COMPILE DROP
       controls @ IFNOT [COMPILE] ;stop THEN ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 3 FOR R@ NEXT 0 <> THROW 1 <> THROW 2 <> THROW 3 <> THROW
      3 FOR R@ TILL 1 <> THROW 2 <> THROW 3 <> THROW
   S" passed" TYPE
}test

\EOF ������ �������������:
     10 FOR R@ . NEXT
     ������ ������ ��� ����� �� 10 �� 0

     � �� �����, ��� 10 FOR R@ . TILL
     ������ ������ ��� ����� �� 10 �� 1
