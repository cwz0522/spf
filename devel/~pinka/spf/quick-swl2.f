\ 07.Jan.2004 ruv
\ 06.Feb.2004
\ $Id$

( ���������� SPF [������� �� ����������!]
   ��������� ������� ����� �� ������� �� ���� ������������� ���-������.

  ���-������� ��������� �����������, �� SAVE �� �����������.

  �����������:
    ���-������� ������������� � ����� ���� ��������
    [����� �������� HEAP-ID  ~pinka/spf/mem.f]
    �������� ������, ���� �� ������ FREE-WORDLIST �� ������ TEMP-WORDLIST
    �������������� ��������, ���� ��� ���������� � ��������� �������
     ������ ����� ������� ����� �� ����� �������.
)

( �������������� FREE-WORDLIST  � MARKER /���� �� ����/
  �������, ������� ���������� quick-swl.f �� ����, 
   ��� ��� ����� ����� ���� ������������ � ������������.
  [ � ��� �����, �� locals.f ]

  �������� ������ SEARCH-WORDLIST - ����� ������ � ����������� �������� SPF
  ���������� ������ "����� �������" � ��������� �������
  ��� �������� ������ �� ������-���������.
)

REQUIRE HEAP-ID     ~pinka\spf\mem.f
REQUIRE [UNDEFINED] lib\include\tools.f
REQUIRE HASH!       ~pinka\lib\hash-table.f 

MODULE: QuickSWL-Support

EXPORT

 1024 VALUE #WL-HASH
 \ ������ ���-������� 

DEFINITIONS

0 \ ext header  for wordlist
 1 CELLS -- .hash
 1 CELLS -- .last
 1 CELLS -- .wid
CONSTANT /exth

: wid-exth ( wid -- exth )
  3 CELLS +  \ ����������� ������ "����� �������"
  DUP @   DUP IF  NIP EXIT THEN  DROP
  ( ~wid )

  HEAP-ID >R  HEAP-GLOBAL
  /exth ALLOCATE THROW
  SWAP 2DUP !    ( exth ~wid )
  3 CELLS - OVER .wid ! ( exth )
  #WL-HASH  new-hash  OVER !
  R> HEAP-ID!
;
: WL-HASH ( wid -- hash-table )
  wid-exth .hash @
;
( ������, �.�. ������ ������������� ���-������� - ������ ���������� )

USER-VALUE hash

: update-hash ( exth -- )
  >R
  R@ .last  @
  R@ .wid @ @  ( l2 l )
  2DUP = IF 2DROP RDROP EXIT THEN
  \ ���� ������� ���� - 0 0 - ���� �����

  DUP CHAR+ C@ 12 = IF CDR THEN
  2DUP = IF 2DROP RDROP EXIT THEN
  \ �� ��������� ��������� �����, ���� ������ ( by HIDE )

  DUP R@ .last !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  0 >R
  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP >R
  CDR DUP 0=        UNTIL THEN 2DROP
  ( )               BEGIN
  R> DUP            WHILE
  DUP COUNT 
  hash HASH!N       REPEAT DROP
  \ ��������� � ���-������� ���� � ��� �� �������, 
  \ � ������� ����� ����������� � �������

  R> HEAP-ID!
;

: reduce-hash ( last  wid  -- )
\ ��������� �� ���-������� ����� �� wid @ �� last
\ last ������ ����� ����� � ������� ������� wid
\ ( ��� MARKER )

  DUP wid-exth ?DUP 0= IF 2DROP EXIT THEN >R
  @ ( l2  l )
  OVER R@ .last  !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP COUNT hash -HASH
  CDR DUP 0=        UNTIL THEN 2DROP

  R> HEAP-ID!
;

EXPORT

\ SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH

: QuickSWL ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ SWL
  DUP GET-CURRENT <>                IF
  GET-CURRENT  wid-exth update-hash THEN

  wid-exth DUP update-hash
  @  ( c-addr u  h )
  HASH@N            IF
  \ last OVER U<  IF DROP RDROP 0 EXIT THEN
  \  ����� �������� ����� �������� 
  \       ��� ��������� ������� � �������, �������� �� ���������� � ��

  DUP  NAME> 
  SWAP NAME>F C@
  &IMMEDIATE AND
  IF 1 ELSE -1 THEN ELSE
  0                 THEN
;

: CLEAR-WLHASH ( wid -- )
\ �������� ���-������� �������. �� ������, ���� ��� ����� �� ����������..
  HEAP-ID >R  HEAP-GLOBAL

  wid-exth DUP
  .last 0!
  .hash @ clear-hash

  R> HEAP-ID!
;

: FREE-WORDLIST ( wid -- )
  DUP wid-exth DUP

   HEAP-ID >R  HEAP-GLOBAL
    .hash @ del-hash 
    FREE THROW
   R> HEAP-ID!

  FREE-WORDLIST
;

[DEFINED] MARKER [IF]

: MARKER
  WARNING @ >R WARNING 0!
  LATEST
  >IN @ >R  MARKER LATEST NAME>  R> >IN ! 
  ( last marker-xt  )
  CREATE
   , , GET-CURRENT ,
  R> WARNING !
  DOES> DUP CELL+ DUP @ SWAP CELL+ @ ( a last wid )
            reduce-hash
        @ EXECUTE
;

[THEN]

DEFINITIONS

: erase-refer ( -- )
\ ( ���������� ERASE-IMPORTS )
\ ���-������� ������������, ����� ������ � ��,
\ ������� ����� ������� �������� ������ �� exth � ���������� ��������
\ ����� �� �������������. �� ���� ��������. 
  VOC-LIST @ BEGIN
  DUP        WHILE
  DUP CELL+ ( a wid )
  3 CELLS + 0!  \ ������ "����� �������"
  @          REPEAT  DROP
;

: update-hashes ( -- )
( ���� � ������������� ������� ������ ���������� ������� ������� �����,
  �� ��� ������������ �� ���� ����� ������... � ����� ����� �����������
  � ��������� �����.
  ��� ����� ������������� ���������� ��� �������/���-�������/ ��� �������.
    ������, ������� ����� � ����� ������� ����������/���������
     - ������� ������� � SWL �������� CURRENT
)
  VOC-LIST @ BEGIN
  DUP        WHILE
  DUP CELL+ ( a wid )
  wid-exth update-hash
  @          REPEAT  DROP
;

..: AT-PROCESS-STARTING erase-refer update-hashes ;..


EXPORT

    [DEFINED] SEARCH-WORDLIST1                  [IF]
    ' QuickSWL TO SEARCH-WORDLIST               [ELSE]

    REQUIRE REPLACE-WORD lib\ext\patch.f
    ' QuickSWL ' SEARCH-WORDLIST REPLACE-WORD   [THEN]

;MODULE
