\ ��������� �����������. ��������� ��������� �������� �� ��������� (���������).
\ ����������� ����� ������������� ������� � �������������� ������ ��� ��� ����.
\ ��� �������� ��������� �������� �������� (HERE) ��������� �� ����������.

\ � ���������� �� ��������:
\ 1. ����� ������� ����� �� ������� (��������, � colorForth'�, ��� ��� ���� �������
\ ���������, ����� �� ������� �������� ����� (!) ���������� �������� ��������).
\ 2. ������������ ��������� ��������� �������� (��������, ��������� ���������� ���� 
\ �����, ���� �����).
\ 3. ����� ����� "��������" ��������� �������� �� ��������������� ����������� ����.
\ 4. ����������, ��������� ����������� ��� �������� ������ (������ ��. �����). �� �����
\ ����, ��� �� ��� �� � �������, �� ��� ������� �������� ��������������� (�������)
\ ������� �������� ����� -- ����� ���������.

\ �������� (TODO):
\ ���� ����������� (voc) � ������������� (imm) ���������� ���� ��� ������ ��� �������.
\ ��� ��� IMMEDIATE � VOCABULARY �����, �� ���� �� ������������� ~ac\lib\ns\ns.f
\ �� ��� �� ����� ������� DOES> ��� �����.

\ ����� �� �������� ������ �� ������ (� ����� ���?), ��� prevWord lastWord ?VOC CAR CDR

\ REQUIRE SEE lib/ext/disasm.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE HASH@ ~pinka/lib/hash-table.f
REQUIRE INVOKE ~ac/lib/ns/ns.f
REQUIRE __ ~profit/lib/cellfield.f
REQUIRE /TEST ~profit/lib/testing.f

MODULE: cascadedColons

0
__ lastWord \ ��������� ��� ������� �� ������
__ hash
CONSTANT vocSize

\ ��������� ������
0
__ prevWord
__ imm
__ voc
__ xt
CONSTANT wordSize

EXPORT

<<: FORTH cascaded

\ ������ ��������� ������
: SHEADER ( addr u -- )
\ CR ." SHEADER: " 2DUP TYPE
GET-CURRENT OBJ-DATA@
?DUP 0= IF big-hash DUP GET-CURRENT OBJ-DATA! THEN \ ���� ����� -- ������
( addr u h ) ROT wordSize SWAP 2SWAP ( wordSize addr u h )
HASH!R
DUP prevWord 0!
DUP imm 0!
DUP voc 0!
HERE OVER xt !
DROP ;

: SEARCH-WORDLIST ( c-addr u oid -- 0 | xt 1 | xt -1 )
\ >R 2DUP CR TYPE R>
OBJ-DATA@ DUP IF HASH@R DUP IF DUP imm @ IF 1 ELSE -1 THEN SWAP xt @ SWAP THEN ELSE NIP NIP THEN ;

>> CONSTANT cascaded-wl

;MODULE

MODULE: dontHide \ �� ������� (HIDE SMUDGE) ��� ������������� � ������ ������ �����

:NONAME HEADER ] ;

:NONAME ( -- )
  RET, [COMPILE] [
  ClearJpBuff
  0 TO LAST-NON
;

->VECT ; IMMEDIATE \ ���������� ��� ����� ����� ������� ����� �����
->VECT : IMMEDIATE \ ����� �� ��������� � ��� �����

;MODULE

/TEST

ALSO dontHide
ALSO cascaded NEW: casc DEFINITIONS

: 2*2. 2
: 2*. 2 *
: dot . ;

\ lib/ext/disasm.f SEE 2*2.
$> 2*2.
$> 5 2*.
$> 12 dot
$> 10 CONSTANT ten ten .