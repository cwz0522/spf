( 26.01.03 �.�. )

\ ����������� ����� ��������� � ���������� 
\ ��������� �������� ��� ������� � ����������.
\ �������� ".." � "." � xt �� ����������.

\ xt ( addr u data flag -- ) - ��������� ���������� ��� ������� �����
\ addr u - ���� � ��� ����� ��� �������� (������ ��� open-file, etc)
\ flag=true, ���� �������, false ���� ����
\ data - ����� ��������� � ������� � ����� ��� ��������
\ ���� ��������� ��. � findile.f
\ ����� ������ xt ������ addr � ��������� data �������������,
\ �������, ���� xt ��������� ��������� ��� ������, ���� ����������.

REQUIRE FIND-FILES       ~ac/lib/win/file/findfile.f
REQUIRE {                ~ac/lib/locals.f
REQUIRE STR@             ~ac/lib/str2.f

USER FIND-FILES-RL \ ������� ����������� 0-...

: FIND-FILES-R ( addr u xt -- )
\ addr u - ��� �������� ��� ������
\ xt ( addr u data flag -- ) - ��������� ���������� ��� ������� �����

  { addr u xt \ addr2 data id f dir }

  addr u " {s}/*.*" -> addr2
  /WIN32_FIND_DATA ALLOCATE THROW -> data
  data /WIN32_FIND_DATA ERASE
  data addr2 STR@ DROP FindFirstFileA -> id
  id -1 = IF data FREE DROP addr2 STRFREE EXIT THEN
  BEGIN
    data cFileName ASCIIZ>
    2DUP 2DUP S" .." COMPARE 0<> ROT ROT S" ." COMPARE 0<> AND
    IF
      data dwFileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND 0<> -> dir
      addr u " {s}/{s}" DUP -> f STR@ data dir xt EXECUTE
      dir
      IF FIND-FILES-RL 1+!
         f STR@ xt RECURSE
         FIND-FILES-RL @ 1- FIND-FILES-RL !
      THEN
      f STRFREE
    ELSE 2DROP THEN
    data id FindNextFileA 0=
  UNTIL
  addr2 STRFREE
  id FindClose DROP
  data FREE DROP
;

\ ������ ������ ���� ���������
\ : TT NIP IF TYPE CR ELSE 2DROP THEN ;
\ ������ ���� ��������� �� ������� �� �������
: TT IF FIND-FILES-RL @ CELLS SPACES cFileName ASCIIZ> TYPE CR
     ELSE DROP THEN 2DROP ;
: T S" c:" ['] TT FIND-FILES-R ; T
