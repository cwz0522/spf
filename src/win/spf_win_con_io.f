\ $Id$

( ���������� ����-�����.
  Windows-��������� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
  ��������� - Ruvim Pinka ������ 1999
)

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

' ACCEPT1 (TO) ACCEPT

VECT TYPE

: TYPE1 ( c-addr u -- ) \ 94
\ ���� u>0 - ������� ������ ��������, �������� c-addr � u.
\ ���������, ������������ ����������� �������, ������� �� ���������.
  ANSI><OEM
  2DUP TO-LOG
  H-STDOUT DUP 0 > IF WRITE-FILE THROW ELSE 2DROP DROP THEN
;

' TYPE1 (TO) TYPE

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

: EKEY? ( -- flag ) \ 93 FACILITY EXT
\ ���� ������������ ������� ��������, ������� "������". ����� "����".
\ ������� ������ ���� ���������� ��������� ����������� EKEY.
\ ����� ���� ��� EKEY? ���������� �������� "������", ��������� ����������
\ EKEY? �� ���������� KEY, KEY? ��� EKEY ����� ���������� "������",
\ ����������� � ���� �� �������.
  0 >R RP@ H-STDIN GetNumberOfConsoleInputEvents DROP R>
;

CREATE INPUT_RECORD ( /INPUT_RECORD) 20 2 * CHARS ALLOT

: ControlKeysMask ( -- u )
\ ������� ����� ����������� ������ ��� ���������� ������������� �������.
    [ INPUT_RECORD ( Event dwControlKeyState ) 16 + ] LITERAL @
;

1 CONSTANT KEY_EVENT

: EKEY ( -- u ) \ 93 FACILITY EXT
\ ������� ���� ������������ ������� u. ����������� ������������ �������
\ ������� �� ����������.
\ � ������ ���������� 
\ byte  value
\    0  AsciiChar
\    2  ScanCod
\    3  KeyDownFlag
  0 >R RP@ 2 INPUT_RECORD H-STDIN \ 1 ������� �� 2 (30.12.2001 ~boa)
  ReadConsoleInputA DROP RDROP
  INPUT_RECORD ( EventType ) W@  KEY_EVENT <> IF 0 EXIT THEN
  [ INPUT_RECORD ( Event AsciiChar       ) 14 + ] LITERAL W@
  [ INPUT_RECORD ( Event wVirtualScanCode) 12 + ] LITERAL W@  16 LSHIFT OR
  [ INPUT_RECORD ( Event bKeyDown        ) 04 + ] LITERAL C@  24 LSHIFT OR
;

HEX
: EKEY>CHAR ( u -- u false | char true ) \ 93 FACILITY EXT
\ ���� ������������ ������� u ������������� ������� - ������� ������ �
\ "������". ����� u � "����".
  DUP    FF000000 AND  0=   IF FALSE    EXIT THEN
  DUP    000000FF AND  DUP IF NIP TRUE EXIT THEN DROP
  FALSE
;

: EKEY>SCAN ( u -- scan flag )
\ ������� ����-��� �������, ��������������� ������������� ������� u
\ flag=true - ������� ������. flag=false - ��������.
  DUP  10 RSHIFT  000000FF AND
  SWAP FF000000 AND 0<>
;
DECIMAL
