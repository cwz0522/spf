( ������ ������ ��������� ������ �� �������� ������: ������� ��� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������: �������� 1999
)

USER-VALUE SOURCE-ID ( -- 0|-1 ) \ 94 CORE EXT
\ �������������� ������� �����:
\ -1 - ������ (����� EVALUATE)
\  0 - ���������������� ������� ����������
USER-VALUE SOURCE-ID-XT \ ���� �� ����� ����, �� �������� �����������
\ ����� ��� REFILL

VECT <PRE>
USER CURSTR \ ����� ������

: CONSOLE-HANDLES
\  0 TO SOURCE-ID
  -10 GetStdHandle TO H-STDIN 
  -11 GetStdHandle TO H-STDOUT
  -12 GetStdHandle TO H-STDERR
;


VECT REFILL ( -- flag )

: TAKEN-TIB ( u flag -- flag )
  IF CURSTR 1+!  TIB SWAP SOURCE!  <PRE> -1  ELSE DROP 0  THEN
;
: REFILL-STDIN ( -- flag ) \  from user input
  SOURCE-ID -1 = IF FALSE EXIT THEN ( evaluate string )
  TIB C/L ['] ACCEPT CATCH
  \ -1002=����� ����� ��� pipe
  \ ��������� ������ - ������ ������
  DUP -1002 = IF DROP 2DROP 0 0 ELSE THROW -1 THEN
  TAKEN-TIB
;
' REFILL-STDIN (TO) REFILL ( -- flag ) \ 94 CORE EXT
\ ���������� ��������� ������� ����� �� �������� ������, �������
\ ���� "������", ���� �������.
\ ����� ������� ������� �������� ���������������� ������� ����������,
\ ���������� ������� ���� � ������������ ������� �����. ���� �������,
\ ������� ��������� ������� �������, ���������� >IN � ���� � ����������
\ "������". ����� ������, �� ���������� ��������, ��������� ��������.
\ ���� ���� � �������� �������� ���������� ���������� - ���������� "����".
\ ����� ������� ������� �������� ������ �� EVALUATE, ���������� "����"
\ � �� ��������� ������ ��������.

( ����������� [ ������������ ACCEPT ������ READ-LINE  ~ruv ]
  �� ��� ������, ����� ������� �� ����, � ������ �
  ������� ����� ACCEPT [������� ����� ���� �� ��������]
  24.04.2000 �.�.
)

\ ------------------------

: FREFILL ( h -- flag )
  TIB C/L ROT READ-LINE THROW TAKEN-TIB
;
: REFILL-SOURCE ( -- flag )
  SOURCE-ID-XT IF
   TIB C/L SOURCE-ID SOURCE-ID-XT EXECUTE THROW
   TAKEN-TIB
  ELSE
   SOURCE-ID FREFILL
  THEN
;
: REFILL-FILE ( -- flag ) \ 94 FILE EXT
  SOURCE-ID 0 > IF ( included text )
  REFILL-SOURCE ELSE
  REFILL-STDIN  THEN
;
' REFILL-FILE (TO) REFILL ( -- flag ) \ 94 FILE EXT
\ ��������� ��������� ���������� CORE EXT REFILL ���������:
\ ����� ������� ����� - ��������� ����, ���������� �������� ���������
\ ������ �� ���������� �������� �����. ���� �������, ������� ���������
\ ������� �������, ���������� >IN � ���� � ������� "������".
\ ����� ������� "����".
