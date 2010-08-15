REQUIRE MAP-FILE ~ac/lib/win/file/fm.f 
\ ����������� ������ �� ���������� �������� ������
\ � ������������ ���������� ����� ����������� ����������

\ � ������� �� fm.f ����� �� ������������ ���������� ���������� MAP-BASE

: MAP-FILE2 ( size c-addr u -- fileid objid mapbase ior )
\ ���������� ���� � ������ c-addr u � �������� ������������ ��������
\ ������� � ���������� �������� ������. ������� �������� �����
\ �� �������� 0 �������� size.
\ ������������ ��� ������ ior ��� ����, ����� ����������� mapbase,
\ ������ �������-����������� � �������-������������� �����.
  OVER >R
  2DUP R/W OPEN-FILE-SHARED      ( size c-addr u fileid ior )
  IF DROP R/W CREATE-FILE-SHARED
  ELSE NIP NIP 0 THEN        ( size fileid ior )
  ?DUP IF NIP R> SWAP 0 SWAP EXIT THEN \ �� ������� �������/������� ����
                     ( size fileid )
  R> SWAP >R
  ASCIIZ> base64 DROP
  OVER               ( size name size )
  0                  ( size name sizelow sizehigh=0 )
  PAGE_READWRITE     \ protection
  0                  \ security
  R@                 \ fileid
  CreateFileMappingA
  DUP 0= IF R> GetLastError EXIT THEN
                     ( size objid )
  >R                 ( R: fileid objid )
  0 0                \ offset
  FILE_MAP_WRITE     \ access
  R@                 \ objid
  MapViewOfFile R> R> ROT DUP >R
  IF SWAP 0
  ELSE GetLastError THEN
  R> SWAP
;
: FLUSH-MAP2 ( mapbase -- )
  0 SWAP FlushViewOfFile
  0= IF GetLastError ." FLUSH-MAP2 ERR=" . CR THEN
;
