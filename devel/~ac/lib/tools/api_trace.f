\ ��� WINAPI-������� ����� ��������� ���� � uLastApiFunc,
\ ����� � ������ EXCEPTION'� ��� ���� ����� ����� ���� �� ���������� �������

USER uLastApiFunc

: _WINAPI-TRACE
  uLastApiFunc !
;
: WINAPI: ( "������������" "�������������" -- )
  NEW-WINAPI?
  IF HEADER
  ELSE -1 >IN @ HEADER >IN ! THEN
  LATEST LIT,                      \  LATEST ] POSTPONE LITERAL POSTPONE [  :)
  POSTPONE _WINAPI-TRACE
  POSTPONE _WINAPI-CODE
  __WIN:
;
