\ 10.Feb.2006 Fri 20:44

: enqueueNOTFOUND ( xt -- )
\ �������� � ����� ������ ������������
\ ����������, �������� xt
\ xt ( a u -- a u false | n*x true )

  S" NOTFOUND" SFIND 0= IF 2DROP ['] NOOP THEN
    WARNING @ >R WARNING 0!
  S" NOTFOUND" CREATED , ,
    R> WARNING !
  DOES> ( a u  a1 )
    DUP 2OVER 2>R >R
    @ CATCH 0= IF RDROP RDROP RDROP EXIT THEN
    ( x x ) 2DROP
    R> 2R> ROT CELL+ @ EXECUTE IF EXIT THEN
    -2003 THROW
;

\ example:
\ ' AsQName enqueueNOTFOUND
\ where AsQName stack notation
\   on STATE0 is ( i*x  a-text u-text -- j*x  true | i*x  a u false )
\   otherwise is ( a-text u-text -- true | a u false )
