\ ������-�����������.
\ ��� ��� SPF
\ ����:  SU.FORTH, �� Piter Sovietov
\ Ruvim,  06.01.2000

REQUIRE AHEAD lib\include\tools.f 

: LAMBDA{  ( -- )
\ ����� ����������  ( -- orig1 xt )
   POSTPONE  AHEAD
   HERE
; IMMEDIATE

: }        ( -- xt )
\ ����� ����������  ( orig1 xt -- )
\ ��� ������ ����������� LAMBDA{  } �� �����������, ������������ xt �� ���� ���.
   >R
   POSTPONE EXIT
   POSTPONE THEN
   R> POSTPONE LITERAL
; IMMEDIATE


( ��� �����  LAMBDA{ ... }   �������� ��� � ��������� �����.
  ������� ��� ����. ���������� ������� � ��������� ���������� �� �����.
)