\ 06-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������� �� ࠡ�� � ��ப��� ᫮��

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

?DEFINED char  1 CHARS CONSTANT char

\ ������ ��ப� �㫥��� ������
: EMPTY" ( --> asc # ) S" " ;

\ �८�ࠧ����� ᨬ��� � ��ப�, ᮤ�ঠ��� ���� ᨬ���
: Char>Asc ( char --> asc # ) SYSTEM-PAD TUCK C! 0 OVER char + C! char ;

\ 㪮���� ��ப� asc # �� u ᨬ����� �� ��砫�
: SKIPn ( asc # u --> asc+u #-u ) OVER MIN TUCK - >R + R> ;

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ CHAR � Char>Asc S" �" COMPARE 0<> THROW
      S" aksdjhf" 3 SKIPn S" djhf" COMPARE 0<> THROW
  S" passed" TYPE
}test
