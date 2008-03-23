\ $ Id$
\ 
\ ���������� ����-�����.
\ �. �������, 9.05.2007

   0 VALUE  H-STDIN    \ ����� ����� - ������������ �����
   1 VALUE  H-STDOUT   \ ����� ����� - ������������ ������
   2 VALUE  H-STDERR   \ ����� ����� - ������������ ������ ������
   0 VALUE  H-STDLOG


: ENDLOG
\ ��������� ���.
    H-STDLOG
    IF
      H-STDLOG CLOSE-FILE
      0 TO H-STDLOG 
      THROW 
    THEN
; 

: STARTLOG ( -- )
\ ������� ���� spf.log. ������ ��� �����/������.
\ ���� ��� ��� ������, �������� � ������ ������
  ENDLOG
  S" spf.log" W/O     ( S: addr count attr -- )            
  CREATE-FILE-SHARED  ( S: addr count attr -- handle ior ) 
  THROW                                                    
  TO H-STDLOG                                              
;

: TO-LOG ( addr u -- )
\ �������� �������� ������ � ��� ����
  H-STDLOG IF H-STDLOG WRITE-FILE 0 THEN 2DROP
;

VECT ACCEPT

: ACCEPT1 ( c-addr +n1 -- +n2 ) \ 94
\ ������ ������ ������������ ����� �� +n1 ��������.
\ �������������� �������� ���������, ���� +n1 0 ��� ������ 32767.
\ ���������� ������� �� ���� �����.
\ ���� �����������, ����� ������� ������ "����� ������".
\ ������ �� ����������� � ������.
\ +n2 - ����� ������, ���������� �� ������ c-addr.
  OVER SWAP
  H-STDIN READ-LINE
  
  DUP 109 = IF DROP -1002 THEN THROW ( ~ruv)
  0= IF -1002 THROW THEN ( ~ac)
  
  TUCK TO-LOG
  LT LTL @ TO-LOG \ ���� ���� � user-device �������� cr � ���, �� ���� ������ Enter
;

' ACCEPT1 ' ACCEPT TC-VECT!

VECT TYPE

: TYPE1 ( c-addr u -- ) \ 94
\ ���� u>0 - ������� ������ ��������, �������� c-addr � u.
\ ���������, ������������ ����������� �������, ������� �� ���������.
\  ANSI><OEM
  2DUP TO-LOG
  H-STDOUT DUP 0 > IF WRITE-FILE THROW ELSE 2DROP DROP THEN
;

' TYPE1 ' TYPE TC-VECT!

: EMIT ( x -- ) \ 94
\ ���� x - ������������ ������, ������� ��� �� �������.
\ ���������, ������������ ����������� �������, ������� �� ���������.
  >R RP@ 1 TYPE
  RDROP
;

: CR ( -- ) \ 94
\ ������� ������.
  LT LTL @
  TYPE
;

VECT KEY
' FALSE ' KEY   TC-VECT!

VECT KEY?
' FALSE ' KEY?  TC-VECT!
