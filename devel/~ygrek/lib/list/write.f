\ $Id$
\ ���������� ������

REQUIRE value? ~ygrek/lib/list/ext.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE replace-str- ~pinka/samples/2005/lib/replace-str.f
REQUIRE /STRING lib/include/string.f

\ ������� n �������� �� �������� ������
: PARSE-DATA { n -- a u }
   SOURCE >IN @ /STRING n MIN
   >IN @ OVER + >IN ! ;

: (.) ( n -- ) S>D (D.) TYPE ;
: >STR "" >R R@ STR+ R> ;
: print-str-for-eval ( s -- ) STR@ DUP "  {n} PARSE-DATA {s} >STR " STYPE ;
: print-quoted-str-cut ( s -- ) [CHAR] " EMIT STR@ DUP 20 > IF DROP 17 TYPE ." ..." ELSE TYPE THEN [CHAR] " EMIT ;

\ -----------------------------------------------------------------------

VECT (write-list)

: write-node ( node -- )
   DUP list? IF car (write-list) EXIT THEN
   DUP str? IF car print-quoted-str-cut SPACE EXIT THEN
   DUP value? IF car . EXIT THEN
   ." ?" car . ;

\ ����������� ������, ������� ��� ����������� �������, ������� ����� ����������������
: write-list ( node -- )
   ." ( "
   BEGIN
    DUP empty? 0=
   WHILE
    DUP write-node
    cdr
   REPEAT
   DROP ." ) " ;

' write-list TO (write-list)

\ -----------------------------------------------------------------------

VECT (print-list)

: print-node ( node -- )
   DUP list? IF car (print-list) ." %l " EXIT THEN
   DUP str? IF car print-str-for-eval ." %s " EXIT THEN
   DUP value? IF car . ." % " EXIT THEN
   ABORT" ??? Bad list" ;

\ ����������� ������, ��������� ������������� ��������� ��� �������������� EVALUATE'��
\ � ������ ���������� EVALUATE ����������� �����
\ " �� ~ac/lib/str5.f
\ lst( � �������� �� ~ygrek/lib/list/ext.f
\ PARSE-DATA � >STR �� ���� ����
: print-list ( node -- )
   ." lst( "
   BEGIN
    DUP empty? 0=
   WHILE
    DUP print-node
    cdr
   REPEAT
   DROP ." )lst " ;

' print-list TO (print-list)

\ -----------------------------------------------------------------------

: dump-node ( node -- )
   DUP empty? IF DROP ." ()" EXIT THEN
   DUP list? IF ." (l " THEN
   DUP str? IF ." (s " THEN
   DUP value? IF ." (v " THEN
   DUP car . ." . "
       cdr (.) ." )" ;

\ ����������� ������, ��� ������ ��������� - ������ ������
: dump-list ( node -- )
   DUP dump-node
   DUP empty? IF DROP EXIT THEN
   ."  -> "
   cdr RECURSE ;

\ -----------------------------------------------------------------------

/TEST

REQUIRE TYPE>STR ~ygrek/lib/typestr.f
REQUIRE equal? ~ygrek/lib/list/more.f
REQUIRE TESTCASES ~ygrek/lib/testcase.f

TESTCASES list print and read

lst( 1 %n " qu qu" %s 2 %n " long {''}string{''}for dem{CRLF}onstration" %s
     3 %n lst( -1 %n -2 %n -3 %n )lst %l 5 %n )lst ( l ) VALUE l

l CR write-list
l CR print-list
l CR dump-list

l ' print-list TYPE>STR \ ����������� ������ � ������
STR@ EVALUATE VALUE l2 \ � ����������� ������� EVALUATE'��

\ ������ ������ ���� �����!
(( l l2 equal? -> TRUE ))

l FREE-LIST
l2 FREE-LIST

END-TESTCASES
