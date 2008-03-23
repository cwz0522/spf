\ $Id$
( ������������� USER-����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������� 1999
)

: USER-INIT ( n )
\ n - ������ ����������, �-� Windows �������� callback ��������� (� ������)
  CREATE-HEAP
  <SET-EXC-HANDLER>
  POOL-INIT
  AT-THREAD-STARTING  
;

\ ���� ��� �� �������
: PROCESS-INIT ( n )
  ERASE-IMPORTS
  CREATE-PROCESS-HEAP
  <SET-EXC-HANDLER>
  POOL-INIT
  ['] AT-PROCESS-STARTING ERR-EXIT
;

\ ����� ��������������� �������
' NOOP         ' <PRE>      TC-VECT!
' FIND1        ' FIND       TC-VECT!
' ?LITERAL2    ' ?LITERAL   TC-VECT!
' ?SLITERAL2   ' ?SLITERAL  TC-VECT!
' OK1          ' OK         TC-VECT!
' ERROR2       ' ERROR      TC-VECT!
' (ABORT1")    ' (ABORT")   TC-VECT!
' PROC-ERROR1  ' PROC-ERROR TC-VECT!
' LIB-ERROR1   ' LIB-ERROR  TC-VECT!
\ ������ ��� �����������

: USER-EXIT
  AT-THREAD-FINISHING
  DESTROY-HEAP
\  TlsIndex@ FREE DROP
;




VARIABLE IN-EXCEPTION

: STACK-ADDR. ( addr -- addr )
      DUP U. ." :  "
      DUP ['] @ CATCH 
      IF DROP 
      ELSE DUP U. WordByAddr TYPE CR THEN
;

: AT-EXC-DUMP ( addr -- addr ) ... ;
\ example: ..: AT-EXC-DUMP ." REGISTERS:" DUP 12 CELLS DUMP CR ;..

: DUMP-TRACE ( addr-h addr-l -- ) \ bottom top --
  BEGIN 2DUP U< 0= WHILE STACK-ADDR. CELL+ REPEAT 2DROP
;

12 VALUE TRACE-HEAD-SIZE
15 VALUE TRACE-TAIL-SIZE

: DUMP-TRACE-SHRUNKEN ( addr-h addr-l -- ) \ bottom top --
  2DUP -  TRACE-HEAD-SIZE TRACE-TAIL-SIZE + 5 + CELLS
  U< IF DUMP-TRACE EXIT THEN
  DUP TRACE-HEAD-SIZE CELLS + SWAP DUMP-TRACE ." [...]" CR
  DUP TRACE-TAIL-SIZE CELLS - DUMP-TRACE
;

: EXC-DUMP1 ( exc-info -- )
  IN-EXCEPTION @ IF DROP EXIT THEN
  TRUE IN-EXCEPTION !
  BASE @ >R HEX

  ." EXCEPTION! "
  DUP @ ."  CODE:" U.
  DUP 3 CELLS + @ ."  ADDRESS:" DUP U.  ."  WORD:" WordByAddr TYPE CR

  ( DispatcherContext ContextRecord EstablisherFrame ExceptionRecord  ExceptionRecord )
  DROP 2 PICK

  8 CELLS 80 + \ FLOATING_SAVE_AREA
    11 CELLS + \ ����� ����������� �������� � ���������, ������� � edi
  + \ ���������� �������� ������ ������ ��������� (~ygrek)

  AT-EXC-DUMP ( addr -- addr )

  ." USER DATA: " TlsIndex@ U. ." THREAD ID: " 36 FS@ U.
  ." HANDLER: " HANDLER @ U. CR
  ." STACK: "
  DUP 6 CELLS + @ ( ebp )
  DUP 5 CELLS + BEGIN DUP ['] @ CATCH IF DROP ELSE 8 .0 SPACE THEN CELL- 2DUP U> UNTIL 2DROP
  ." ["
  DUP 5 CELLS + @ ( eax ) 8 .0 ." ]" CR

  ." RETURN STACK:" CR
  10 CELLS + @ ( esp )  R0 @ 
  
  2DUP U<
  IF ( top bottom )
    2DUP HANDLER @ WITHIN IF
      >R HANDLER @ SWAP DUMP-TRACE-SHRUNKEN
      HANDLER @ CELL+ R> 
    THEN
    2DUP  TRACE-HEAD-SIZE TRACE-TAIL-SIZE + CELLS - 10 CELLS -
    U< IF 10 CELLS - THEN \ skip early bottom
    SWAP DUMP-TRACE-SHRUNKEN
  ELSE ( esp bottom ) 
    NIP DUP 50 CELLS - DUMP-TRACE 
    \ ��� ����������������� ������������ �������� R0
  THEN

  ." END OF EXCEPTION REPORT" CR
  R> BASE !  FALSE IN-EXCEPTION !
;
' EXC-DUMP1 ' <EXC-DUMP> TC-VECT!

: FATAL-HANDLER1 ( ior -- )
  HEX
  ." UNHANDLED EXCEPTION: " DUP U. CR
  ." RETURN STACK: " CR
  R0 @ RP@ DUMP-TRACE-SHRUNKEN
  ." SOURCE: " CR ERROR CR
  ." THREAD EXITING." CR
  TERMINATE
;
' FATAL-HANDLER1 ' FATAL-HANDLER TC-VECT!  \ see THROW



: PLATFORM S" Win95/98/Me/NT/2k/XP/Vista" ;
