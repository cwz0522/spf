( ���������� ����� "����-����������" � ���� ��������������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

0 CONSTANT FALSE ( -- false ) \ 94 CORE EXT
\ ������� ���� "����".

-1 CONSTANT TRUE ( -- true ) \ 94 CORE EXT
\ ������� ���� "������", ������ �� ����� �������������� ������.

4 CONSTANT CELL

: */ ( n1 n2 n3 -- n4 ) \ 94
\ �������� n1 �� n2, �������� ������������� ������� ��������� d.
\ ��������� d �� n3, �������� ������� n4.
  */MOD NIP
;
: CHAR+ ( c-addr1 -- c-addr2 ) \ 94
\ ��������� ������ ������� � c-addr1 � �������� c-addr2.
  1+
;
: CHARS ( n1 -- n2 ) \ 94
\ n2 - ������ n1 ��������.
; IMMEDIATE

: MOVE ( addr1 addr2 u -- ) \ 94
\ ���� u ������ ����, ���������� ���������� u ���� �� addr1 � addr2.
\ ����� MOVE � u ������ �� ������ addr2 ���������� � �������� �� ��,
\ ��� ���� � u ������ �� ������ addr1 �� �����������.
  >R 2DUP SWAP R@ + U< \ ���������� �������� � �������� ��������� ��� �����
  IF 2DUP U<           \ � �� �����
     IF R> CMOVE> ELSE R> QCMOVE THEN
  ELSE R> QCMOVE THEN
;
: ERASE ( addr u -- ) \ 94 CORE EXT
\ ���� u ������ ����, �������� ��� ���� ������� �� u ���� ������,
\ ������� � ������ addr.
  0 FILL
;
: DABS ( d -- ud ) \ 94 DOUBLE
\ ud ���������� �������� d.
  DUP 0< IF DNEGATE THEN
;

: HASH ( addr u u1 -- u2 )
   2166136261 2SWAP
   OVER + SWAP 
   ?DO
      16777619 * I C@ XOR
   LOOP
   SWAP ?DUP IF UMOD THEN   
;

0  VALUE  DOES-CODE
