\ $Id$
\ 03.Oct.2003  Ruv
\ 02.Aug.2004 ��� ��������� �� mem.f � mem2.f

( ���������� SPF4
  �������� ��������� ���� ALLOCATE FREE RESIZE
  �� ������� ����� HEAP-ID
  - ���� �� ���������� �� 0, �������� � ��� ��� � �����,
  ����� � ����� ������ THREAD-HEAP -- ������ ���������.
)

REQUIRE [UNDEFINED] lib\include\tools.f

USER-VALUE HEAP-ID

: HEAP-ID! ( heap -- ) TO HEAP-ID ;

[UNDEFINED] ALLOCATE1 [IF]
( �������� ����, ���� ��� ��������)
REQUIRE REPLACE-WORD lib\ext\patch.f
WARNING @ WARNING 0!

' ALLOCATE  VECT ALLOCATE ' ALLOCATE  SWAP REPLACE-WORD
' FREE      VECT FREE     ' FREE      SWAP REPLACE-WORD
' RESIZE    VECT RESIZE   ' RESIZE    SWAP REPLACE-WORD

WARNING !
[THEN]

\ 8 = HEAP_ZERO_MEMORY 
\ 1 = HEAP_NO_SERIALIZE
\ 9 = HEAP_ZERO_MEMORY HEAP_NO_SERIALIZE OR
\ ����� �������, ������������� ��� ������� � ������ ����
\  �� ������� ���������� ���������..

: ALLOCATE2 ( u -- a-addr ior ) \ 94 MEMORY
  CELL+ 9 ( HEAP_ZERO_MEMORY HEAP_NO_SERIALIZE OR )
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapAlloc
  DUP IF R@ OVER ! CELL+ 0 ELSE -300 THEN
;
: FREE2 ( a-addr -- ior ) \ 94 MEMORY
  CELL- 1 ( HEAP_NO_SERIALIZE )
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapFree ERR
;
: RESIZE2 ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
  CELL+ SWAP CELL- 9 ( HEAP_ZERO_MEMORY HEAP_NO_SERIALIZE OR )
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapReAlloc
  DUP IF CELL+ 0 ELSE -300 THEN
;

' ALLOCATE2 TO ALLOCATE
' FREE2     TO FREE
' RESIZE2   TO RESIZE

\ ===

: HEAP-GLOBAL ( -- )
  GetProcessHeap HEAP-ID!
;
: HEAP-DEFAULT ( -- ) \ or HEAP-LOCAL  or HEAP-USER
  0 HEAP-ID!
;
