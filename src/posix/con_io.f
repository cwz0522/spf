\ $ Id$
\ 
\ ���������� ����-�����.
\ �. �������, 9.05.2007

   0 VALUE  H-STDIN    \ ����� ����� - ������������ �����
   1 VALUE  H-STDOUT   \ ����� ����� - ������������ ������
   2 VALUE  H-STDERR   \ ����� ����� - ������������ ������ ������
   0 VALUE  H-STDLOG

: TYPE1 ( c-addr u -- ) \ 94
\ ���� u>0 - ������� ������ ��������, �������� c-addr � u.
\ ���������, ������������ ����������� �������, ������� �� ���������.
\  ANSI><OEM
  2DUP TO-LOG
  H-STDOUT DUP 0 > IF WRITE-FILE THROW ELSE 2DROP DROP THEN
;

' TYPE1 ' TYPE TC-VECT!

VECT KEY
' FALSE ' KEY   TC-VECT!

VECT KEY?
' FALSE ' KEY?  TC-VECT!
