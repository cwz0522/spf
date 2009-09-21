( �������� �� FIND-FILES-R - ~ac/lib/win/file/findfile-r.f, 26.01.03 �.�. )
( 20.09.09 ~pig )

\ ����������� ����� ��������� � ���������� 
\ ��������� �������� ��� ������� � ����������.
\ �������� ".." � "." ����� ������������, ���� ������� TRUE FIND-FILES.. !

\ �������� ������ �������������� ���
\ ����� - ������ ��������������� ����������� �������

\ xt ( addr u data flag -- ) - ��������� ���������� ��� ������� �����
\ addr u - ���� � ��� ����� ��� �������� (������ ��� open-file, etc)
\ flag=true, ���� �������, false ���� ����
\ data - ����� ��������� � ������� � ����� ��� ��������
\ ���� ��������� ��. � findile.f
\ ����� ������ xt ������ addr � ��������� data �������������,
\ �������, ���� xt ��������� ��������� ��� ������, ���� ����������.

REQUIRE FIND-FILES       ~ac/lib/win/file/FINDFILE.F
REQUIRE FIND-FILES-R     ~ac/lib/win/file/findfile-r.f
REQUIRE {                ~ac/lib/locals.f
REQUIRE STR@             ~ac/lib/str5.f
REQUIRE WildCMP-U        ~pinka/lib/mask.f

[UNDEFINED] Match-U [IF] VECT Match-U ' WildCMP-U TO Match-U [THEN]

: FIND-FILES-RP ( S" path" S" template" xt -- )
\ path - ��� �������� �������� ��� ������
\ template - ������ ����� �����
\ xt ( addr u data flag -- ) - ��������� ���������� ��� ������� �����

  { addr u tmpla tmplu xt \ addr2 data id f dir }

  u				\ ������ ���� ���������� ������ �������
  IF
    addr u 1- + C@ is_path_delimiter	\ ���� �� ����� ����, �� ��� ������
    IF u 1- -> u THEN		\ ���� ��� ������������ ��������
  THEN
  tmplu 0=			\ ���� ������ ������
  IF S" *.*" -> tmplu -> tmpla THEN	\ ����� ������� ���� ������

  FIND-FILES-RL @ 0= IF u FIND-FILES-U ! THEN	\ ����������� ����� �������� ���� ��� ���������� �����
  addr u " {s}/*.*" -> addr2	\ ����� ������ �� ���� ������
  /WIN32_FIND_DATA ALLOCATE THROW -> data
  data /WIN32_FIND_DATA ERASE
  data addr2 STR@ DROP FindFirstFileA -> id
  id -1 = IF data FREE DROP addr2 STRFREE EXIT THEN
  BEGIN
    data cFileName ASCIIZ> 2DUP IsNot.. FIND-FILES.. @ OR
    IF
      data dwFileAttributes @ FILE_ATTRIBUTE_DIRECTORY AND 0<> DUP -> dir	\ ���� �������
      ?DUP 0=
      IF
        tmpla tmplu S" *.*" COMPARE	\ *.* - ������ ������, � ��� ������������ ��
        IF 2DUP tmpla tmplu Match-U 0= ELSE TRUE THEN	\ ���� ���� �������� ��������� � ��������
      THEN
      IF
        addr u " {s}/{s}" DUP -> f STR@ data dir xt EXECUTE
        dir
        IF FIND-FILES-RL 1+!
           FIND-FILES-RL @ FIND-FILES-DEPTH @ < FIND-FILES-DEPTH @ 0= OR
           data cFileName ASCIIZ> IsNot.. AND
           IF
             tmpla tmplu f STR@ " {s}/{s}" DUP >R
             STR@ tmpla tmplu xt RECURSE
             R> STRFREE
           THEN
           -1 FIND-FILES-RL +!
           FIND-FILES-USE-RET @
           IF f STR@ 0 dir xt EXECUTE THEN
        THEN
        f STRFREE
      ELSE 2DROP THEN
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
\ : TT IF FIND-FILES-RL @ CELLS SPACES cFileName ASCIIZ> TYPE CR
\      ELSE DROP THEN 2DROP ;
\ 2 FIND-FILES-DEPTH !
\ : T S" c:\temp" S" *" ['] TT FIND-FILES-RP ; T
