\ 31-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ࠡ�� � ���ᠬ�

REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

        \ ᪮�쪮 �������쭮 ����㥬�� ������ �������� ���᭠� ��뫪�
        CELL CONSTANT ADDR

\ ������� ����, �࠭��� �� 㪠������� �����
: A@ ( addr --> addr ) @ ;

\ ��࠭��� ������ ��뫪� �� 㪠������� �����
: A! ( addr addr --> ) ! ;

\ �������஢��� ������ ��뫪� �� ���設� ����䠩��.
: A, ( addr --> ) , ;

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{
  CREATE aaa HERE A,
  aaa A@ aaa <> THROW
  123456 DUP aaa A! aaa A@ <> THROW
S" passed" TYPE
}test