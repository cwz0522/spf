\ 31-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ��������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

        \ ������� ���������� ���������� ������ �������� �������� ������
        CELL CONSTANT ADDR

\ ������� �����, �������� �� ���������� ������
: A@ ( addr --> addr ) @ ;

\ ��������� �������� ������ �� ���������� ������
: A! ( addr addr --> ) ! ;

\ ������������� �������� ������ �� ������� ���������.
: A, ( addr --> ) , ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{
  CREATE aaa HERE A,
  aaa A@ aaa <> THROW
  123456 DUP aaa A! aaa A@ <> THROW
S" passed" TYPE
}test