( ������ ������ � �������� ������� ��������� �� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������� 1999: PARSE � SKIP ������������� �� CODE
  � ��������������� �����������. ���������� ������������� � USER.
)

USER #TIB ( -- a-addr ) \ 94 CORE EXT
\ a-addr - ����� ������, ���������� ����� �������� � ������ TIB.

USER >IN ( -- a-addr ) \ 94
\ a-addr - ����� ������, ���������� �������� ��������� ������ �� �������
\ ��������� ������.

512  VALUE  C/L \ ������������ ������ ������, ������� ����� ������ � TIB

USER-VALUE  TIB ( -- c-addr ) \ 94 CORE EXT
\ ����� ������������� �������� ������.

USER-CREATE ATIB
\ �������� �������� TIB
1024 TC-USER-ALLOT

: SOURCE ( -- c-addr u ) \ 94
\ c-addr - ����� �������� ������. u - ���������� �������� � ���.
  TIB #TIB @
;

: EndOfChunk ( -- flag )
  >IN @ SOURCE NIP < 0=        \ >IN �� ������, ��� ����� �����
;

: CharAddr ( -- c-addr )
  SOURCE DROP >IN @ +
;

: PeekChar ( -- char )
  CharAddr C@       \ ������ �� �������� �������� >IN
;

: IsDelimiter ( char -- flag )
  BL 1+ <
;

: GetChar ( -- char flag )
  EndOfChunk
  IF 0 FALSE
  ELSE PeekChar TRUE THEN
;

: OnDelimiter ( -- flag )
  GetChar SWAP IsDelimiter AND
;

: SkipDelimiters ( -- ) \ ���������� ���������� �������
  BEGIN
    OnDelimiter
  WHILE
    >IN 1+!
  REPEAT
;

: OnNotDelimiter ( -- flag )
  GetChar SWAP IsDelimiter 0= AND
;

: SkipWord ( -- ) \ ���������� ������������ �������
  BEGIN
    OnNotDelimiter
  WHILE
    >IN 1+!
  REPEAT
;
: SkipUpTo ( char -- ) \ ���������� �� ������� char
  BEGIN
    DUP GetChar >R <> R> AND
  WHILE
    >IN 1+!
  REPEAT DROP
;

: ParseWord ( -- c-addr u )
  CharAddr >IN @
  SkipWord
  >IN @ SWAP -
;

: NextWord ( -- c-addr u )
  \ ��� ����� ������ ����� ������������ � INTERPRET
  \ - �������: �� ���������� WORD �, ��������������, �� ������� � HERE;
  \ � ������������� ������� ��� ��� <=BL, � ��� ����� TAB � CRLF
  SkipDelimiters ParseWord
\  >IN 1+! \ ���������� ����������� �� ������
  >IN @ 1+ #TIB @ MIN >IN !   \ ��� ������������� � spf3.16
;

: PARSE ( char "ccc<char>" -- c-addr u ) \ 94 CORE EXT
\ �������� ccc, ������������ �������� char.
\ c-addr - ����� (������ �������� ������), � u - ����� ���������� ������.
\ ���� ����������� ������� ���� �����, �������������� ������ ����� �������
\ �����.
  CharAddr >IN @
  ROT SkipUpTo
  >IN @ SWAP -
  >IN 1+!
;

: SKIP ( char "ccc<char>" -- )
\ ���������� ����������� char.
  BEGIN
    DUP GetChar >R = R> AND
  WHILE
    >IN 1+!
  REPEAT DROP
;

\ PARSE � SKIP ��������� ��� �������������, ������ �� ������������
\ ��� ���������� ��������� ������
