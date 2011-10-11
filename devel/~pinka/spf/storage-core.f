\ Dec.2006, ruvim@forth.org.ru

( ������ � ���������� ����� ��������� ������ � ����������� �������, ��� FS,
  �� ������������ � ��������������.

  ������, �������������� ��� ������� � ���������
  ���������� �������� ����, ������������� ��� � ������,
  ��� �� ALLOT, ',', 'C,', 'LIT,', '2LIT,' 'SLIT,' � �.�.
  ���� ������ �������� � �������������� � ���� ����������.
  ����������� �������� �������� MOUNT [ h -- ],
  ���������� -- �������� DISMOUNT  [ -- h ], /���, ����� UNMOUNT ?/
  ���������� ������ ����� ������ � ���� ��������� -- �������� FORMAT [ addr u -- h ].
  ����� MOUNT ����� ������������ ���� ����������� ������ �����������,
  ���� �� ��� �����.

  ������������� ���� ������� ������������ ������������� � ����������
  ����� �������� ������������� [������������] �����������
  [Scattering a Colon Definition].
)


( ������ ������������ ����������� ����-���������� DP � STORAGE
  � ������� � �������������.
)

: AT-MOUNTING    ( -- ) ... ;
: AT-DISMOUNTING ( -- ) ... ;
: AT-FORMATING   ( -- ) ... ;
\ ����� ������������ ������ �������,
\ ������� ��������� ���|��� �������� �������.


: STORAGE-ID ( -- h )
  STORAGE @
;
: (DISMOUNT) ( -- h dp )
  STORAGE @  DP @
;
: (MOUNT) ( h dp -- )
  DP !  STORAGE !
;
: (FORMAT) ( addr u -- h )
  DUP 64 CELLS U< ABORT" storage too small to format"
  OVER 4 CELLS 2DUP ERASE
  OVER + SWAP !           \ <!-- 0, dp   -->
                          \ <!-- 1, ext-cell -->
                          \ <!-- 2, dstack -->
  OVER + OVER 3 CELLS + ! \ <!-- 3, bound -->
;
: FORMAT ( addr u -- h )
  (DISMOUNT) 2>R
  (FORMAT) DUP @ (MOUNT)  AT-FORMATING   (DISMOUNT) OVER ! ( h )
  2R> (MOUNT)
;
: DISMOUNT ( -- h )
  STORAGE @ DUP IF
    DP @ 255 U> IF AT-DISMOUNTING  (DISMOUNT) SWAP ! THEN
    DP 0! STORAGE 0!
  THEN
;
: MOUNT ( h -- )
  DUP STORAGE-ID = IF DROP EXIT THEN
  DISMOUNT DROP
  DUP IF DUP @  (MOUNT)  AT-MOUNTING  EXIT THEN DROP
;
: MOUNT-RO ( h -- ) \ mounts for read-only
\ it skips AT-MOUNTING and then AT-DISMOUNTING for given storage
  DISMOUNT DROP
  DUP IF 0 (MOUNT) EXIT THEN DROP
;
: PUSH-MOUNT ( h -- ) \ ��������� � ������ ��������� �� ����� ��� ��������
  DISMOUNT OVER CELL+ CELL+ !
  MOUNT
;
: POP-MOUNT ( -- h )
  DISMOUNT DUP CELL+ CELL+ @ MOUNT
;
: UNUSED ( -- u ) \ 94 CORE EXT
  STORAGE-ID DUP IF 3 CELLS + @   DP @ - THEN
;
: STORAGE-REST ( -- a u ) \ free space
  DP @ UNUSED
;
: STORAGE-CONTENT ( -- a u ) \ busy space
  STORAGE-ID DP @ OVER -
;
: CODESPACE-CONTENT ( -- a u )
  STORAGE-CONTENT
;
: FLUSH-STORAGE ( -- )
  DISMOUNT MOUNT
;
: STORAGE-EXTRA ( -- a ) \ ��� ����������; ���������������� ������ ��������� �����������.
  STORAGE-ID CELL+
;