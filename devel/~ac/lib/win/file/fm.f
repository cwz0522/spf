\ ����������� ������ �� ���������� �������� ������
\ � ������������ ���������� ����� ����������� ����������

REQUIRE base64 ~ac/lib/string/conv.f 

WINAPI: CreateFileMappingA KERNEL32.DLL
WINAPI: MapViewOfFile      KERNEL32.DLL
WINAPI: UnmapViewOfFile    KERNEL32.DLL
WINAPI: FlushViewOfFile    KERNEL32.DLL \ Win2000

DECIMAL
4 CONSTANT PAGE_READWRITE
2 CONSTANT FILE_MAP_WRITE
1 CONSTANT FILE_SHARE_READ
2 CONSTANT FILE_SHARE_WRITE

0 VALUE MAP-BASE

: MAP-FILE ( size c-addr u -- fileid objid mapbase ior )
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
  MapViewOfFile DUP TO MAP-BASE
  IF R> R> SWAP 0
  ELSE R> R> GetLastError THEN
  MAP-BASE SWAP
;
: UNMAP-FILE ( fileid objid mapbase -- ior )
\ ��������� ����������� ����� � ������� ����.
  UnmapViewOfFile
  0= IF 2DROP GetLastError EXIT THEN
  CLOSE-FILE ?DUP IF NIP EXIT THEN
  CLOSE-FILE
;
: FLUSH-MAP ( -- )
  0 MAP-BASE FlushViewOfFile DROP
;
( ������:
  40000 S" TEST.MAP" MAP-FILE THROW
  MAP-BASE 40000 CHAR * FILL  UNMAP-FILE THROW
)