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
  SWAP DROP SWAP >R >R
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
  SWAP DROP SWAP >R >R
  0 FILE_ATTRIBUTE_ARCHIVE ( template attrs )
  CREATE_ALWAYS
  SA ( secur )
  3 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
;
: OPEN-FILE-SHARED ( c-addr u fam -- fileid ior )
  SWAP DROP SWAP >R >R
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
  SWAP DROP SWAP >R >R
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
  >R >R DUP Buf ! R> R>
  DUP Hdl !
  READ-FILE ?DUP IF ( ������ ������ ) 0 SWAP EXIT THEN
  DUP IF ( ���-�� ������ ) ( ���������_���� )
         DUP
         Buf @ SWAP LT 1 SEARCH ( ���������_���� �����_�����_������ ��������_���� ���� )
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
         Hdl @ REPOSITION-FILE ?DUP IF 0 SWAP EXIT THEN
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
