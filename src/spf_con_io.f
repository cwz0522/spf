( ���������� ����-�����.
  ��-����������� ����� [������������...].
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

32 VALUE BL ( -- char ) \ 94
\ char - �������� ������� "������".

: SPACE ( -- ) \ 94
\ ������� �� ����� ���� ������.
  BL EMIT
;

: SPACES ( n -- ) \ 94
\ ���� n>0 - ������� �� ������� n ��������.
  DUP 1 < IF DROP EXIT THEN
  BEGIN
    DUP
  WHILE
    BL EMIT 1-
  REPEAT DROP
;

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
  EOLN TO-LOG \ ���� ���� � user-device �������� cr � ���, �� ���� ������ Enter
;

' ACCEPT1 ' ACCEPT TC-VECT!

VECT TYPE

: EMIT ( x -- ) \ 94
\ ���� x - ������������ ������, ������� ��� �� �������.
\ ���������, ������������ ����������� �������, ������� �� ���������.
  >R RP@ 1 TYPE
  RDROP
;

: CR ( -- ) \ 94
\ ������� ������.
  EOLN TYPE
;

TARGET-POSIX [IF]
\ TODO KEY EKEY
S" src/posix/con_io.f" INCLUDED
[ELSE]
S" src/win/spf_win_con_io.f" INCLUDED
[THEN]

