\ ��� WINAPI-������� ����� ��������� ���� � uLastApiFunc,
\ ����� � ������ EXCEPTION'� ��� ���� ����� ����� ���� �� ���������� �������

USER uLastApiFunc

: _WINAPI-TRACE
  uLastApiFunc !
;
: WINAPI: ( "������������" "�������������" -- )

  >IN @ NextWord SFIND
  IF DROP
     DROP NextWord 2DROP EXIT
  ELSE 2DROP >IN ! THEN

  NEW-WINAPI?
  IF HEADER
  ELSE -1 >IN @ HEADER >IN ! THEN
  LATEST LIT,                      \  LATEST ] POSTPONE LITERAL POSTPONE [  :)
  POSTPONE _WINAPI-TRACE
  POSTPONE _WINAPI-CODE
  __WIN:
;
