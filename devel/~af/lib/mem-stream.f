\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ ����� � ��᪮� �������᪮� ����� ��� � ��⮪��.
\ ������ ������ ���� � �㫥�� ���⮬ � ����.
\ ��㦥���� �祩�� �ᯮ������ ��� 㪠��⥫� ��᫥����� ���⠭���� ����.

REQUIRE FStream          ~af\lib\stream_io.f
REQUIRE [DEFINED]        lib\include\tools.f

: READ-MEM ( c-addr u1 hmem -- u2 ior=0 )
\ ��⮪���� �⥭�� �� �����
  CELL- DUP >R @
  TUCK + OVER
  BEGIN  2DUP > OVER C@ AND  WHILE  1+  REPEAT
  NIP DUP R> !
  OVER - >R SWAP R@ MOVE
  R> 0
;
: MEM>RSTREAM ( hmem -- s )
  DUP DUP CELL- ! \ 㪠��⥫� ⥪�饩 ����樨
  ['] READ-MEM
  FStream::HANDLE>STREAM-WITH
;
: INCLUDE-MEM ( i*x hmem -- j*x )
  BLK 0!
  MEM>RSTREAM DUP >R
  [ ALSO FStream ] 
    ['] READ-LINE
    ['] TranslateFlow RECEIVE-WITH-XT
    R> CLOSE-STREAM THROW
  [ PREVIOUS ] 
  THROW
;
: INCLUDED-MEM ( i*x hmem c-addr u -- j*x )
  CURFILE @ >R
  HEAP-COPY CURFILE !
  INCLUDE-MEM
  CURFILE @ FREE THROW
  R> CURFILE !
;
