\ $Id$
\ �������� �ਨ ����⠭�
\ enum{ , zero , one DROP 5 , five }

VOCABULARY EnumSupport
GET-CURRENT ALSO EnumSupport DEFINITIONS

\ ������� ��।��� ����⠭��
: , ( n -- n+1 )  DUP CONSTANT 1+ ;

\ �����稢��� ᮧ����� ����⠭�
: } ( n -- )  DROP PREVIOUS ;

SET-CURRENT

\ ��稭��� ᮧ����� �ਨ ����⠭�, ������ 0 �� �⥪
: enum{
  0
  ALSO EnumSupport
;
PREVIOUS
