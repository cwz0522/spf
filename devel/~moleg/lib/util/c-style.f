\ 18-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������� ������ਨ � �⨫� ��
\ � ������������ �������⭮� ����������

 REQUIRE [IFNOT]  devel\~moleg\lib\util\qif.f

ALSO ROOT DEFINITIONS

   VECT \* IMMEDIATE
   VECT *\ IMMEDIATE

RECENT

\ �ய����� ���� ⥪�� �� �������饣� ᫮�� *\
\ �஡�� ��। *\ ��易⥫��
: _\* ( / ... *\ --> )
      ['] \* >CS
      ['] \* ['] *\ skipto'' EXECUTE ;

\ �����襭�� ��������筮�� ��������
: _*\ ( --> )
      CS@ ['] \* =
      IF CSDrop
         CS@ ['] \* = IF ['] \* ['] *\ skipto'' EXECUTE THEN
       ELSE -1 THROW
      THEN ;

' _\* IS \*
' _*\ IS *\

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------
test{
 \* �祭� ���⮩ \* ��� *\ ࠡ��ᯮᮡ���� *\
  S" passed" TYPE
}test
