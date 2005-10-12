\ 07.Jan.2004 ruv
\ 12.Oct.2005 branch from quick-swl2.f,v 1.3
\ $Id$

( ���������� SPF [������� �� ����������!]
   ��������� ������� ����� �� ������� �� ���� ������������� ���-������.

  ���-������� ��������� �����������, �� SAVE �� �����������.

  �����������:
    ���-������� ������������� � ����� ���� ��������
    [����� �������� HEAP-ID  ~pinka/spf/mem.f]
    �������� ������ ���� ��������, ���� �� ������ FREE-WORDLIST 
    �� ������ TEMP-WORDLIST
)
( �������������� FREE-WORDLIST  � MARKER /���� �� ����/
  �������, ������� ���������� quick-swl.f �� ����, 
   ��� ��� ����� ����� ���� ������������ � ������������.
  [ � ��� �����, �� locals.f ]
  
  ���������� ������ SHEADER � �������������� ����� ":" ";"

  �������� ������ SEARCH-WORDLIST - ����� ������ � ����������� �������� SPF
  ���������� ������ "����� �������" � ��������� ������� ��� ���������� ���������.
  �������������� CLASS! � CLASS@ 
  [ �.�. �������������� �� ������ ������ � ��������� ������������� ;]
)

REQUIRE HEAP-ID     ~pinka\spf\mem.f
REQUIRE [UNDEFINED] lib\include\tools.f
REQUIRE HASH!       ~pinka\lib\hash-table.f 


[UNDEFINED] ENUM-VOCS [IF]
: ENUM-VOCS ( xt -- )
\ xt ( wid -- )
  >R VOC-LIST @ BEGIN DUP WHILE
    DUP CELL+ ( a wid ) R@ ROT >R
    EXECUTE R> @
  REPEAT DROP RDROP
;
[THEN]

[UNDEFINED] WL-#WORDS [IF]
: WL-#WORDS ( wid -- n )
  0 SWAP
  @     BEGIN
  DUP   WHILE
  SWAP 1+ SWAP
  CDR   REPEAT  DROP
;
[THEN]


MODULE: QuickSWL-Support

3 CELLS CONSTANT /THIS-EXTR   \ [ free cell | addr of hash-hdr | voc class ]

: MAKE-EXTR ( wid -- )
  GET-CURRENT >R  DUP SET-CURRENT
  HERE SWAP CLASS!
  HERE /THIS-EXTR DUP ALLOT ERASE
  R> SET-CURRENT
