\ 03.Oct.2003  Ruv
\ $Id$

USER-VALUE HEAP-ID
: HEAP-ID! TO HEAP-ID ;

: ALLOCATE ( u -- a-addr ior ) \ 94 MEMORY
  CELL+ 9 ( HEAP_ZERO_MEMORY) \ THREAD-HEAP @ 
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapAlloc
  DUP IF R@ OVER ! CELL+ 0 ELSE -300 THEN
;
: FREE ( a-addr -- ior ) \ 94 MEMORY
  CELL- 0 
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapFree ERR
;

: RESIZE ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
  CELL+ SWAP CELL- 9 ( HEAP_ZERO_MEMORY) \ THREAD-HEAP @ 
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapReAlloc
  DUP IF CELL+ 0 ELSE -300 THEN
;

: HEAP-GLOBAL
  GetProcessHeap TO HEAP-ID
;
: HEAP-DEFAULT \ or HEAP-LOCAL  or HEAP-USER
  0 TO HEAP-ID
;
