( �������� ����-�����.
  Windows-��������� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

: CLOSE-FILE ( fileid -- ior ) \ 94 FILE
\ ������� ����, �������� fileid.
\ ior - ������������ ����������� ��� ���������� �����/������.
  CloseHandle ERR
;

: CREATE-FILE ( c-addr u fam -- fileid ior ) \ 94 FILE
\ ������� ���� � ������, �������� c-addr u, � ������� ��� � ������������
\ � ������� ������� fam. ����� �������� fam ��������� �����������.
\ ���� ���� � ����� ������ ��� ����������, ������� ��� ������ ���
\ ������ ����.
\ ���� ���� ��� ������� ������ � ������, ior ����, fileid ��� �������������,
\ � ��������� ������/������ ���������� �� ������ �����.
\ ����� ior - ������������ ����������� ��� ���������� �����/������,
\ � fileid �����������.
  NIP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  CREATE_ALWAYS
  0 ( secur )
  0 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;

CREATE SA 12 , 0 , 1 ,

: CREATE-FILE-SHARED ( c-addr u fam -- fileid ior )
  NIP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  CREATE_ALWAYS
  SA ( secur )
  3 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: OPEN-FILE-SHARED ( c-addr u fam -- fileid ior )
  NIP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  OPEN_EXISTING
  SA ( secur )
  3 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;

: DELETE-FILE ( c-addr u -- ior ) \ 94 FILE
\ ������� ���� � ������, �������� ������� c-addr u.
\ ior - ������������ ����������� ��� ���������� �����/������.
  DROP DeleteFileA ERR
;

USER lpDistanceToMoveHigh

: FILE-POSITION ( fileid -- ud ior ) \ 94 FILE
\ ud - ������� ������� � �����, ���������������� fileid.
\ ior - ������������ ����������� ��� ���������� �����/������.
\ ud �����������, ���� ior �� ����.
  >R FILE_CURRENT lpDistanceToMoveHigh DUP 0! 0 R>
  SetFilePointer
  DUP -1 = IF GetLastError ELSE 0 THEN
  lpDistanceToMoveHigh @ SWAP
;

: FILE-SIZE ( fileid -- ud ior ) \ 94 FILE
\ ud - ������ � �������� �����, ���������������� fileid.
\ ior - ������������ ����������� ��� ���������� �����/������.
\ ��� �������� �� ������ �� ��������, ������������ FILE-POSITION.
\ ud �����������, ���� ior �� ����.
  lpDistanceToMoveHigh SWAP
  GetFileSize
  DUP -1 = IF GetLastError ELSE 0 THEN
  lpDistanceToMoveHigh @ SWAP
;

: OPEN-FILE ( c-addr u fam -- fileid ior ) \ 94 FILE
\ ������� ���� � ������, �������� ������� c-addr u, � ������� ������� fam.
\ ����� �������� fam ��������� �����������.
\ ���� ���� ������� ������, ior ����, fileid ��� �������������, � ����
\ �������������� �� ������.
\ ����� ior - ������������ ����������� ��� ���������� �����/������,
\ � fileid �����������.
  NIP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  OPEN_EXISTING
  0 ( secur )
  0 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;

USER lpNumberOfBytesRead

: READ-FILE ( c-addr u1 fileid -- u2 ior ) \ 94 FILE
\ �������� u1 �������� � c-addr �� ������� ������� �����,
\ ����������������� fileid.
\ ���� u1 �������� ��������� ��� ����������, ior ���� � u2 ����� u1.
\ ���� ����� ����� ��������� �� ��������� u1 ��������, ior ����
\ � u2 - ���������� ������� ����������� ��������.
\ ���� �������� ������������ ����� ��������, ������������
\ FILE-POSITION ����� ��������, ������������� FILE-SIZE ��� �����
\ ����������������� fileid, ior � u2 ����.
\ ���� �������� �������������� ��������, �� ior - ������������ �����������
\ ��� ���������� �����/������, � u2 - ���������� ��������� ���������� �
\ c-addr ��������.
\ �������������� �������� ���������, ���� �������� �����������, �����
\ ��������, ������������ FILE-POSITION ������ ��� ��������, ������������
\ FILE-SIZE ��� �����, ����������������� fileid, ��� ��������� ��������
\ �������� �������� ������������ ����� �����.
\ ����� ���������� �������� FILE-POSITION ��������� ��������� �������
\ � ����� ����� ���������� ������������ �������.
  >R >R >R
  0 lpNumberOfBytesRead R> R> SWAP R>
  ReadFile ERR
  lpNumberOfBytesRead @ SWAP
;

: REPOSITION-FILE ( ud fileid -- ior ) \ 94 FILE
\ ������������������� ����, ���������������� fileid, �� ud.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ �������������� �������� ���������, ���� ��������������� ���
\ ��� ������.
\ ����� ���������� �������� FILE-POSITION ���������� �������� ud.
  >R lpDistanceToMoveHigh ! FILE_BEGIN lpDistanceToMoveHigh ROT R>
  SetFilePointer
  -1 = IF GetLastError ELSE 0 THEN
;

HEX

CREATE LT 0A0D , \ line terminator
CREATE LTL 2 ,   \ line terminator length

: DOS-LINES ( -- )
  0A0D LT ! 2 LTL !
;
: UNIX-LINES ( -- )
  0A0A LT ! 1 LTL !
;

DECIMAL

USER Buf
USER Hdl

: READ-LINE ( c-addr u1 fileid -- u2 flag ior ) \ 94 FILE
\ �������� ��������� ������ �� �����, ��������� fileid, � ������
\ �� ������ c-addr. �������� �� ������ u1 ��������. �� ����
\ ������������ ����������� �������� "����� ������" ����� ����
\ ��������� � ������ �� ������ ������, �� �� �������� � ������� u2.
\ ����� ������ c-addr ������ ����� ������ ��� ������� u1+2 �������.
\ ���� �������� �������, flag "������" � ior ����. ���� ����� ������
\ ������� �� ���� ��� ��������� u1 ��������, �� u2 - ����� �������
\ ����������� �������� (0<=u2<=u1), �� ������ �������� "����� ������".
\ ����� u1=u2 ����� ������ ��� �������.
\ ���� �������� ������������, ����� ��������, ������������
\ FILE-POSITION ����� ��������, ������������� FILE-SIZE ��� �����,
\ ����������������� fileid, flag "����", ior ����, � u2 ����.
\ ���� ior �� ����, �� ��������� �������������� �������� � ior -
\ ������������ ����������� ��� ���������� �����-������.
\ �������������� �������� ���������, ���� �������� �����������, �����
\ ��������, ������������ FILE-POSITION ������ ��� ��������, ������������
\ FILE-SIZE ��� �����, ����������������� fileid, ��� ��������� ��������
\ �������� �������� ������������ ����� �����.
\ ����� ���������� �������� FILE-POSITION ��������� ��������� �������
\ � ����� ����� ���������� ������������ �������.
  SWAP LTL @ + SWAP
  2>R DUP Buf ! 2R>
  DUP Hdl !
  READ-FILE DUP IF ( ������ ������ ) 0 SWAP EXIT THEN DROP
  DUP IF ( ���-�� ������ ) ( ���������_���� )
         Buf @ OVER LT 1 SEARCH ( ���������_���� �����_�����_������ ��������_���� ���� )
         0= IF ( ����� ������ �� ������ - ����� ����� � ������� �����)
               2DROP -1 0 EXIT
            THEN
         ( ����� ������ ������ )
         ROT DROP ( ����� ���������_���� )
         ( �����_�����_������  �������� )
         LTL @ - ( �� ���������� CRLF )
         ?DUP IF
         0 DNEGATE
         Hdl @ FILE-POSITION ?DUP
         IF >R 2DROP 2DROP Buf @ - -1 R> EXIT THEN
         D+
         Hdl @ REPOSITION-FILE ?DUP IF  0 SWAP EXIT THEN
         THEN
         ( �����_�����_������ )
         Buf @ - -1 0
      ELSE ( ���� � ����� ����� ) 0 0 THEN
;


USER lpNumberOfBytesWritten

: WRITE-FILE ( c-addr u fileid -- ior ) \ 94 FILE
\ �������� u �������� �� c-addr � ����, ���������������� fileid,
\ � ������� �������.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ����� ���������� �������� FILE-POSITION ���������� ���������
\ ������� � ����� �� ��������� ���������� � ���� ��������, �
\ FILE-SIZE ���������� �������� ������� ��� ������ ��������,
\ ������������� FILE-POSITION.
  OVER >R
  >R >R >R
  0 lpNumberOfBytesWritten R> R> SWAP R>
  WriteFile ERR ( ior )
  ?DUP IF RDROP EXIT THEN
  lpNumberOfBytesWritten @ R> <>
  ( ���� ���������� �� �������, ������� �����������, �� ���� ������ )
;

: RESIZE-FILE ( ud fileid -- ior ) \ 94 FILE
\ ���������� ������ �����, ����������������� fileid, ������ ud.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ���� �������������� ���� ���������� ������, ��� �� ��������,
\ ����� �����, ����������� � ���������� ��������, ����� ����
\ �� ��������.
\ ����� ���������� �������� FILE-SIZE ���������� �������� ud
\ � FILE-POSITION ���������� �������������� ��������.
  DUP >R REPOSITION-FILE  ?DUP IF R> DROP EXIT THEN
  R> SetEndOfFile ERR
;

: WRITE-LINE ( c-addr u fileid -- ior ) \ 94 FILE
\ �������� u �������� �� c-addr � ����������� ��������� �� ���������� ������ 
\ ������ � ����, ���������������� fileid, ������� � ������� �������.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ����� ���������� �������� FILE-POSITION ���������� ���������
\ ������� � ����� �� ��������� ���������� � ���� ��������, �
\ FILE-SIZE ���������� �������� ������� ��� ������ ��������,
\ ������������� FILE-POSITION.
  DUP >R WRITE-FILE ?DUP IF R> DROP EXIT THEN
  LT LTL @ R> WRITE-FILE
;

: FLUSH-FILE ( fileid -- ior ) \ 94 FILE EXT
  FlushFileBuffers ERR
;

\ ������������ ����������-����������� �������  (layer)
\ ������ � �������� ������ (c) ~day 07.Feb.2001
0
CELL -- .shandle
CELL -- .sbuf
CELL -- .spos
CELL -- .s#tib
CELL -- .sreadxt
CONSTANT /STREAM

512 VALUE RSTREAM-BUF

: HANDLE>RSTREAM ( h -- s )
   /STREAM DUP ALLOCATE THROW DUP 
   ROT ERASE >R
   R@ .shandle !
   RSTREAM-BUF ALLOCATE THROW R@ .sbuf !
   R>
;

: HANDLE>RSTREAM-WITH ( h xt -- s )
   SWAP HANDLE>RSTREAM
   TUCK .sreadxt !
;

: FILE>RSTREAM ( h -- s )
   ['] READ-FILE
   HANDLE>RSTREAM-WITH
;

: REFILL-RSTREAM ( s -- u ior )
\ �������� �����
  DUP >R
  .sbuf @
  RSTREAM-BUF
  R@ .shandle @
  R@ .sreadxt @ EXECUTE OVER
  R@ .s#tib !
  R> .spos 0!
;

: FREE-RSTREAM ( s -- h )
   DUP >R .shandle @
   R@ .sbuf @ FREE THROW
   R> FREE THROW
;

: STREAM-FILE ( s -- h )
    @
;

USER-VALUE _s
USER-VALUE _buf
USER-VALUE _pos
USER-VALUE _#tib

: READ-RSTREAM-LINE  ( addr u s -- u1 flag ior )
   TO _s 2>R
   _s .sbuf @ TO _buf
   _s .s#tib @ DUP TO _#tib
   _s .spos @ DUP TO _pos 
   =
   IF \ ����� ��������
     _s REFILL-RSTREAM ?DUP IF 0 SWAP RDROP RDROP EXIT THEN
      \ ��������� 0
     0 TO _pos
     DUP TO _#tib
     0= IF 0. 0 RDROP RDROP EXIT THEN
   THEN
   _buf _pos + DUP
   _#tib _pos -
   LT 1+ 1 SEARCH
   IF
     DROP OVER - R> MIN >R
     2R@ QCMOVE
     \ �� ������ ���� ����������� �������� ������ ��� ����� ������
     R@ _buf _pos + R@ + C@ 10 = IF 1+ THEN _s .spos +!
     2R@ SWAP OVER + 1- C@ 13 = IF 1- THEN -1 0
     RDROP RDROP
   ELSE \ ��� LF
     \ �������� ��� ��� �����
     2DROP R@ SWAP CELL RP+@ ( addr) _#tib _pos - R@ MIN DUP >R QCMOVE
     _#tib _pos - 1+ <  ( _#tib _pos - u > )
     IF \ ���� ����� - ������ ��� �����, ���� � ����� ���
        R> DUP _s .spos +!
        RDROP RDROP -1 0 EXIT
     THEN
     _#tib _s .spos !
     R@ 8 RP+@ ( addr) OVER +
     CELL RP+@ ( u) ROT - _s RECURSE
     \ ��������� ��������� ��������
     ROT R> + ROT DROP -1 ( ���-�� ����������) ROT RDROP RDROP
   THEN
;

: READ-RSTREAM ( c-addr u1 fileid -- u2 ior )
   DUP >R
   .s#tib @ DUP TO _#tib
   R@ .spos @ DUP TO _pos
   =
   IF \ ����� ����
     R@ REFILL-RSTREAM ?DUP IF >R NIP NIP R> RDROP EXIT THEN
     0 TO _pos
     DUP TO _#tib
     0= IF 2DROP RDROP 0 0 EXIT THEN
   THEN
   \ �������� ��� ��� ���� � ������
   2DUP SWAP R@ .sbuf @ _pos + SWAP ROT _#tib _pos - MIN DUP >R QCMOVE
   DUP R@ > \ ��������� ������?
   IF
     R@ - SWAP R@ + SWAP \ ���� ��� ���������
     CELL RP+@ ( s) DUP .shandle @ SWAP .sreadxt @ EXECUTE
     SWAP R> + SWAP _#tib R> .spos !
   ELSE
     2DROP 2R> TUCK SWAP .spos +! 0
   THEN 
;
