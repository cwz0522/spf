( ���������� ����-�����.
  Windows-��������� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
  ��������� - Ruvim Pinka ������ 1999
)

H-STDIN  VALUE  H-STDIN    \ ����� ����� - ������������ �����
H-STDOUT VALUE  H-STDOUT   \ ����� ����� - ������������ ������
H-STDERR VALUE  H-STDERR   \ ����� ����� - ������������ ������ ������

: ACCEPT ( c-addr +n1 -- +n2 ) \ 94
\ ������ ������ ������������ ����� �� +n1 ��������.
\ �������������� �������� ���������, ���� +n1 0 ��� ������ 32767.
\ ���������� ������� �� ���� �����.
\ ���� �����������, ����� ������� ������ "����� ������".
\ ������ �� ����������� � ������.
\ +n2 - ����� ������, ���������� �� ������ c-addr.
  H-STDIN READ-LINE THROW DROP
;

: EMIT ( x -- ) \ 94
\ ���� x - ������������ ������, ������� ��� �� �������.
\ ���������, ������������ ����������� �������, ������� �� ���������.
  >R RP@ 1 H-STDOUT WRITE-FILE RDROP THROW
;

: CR ( -- ) \ 94
\ ������� ������.
  LT LTL @ H-STDOUT WRITE-FILE THROW
;

: TYPE ( c-addr u -- ) \ 94
\ ���� u>0 - ������� ������ ��������, �������� c-addr � u.
\ ���������, ������������ ����������� �������, ������� �� ���������.
  ANSI><OEM
  H-STDOUT WRITE-FILE THROW
;


USER NumberOfConsoleInputEvents

: EKEY? ( -- flag ) \ 93 FACILITY EXT
\ ���� ������������ ������� ��������, ������� "������". ����� "����".
\ ������� ������ ���� ���������� ��������� ����������� EKEY.
\ ����� ���� ��� EKEY? ���������� �������� "������", ��������� ����������
\ EKEY? �� ���������� KEY, KEY? ��� EKEY ����� ���������� "������",
\ ����������� � ���� �� �������.
  NumberOfConsoleInputEvents H-STDIN
  GetNumberOfConsoleInputEvents DROP
  NumberOfConsoleInputEvents @
;


CREATE INPUT_RECORD ( /INPUT_RECORD) 20 ALLOT

: ControlKeysMask ( -- u )
\ ������� ����� ����������� ������ ��� ���������� ������������� �������.
    [ INPUT_RECORD ( Event dwControlKeyState ) 16 + ] LITERAL  @
;

1 CONSTANT KEY_EVENT
USER NumberOfRecordsRead

: EKEY ( -- u ) \ 93 FACILITY EXT
\ ������� ���� ������������ ������� u. ����������� ������������ �������
\ ������� �� ����������.
\ � ������ ���������� 
\ byte  value
\    0  AsciiChar
\    2  ScanCod
\    3  KeyDownFlag
  NumberOfRecordsRead 2 INPUT_RECORD H-STDIN \ 1 ������� �� 2 (30.12.2001 ~boa)
  ReadConsoleInputA DROP
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
  DUP    000000FF AND  ?DUP IF NIP TRUE EXIT THEN
  FALSE
;

: EKEY>SCAN ( u -- scan flag )
\ ������� ����-��� �������, ��������������� ������������� ������� u
\ flag=true - ������� ������. flag=false - ��������.
  DUP  10 RSHIFT  000000FF AND
  SWAP FF000000 AND 0<>
;
DECIMAL
