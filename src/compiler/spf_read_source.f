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

: REFILL ( -- flag ) \ 94 FILE EXT
\ ��������� ��������� ���������� CORE EXT REFILL ���������:
\ ����� ������� ����� - ��������� ����, ���������� �������� ���������
\ ������ �� ���������� �������� �����. ���� �������, ������� ���������
\ ������� �������, ���������� >IN � ���� � ������� "������".
\ ����� ������� "����".
\ : REFILL ( -- flag ) \ 94 CORE EXT
\ ���������� ��������� ������� ����� �� �������� ������, �������
\ ���� "������", ���� �������.
\ ����� ������� ������� �������� ���������������� ������� ����������,
\ ���������� ������� ���� � ������������ ������� �����. ���� �������,
\ ������� ��������� ������� �������, ���������� >IN � ���� � ����������
\ "������". ����� ������, �� ���������� ��������, ��������� ��������.
\ ���� ���� � �������� �������� ���������� ���������� - ���������� "����".
\ ����� ������� ������� �������� ������ �� EVALUATE, ���������� "����"
\ � �� ��������� ������ ��������.

\   CURSTR 1+!
\   TIB C/L
\   SOURCE-ID 0 > IF SOURCE-ID ( included text )
\                 ELSE SOURCE-ID
\                      IF 2DROP FALSE EXIT THEN ( evaluate string )
\                      H-STDIN ( user input )
\                 THEN
\   READ-LINE THROW ( ������ ������ )
\   IF #TIB ! >IN 0! <PRE> -1
\   ELSE DROP 0 THEN
\ ;

( ����������� �� ��� ������, ����� ������� �� ����, � ������ �
  ������� ����� ACCEPT [������� ����� ���� �� ��������]
  24.04.2000 �.�.
)
  CURSTR 1+!
  TIB C/L
  SOURCE-ID 0 > IF SOURCE-ID ( included text )
     SOURCE-ID-XT ?DUP IF EXECUTE ELSE READ-LINE THEN
     THROW ( ������ ������ )
     IF #TIB !
     ELSE DROP FALSE EXIT THEN
  ELSE SOURCE-ID
     IF 2DROP FALSE EXIT THEN ( evaluate string )
     ['] ACCEPT CATCH ?DUP \ -1002=����� ����� ��� pipe
                            \ ��������� ������ - ������ ������
     IF -1002 = IF FALSE EXIT THEN
        THROW
     ELSE #TIB ! THEN ( user input )
  THEN
  >IN 0! <PRE> -1
;
