( ��������� WIN32_FIND_DATA ��� ��������� ����� ��� ��������.

  Filetime.f ��� ��������� ������� ����������� ����� ������� �����
  �����, ��� "������" � ��������� ����������� ������ � ����������.
  ������ ���������� ��������� ���������� - ��������� ������� filetime
  � ��� ���������, ����� ��� � ��� ������, ��� �� ��������. � �������
  ����������� ���/������ �������� �� filetime.f, c�. ������� ����.

)

REQUIRE ftLastWriteTime ~ac/lib/win/file/findfile-r.f 

: FOR-FILE1-PROPS ( addr u xt -- )

\ addr u - ��� ����� ��� ��������
\ xt ( addr u data -- ) - ��������� ���������� ��� 
\                         ��������� ������ �����/��������
\ �������������� ������ ���� ����, ���� �������� �� addr u.

  NIP SWAP
  /WIN32_FIND_DATA RALLOT >R
  R@ SWAP FindFirstFileA ( xt id )
  DUP -1 = IF 2DROP ELSE FindClose DROP ( xt )
  R@ cFileName ASCIIZ> ( xt a u ) ROT R@ SWAP EXECUTE
  THEN RDROP
  /WIN32_FIND_DATA RFREE
; 
: (GET-FILETIME-WRITE-S) ( 0 0 addr u data -- filetime )
  ftLastWriteTime 2@ SWAP 2>R
  2DROP 2DROP ( ������ addr u � 0 0 )
  2R>
;
: GET-FILETIME-WRITE-S  ( addr u -- filetime ) \ UTC
  0 0 2SWAP ['] (GET-FILETIME-WRITE-S) FOR-FILE1-PROPS
;

\EOF
filetime.f
S" ." GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" fileprop.f" GET-FILETIME-WRITE-S UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
S" fileprop.f" R/O OPEN-FILE-SHARED THROW GET-FILETIME-WRITE UTC>LOCAL FILETIME>TIME&DATE . . . . . . CR
