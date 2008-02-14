( ��������� WIN32_FIND_DATA ��� ��������� ����� ��� ��������.

  Filetime.f ��� ��������� ������� ����������� ����� ������� �����
  �����, ��� "������" � ��������� ����������� ������ � ����������.
  ������ ���������� ��������� ���������� - ��������� ������� filetime
  � ��� ���������, ����� ��� � ��� ������, ��� �� ��������. � �������
  ����������� ���/������ �������� �� filetime.f, c�. ������� ����.

)

REQUIRE ftLastWriteTime ~ac/lib/win/file/findfile-r.f 

: GET-FILE-PROPS ( addr u xt -- )

\ addr u - ��� ����� ��� ��������
\ xt ( addr u data -- ) - ��������� ���������� ��� 
\                         ��������� ������ �����/��������
\ �������������� ������ ���� ����, ���� �������� �� addr u.

  { addr u xt \ data id }
  /WIN32_FIND_DATA ALLOCATE THROW -> data
  data /WIN32_FIND_DATA ERASE
  data addr FindFirstFileA -> id
  id -1 = IF data FREE DROP EXIT THEN
  data cFileName ASCIIZ>
  data xt EXECUTE
  id FindClose DROP
  data FREE DROP
;
: (GET-FILETIME-WRITE-S) ( 0 0 addr u data -- filetime )
  ftLastWriteTime 2@ SWAP 2>R
  2DROP 2DROP ( ������ addr u � 0 0 )
  2R>
;
: GET-FILETIME-WRITE-S  ( addr u -- filetime ) \ UTC
  0 0 2SWAP ['] (GET-FILETIME-WRITE-S) GET-FILE-PROPS
;

\EOF
filetime.f
S" ." GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" fileprop.f" GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" fileprop.f" R/O OPEN-FILE-SHARED THROW GET-FILETIME-WRITE UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