;
: MAKE-EXTR-EXISTS ( -- )
  ['] MAKE-EXTR ENUM-VOCS
;

EXPORT

 256 VALUE #WL-HASH
 \ ������ ���-������ ��� ����� ����������� ��������.
 \ ��� ������������� �� ����� AT-PROCESS-STARTING 
 \   ������ ������ ������� ��� 3*n, ��� n -����� ���� � �������.

: WID-EXTRA ( wid -- a )  \ ����� ��������� ��� ������ ���������� ������
  DUP [ 3 CELLS ] LITERAL + \ a "class of vocabulary" cell
  @ DUP IF NIP EXIT THEN DROP
  DUP MAKE-EXTR RECURSE
;

DEFINITIONS

: WID-EHA ( wid -- a ) \ this extra header, for hash
  WID-EXTRA CELL+
;
: WID-CLASSA ( wid -- a )
  WID-EXTRA [ 2 CELLS ] LITERAL +
;


EXPORT
WARNING @ WARNING 0!
: CLASS! ( cls wid -- ) WID-CLASSA ! ;
: CLASS@ ( wid -- cls ) WID-CLASSA @ ;
WARNING !

DEFINITIONS

0 \ ext header  for wordlist \ allocating dinamically
 1 CELLS -- .hash
 1 CELLS -- .last
 1 CELLS -- .wid
CONSTANT /exth
( exth ����� ���� wid ����� ������� .wid
  � �� wid ����� �������� exth
)

: wid-exth ( wid -- exth )
  DUP WID-EHA @ ?DUP IF NIP EXIT THEN
  ( wid )
  HEAP-ID >R  HEAP-GLOBAL

  DUP WL-#WORDS #WL-HASH UMIN new-hash

  /exth ALLOCATE THROW ( wid h exth )
  TUCK .hash !
  2DUP SWAP WID-EHA !
  TUCK .wid !
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

: update-wlhash ( wid -- )
  wid-exth update-hash
;

: update1-wlhash ( nfa wid -- )
  wid-exth DUP .last @     IF
  HEAP-ID >R  HEAP-GLOBAL
    .hash @    >R
    DUP COUNT  R> HASH!N
  R> HEAP-ID!               ELSE
  \ ����� ��� ��������� ������� ��� ����� �����������
  NIP update-hash           THEN
;


: reduce-hash ( last  wid  -- )
\ ��������� �� ���-������� ����� �� wid @ �� last
\ last ������ ����� ����� � ������� ������� wid
\ ( ��� MARKER ) ( ��� MARKER �� ��������, - 25.Mar.2004 )

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
( ���� ����� ���� ��������������,
  �� ����� reduce-hash  ���������� ������ ��������� �����������..
  ������� � MARKER ���������� REFRESH-WLHASH
)

EXPORT

\ SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH

: QuickSWL ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ SWL
  WL-HASH ( c-addr u  h )
  HASH@N            IF
  DUP  NAME> 
  SWAP NAME>F C@
  &IMMEDIATE AND
  IF 1 ELSE -1 THEN 
  EXIT              ELSE 0 THEN
;
( ��� ��������� � MARKER ����� ���� �� � QuickSWL ���������,
   ��� ��������� ����� ��� ����� ���������� ���� ����������� ����� � ������� 
   [ ��� �� ������� HERE ], �� ����� �������� ����� �������� 
   ��� ��������� ������� � �������, �������� �� �� ���������� � ��.
)

: REFRESH-WLHASH ( wid -- )
\ �������� ���-������� ������� (�� ������, ���� ��� ����� ������������..)
\ �������������� ��������, ���� �� ����� ���������� REFRESH-WLHASH 
\  ���������� ����� �� ������� wid.
  DUP
  HEAP-ID >R  HEAP-GLOBAL

  wid-exth DUP
  .last 0!
  .hash @ clear-hash

  R> HEAP-ID!
  update-wlhash
;

WARNING @ WARNING 0!

: FREE-WORDLIST ( wid -- )
  DUP wid-exth DUP
   ( wid exth exth )
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
    ( last marker-xt )
    CREATE
     , , GET-CURRENT ,
  R> WARNING !

  DOES> 
    DUP 0 CELLS +  @ EXECUTE
        2 CELLS +  @ REFRESH-WLHASH
;
[THEN]

WARNING !

DEFINITIONS

: WID-EHA0! ( wid -- )
  WID-EHA 0!
;
: erase-refer ( -- )
\ ( ���������� ERASE-IMPORTS )
\ ���-������� ������������, ����� ������ � ��,
\ ������� ����� ������� �������� ������ �� exth � ���������� ��������
\ ����� �� �������������. �� ���� ��������. 
  ['] WID-EHA0! ENUM-VOCS
;

: update-hashes ( -- )
\ ���������� ���-������� ��� ���� �������� (�� ������ VOC-LIST)
  ['] update-wlhash ENUM-VOCS
;
( ���������� ���-������� �� ������� ������ � �������
  ������� ������������� ��� ����������������� � ���������������,
  �� ������������.

  ������������� ���������� ���� ������ �������� �� �����������
  �� ������ ������������� ����������...
)

VECT 0SWL  \ ����.-�� ������ QuickSWL  ��� ������� �������..

: 0SWL1 ( -- )
  erase-refer
  update-hashes
; ' 0SWL1 TO 0SWL

..: AT-PROCESS-STARTING 0SWL ;..

\ -------------------------------

USER LAST-WID

: LastWord2Hash ( -- )
  LAST @ LAST-WID @ update1-wlhash
;
: LatestWord2Hash ( -- )
  LATEST ?DUP IF GET-CURRENT update1-wlhash THEN
;

USER-VALUE NOW-COLON?

: SHEADER(SWL) ( addr u -- )
  GET-CURRENT LAST-WID !

  NOW-COLON?
  IF FALSE TO NOW-COLON?  ELSE  LastWord2Hash THEN
  [ ' SHEADER BEHAVIOR COMPILE, ]
;

EXPORT

WARNING @ WARNING 0!

: : ( C: "<spaces>name" -- colon-sys ) \ 94
  TRUE TO NOW-COLON?
  :
;
: ;
    POSTPONE ;
    LatestWord2Hash
    ( ���� ���� NONAME, �� ����������� �����, ������� ��� ����
      - �������� �������. )
    FALSE TO NOW-COLON?
; IMMEDIATE

WARNING !

    [DEFINED] SHEADER1                          [IF]
    ' SHEADER(SWL) TO SHEADER                   [ELSE]
    .( need a later version of SPF4 ) CR ABORT  [THEN]

 0SWL  \ ����.��

    [DEFINED] SEARCH-WORDLIST1                  [IF]
    ' QuickSWL TO SEARCH-WORDLIST               [ELSE]
    .( need a later version of SPF4 ) CR ABORT  [THEN]

;MODULE
