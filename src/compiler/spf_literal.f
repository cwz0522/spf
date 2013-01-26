\ $Id$

( �������������� �������� ��������� ��� �������������.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

: ?SLITERAL1 ( c-addr u -> ... )
  \ ������������� ������ � �����
  0 0 2SWAP
  OVER C@ [CHAR] - = DUP >R IF 1 - SWAP CHAR+ SWAP THEN
  DUP 1 > IF
    2DUP CHARS + CHAR- C@ [CHAR] . = DUP >R IF 1- THEN
  ELSE 0 >R THEN
  DUP 0= IF -2001 THROW THEN \ ������� ����� ������ ����
  >NUMBER NIP IF -2001 THROW THEN \ ABORT" -?"
  R> IF
       R> IF DNEGATE THEN
       [COMPILE] 2LITERAL
  ELSE D>S
       R> IF NEGATE THEN
       [COMPILE] LITERAL
  THEN
;
: ?LITERAL1 ( T -> ... )
  \ ������������� ������ � �����
  COUNT ?SLITERAL1
;
: HEX-SLITERAL ( addr u -> flag )
  BASE @ >R HEX
  0 0 2SWAP 2- SWAP 2+ SWAP >NUMBER
  ?DUP IF
    1 = SWAP C@ [CHAR] L = AND 0= IF 2DROP FALSE R> BASE ! EXIT THEN
  ELSE DROP THEN
  D>S POSTPONE LITERAL TRUE
  R> BASE !
;
: ?SLITERAL2 ( c-addr u -- ... )
  ( ����������� ������� ?SLITERAL1:
    ���� ������ - �� �����, �� �������� ���������� �
    ��� ��� ����� ��� ����-INCLUDED)
  DUP 1 > IF OVER W@ 0x7830 ( 0x) = 
    IF 2DUP 2>R HEX-SLITERAL IF RDROP RDROP EXIT ELSE 2R> THEN THEN
  THEN
  2DUP 2>R ['] ?SLITERAL1 CATCH
  0= IF RDROP RDROP EXIT THEN
  2DROP 2R>

  DUP 0 U> IF ( �� ������ )
       OVER C@ [CHAR] " = OVER 2 > AND
       IF 2 - SWAP 1+ SWAP THEN ( ����� �������, ���� ����)
       2DUP + 0 SWAP C!
       2DUP FILE-EXISTS
  IF ( ��� �����, � �� ���� )
       ['] INCLUDED CATCH
       DUP 2 <> OVER 3 <> AND OVER 161 <> AND
       ( ���� �� ������ ��� ���� �� ������,
       ��� ������������� ��� �����)
       IF THROW EXIT THEN
  THEN THEN ( c-addr u | ior )
  -2003 THROW \ ABORT"  -???"
;
: ?LITERAL2 ( c-addr -- ... )
  ( ����������� ������� ?LITERAL1:
    ���� ������ - �� �����, �� �������� ���������� �
    ��� ��� ����� ��� ����-INCLUDED)
  COUNT ?SLITERAL2
;
