( ~ac 23.08.2005
  $Id$

  ����������� ������� SQLite3 ��� ������ [�� ����� �����] �
  �������� ������������ ����-�������. � ���������� �������
  �������� ��� ��������� ������������ ����� ��������������� 
  �����, ��� ������������� ������������� ����� SQL � ����������� API.

  �������������:
  ALSO SQLITE3_DB NEW: world.db3
  - ������� �������, ����������� � ���������� ����� ��, �������
  �� �� ���, � ��������� ���� ������� � �������� ������.
  ����� ���������� ����� ����� ������������ ��������� ����� -
  ��� �� ������������� ���������� � ����� ��� ������ � VIEWS �����
  ������������� ���, ��� ���� �� ��� ��� "����������" ����-�������.
  ���������� ��������� ������� �������� ������� ������� ���������
  ������ �� ��������� ������� ��������� ������� [��� VIEW],
  ��� ���� �� ��� ���� ���� ���������� ����� VOCABULARY, � ���������� 
  ����� ����� �������, ������� � ����. ����� � ������� �������
  �������� � ������ ������� ������� ��������� �� ROW-������� -
  ������� ����� ��� ���� ��������� ������ ��������� ���� �������,
  �� �������� ����� ������ ������������� ���������� �����.
  ����� � ������� ROW-������� ����� ������������, �������������� 
  ������� ���������� SELECT-��������.
  todo: ������� � ���� ������� ������ ������� � ������������.

  ����� ������� �������� ������:
  world.db3 Country CODE RU
  ������� � �������� ���������� ���� ��� �� ���������, ��� �
  SQL-������ "SELECT * FROM Country WHERE CODE='RU'"

  ����� "@" � "." � ���� ���������� �������������� ��� ����������
  � ������ ��������� �������� "����������� �����" ��������������.

  ���������� ��� � ���������, ������� ������� � ����� �� ���������.
)

REQUIRE db3_open ~ac/lib/lin/sql/sqlite3.f 

ALSO sqlite3.dll

: DB_SELECT { addr u sqh \ ppStmt -- ppStmt }
  addr u CONTEXT @ OBJ-NAME@  CONTEXT @ PAR@ OBJ-NAME@ 
  " SELECT * FROM {s} WHERE {s}='{s}'"
  STR@ 2DUP TYPE CR sqh db3_car -> ppStmt
;
: DB_RESET ( stmt -- )
  db3_fin
;
PREVIOUS

<<: FORTH SQLITE3_ROW
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ������ � oid='c-addr u' � ������� oid_par

\ ������� ���� � ������� ������, ����� �� ������ �������� ������ � ��...
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN
  
  oid PAR@ PAR@ OBJ-DATA@ DUP \ sqh
  IF c-addr u ROT DB_SELECT DUP 
     IF \ ������ ���� � �������� ������
        ( ������ � oid ��� � CONTEXT ?! - ������ �������� �������� ...)
        \ oid
        CONTEXT @
        OBJ-DATA! ['] NOOP 1
     THEN
  THEN
;
: . ( -- )
  1 0 CONTEXT @ ?DUP
  IF OBJ-DATA@ db3_dump DROP
     CONTEXT @ OBJ-DATA@ DB_RESET
     0 CONTEXT @ OBJ-DATA!
  ELSE 2DROP THEN
;
: PREVIOUS PREVIOUS ;
: \ POSTPONE \ ;
: .. .. ;
>> CONSTANT SQLITE3_ROW-WL

: TABLE>ROW ( addr u -- )
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  SQLITE3_ROW-WL R@ CLASS!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;

<<: FORTH SQLITE3_TABLE

: SHEADER ( addr u -- )
  TYPE ." to implement - INSERT :)"
;
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� � ������� ������� ���� � ������ c-addr u � �� oid � ������� ��� 
\ ������� (������� �������� � ���������� ������).

\ ������� ���� � ������� ������
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN

  oid OBJ-NAME@ NIP DUP
  IF \ ����� �������� �������� ������� �� �������� ������
     \ �.�. ������ �������� ��� ��������� ����
     DROP c-addr u TABLE>ROW ['] NOOP 1
  THEN
;
: PREVIOUS PREVIOUS ;
: \ POSTPONE \ ;
: .. .. ;

>> CONSTANT SQLITE3_TABLE-WL

: DB>TABLE ( addr u -- )
  TEMP-WORDLIST >R
  R@ OBJ-NAME!
  SQLITE3_TABLE-WL R@ CLASS!
  CONTEXT @ R@ PAR!
  R> CONTEXT !
;

<<: FORTH SQLITE3_DB

: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ������� � ������ c-addr u � �� oid � ������� ��� ������� �������.

  oid OBJ-DATA@ \ sqh; ���� �� ���������� - ���������
  0= IF oid OBJ-NAME@ " {s}" STR@ db3_open oid OBJ-DATA! THEN

  oid OBJ-DATA@ DUP
  IF \ ������� �������, ������ ����� �������� �������� �� �������-�������
     \ �.�. ������ ������ �������� � ���
     DROP c-addr u DB>TABLE ['] NOOP 1
  THEN
;
:>>

ALSO SQLITE3_DB NEW: world.db3
Country CODE RUS .
USA .
\ world.db3 Country CODE ROS \ ���� -2003
.. .. 
CountryLanguage CountryCode RUS .
PREVIOUS ORDER
