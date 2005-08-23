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
  ����� ����� �������, ������� � ����. ����� � ������� �������-�������
  ����� ������������, �������������� ������� ���������� SELECT-��������.
  ������� � ���� ������� ������ ������� � ������������.

  ����� ������� �������� ������:
  world.db3 Country RU
  ������� � �������� ���������� ���� ��� �� ���������, ��� �
  SQL-������ "SELECT * FROM Country WHERE ID='RU'"

  ����� "@" � "." � ���� ���������� �������������� ��� ����������
  � ������ ��������� �������� "����������� �����" ��������������.

  ���������� ��� � ���������, ������� ������� � ����� �� ���������.
)

REQUIRE db3_open ~ac/lib/lin/sql/sqlite3.f 

ALSO sqlite3.dll

: DB_SELECT { addr u sqh \ pzTail ppStmt -- ppStmt }
  addr u CONTEXT @ OBJ-NAME@ " SELECT * FROM {s} WHERE CODE='{s}'"
  STR@ 2DUP TYPE CR sqh db3_prepare -> ppStmt -> pzTail
  ppStmt db3_bind

  BEGIN \ ���� ������������ ������� � ��
    ppStmt 1 sqlite3_step DUP SQLITE_BUSY =
  WHILE
    DROP 1000 PAUSE
  REPEAT

  DUP 1 SQLITE_ROW WITHIN IF S" DB3_STEP" sqh db3_error? THEN

  SQLITE_ROW = IF ppStmt DUP . ELSE 0 THEN
;
: DB_RESET ( stmt -- )
  DUP 1 sqlite3_reset THROW  1 sqlite3_finalize THROW
;
PREVIOUS

<<: FORTH SQLITE3_TABLE

: SHEADER ( addr u -- )
  TYPE ." to implement - INSERT :)"
;
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ������ � ID='c-addr u' � ������� oid

\ ������� ���� � ������� ������, ����� �� ������ �������� ������ � ��...
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN
  
  oid PAR@ OBJ-DATA@ DUP \ sqh
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
>> CONSTANT SQLITE3_TABLE-WL

: DB>TABLE ( addr u -- )
2DUP TYPE ." : "
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
Country RUS .
USA .
\ world.db3 Country ROS \ ���� -2003
ORDER
PREVIOUS
