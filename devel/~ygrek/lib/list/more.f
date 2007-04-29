\ $Id$
\ ������ �������� �� ��������

REQUIRE lst( ~ygrek/lib/list/ext.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE LAMBDA{ ~pinka/lib/lambda.f
REQUIRE /TEST ~profit/lib/testing.f

\ ������� xt ��� ������� �������� ������ ( �������� - car ������)
\ ���� xt ���������� 0 - ������� ��������� �� ������ (������ ���������� ����� ������� �������������)
\ ����� �������
\ ������������ �������������� ������
: reduce-this ( xt node1 -- node2 )
  ( xt: node-car -- ? ) \ TRUE - remain, FALSE - free node
   lst(
    BEGIN
     DUP empty? 0= 
    WHILE
     2>R
     2R@ car SWAP EXECUTE IF R> DUP cdr >R add-node 2R> ELSE R> DUP cdr >R FREE-NODE 2R> THEN
    REPEAT
    2DROP
   )lst ;

: list-scan ( xt node -- node -1 | 0 )
   BEGIN
    DUP empty? 0=
   WHILE
    2>R
    2R@ car SWAP EXECUTE IF R> RDROP TRUE EXIT THEN 
    2R> cdr
   REPEAT
   2DROP FALSE ;

0 VALUE _list-map-xt

\ �������������� ������ ������� ������ � ������� xt
\ xt: ( node-car -- val ) \ val ����� �������� � ������� �������������� ������� ������
: mapcar! ( xt node -- )
   SWAP TO _list-map-xt
   LAMBDA{ >R R@ car _list-map-xt EXECUTE R> setcar } SWAP map ;

: mapcar 
   SWAP TO _list-map-xt
   LAMBDA{ car _list-map-xt EXECUTE } SWAP map ;

0 VALUE _list-remove-all-val

\ ������� �� ������ node ��� �������� �� ��������� val
\ node1 - �������������� ������
: list-remove-all ( val node -- node1 )
   SWAP TO _list-remove-all-val
   LAMBDA{ _list-remove-all-val <> } SWAP 
   reduce-this ;

\ �������� mapcar
: mapcar 
   SWAP TO _list-map-xt
   LAMBDA{ car _list-map-xt EXECUTE } SWAP map ;

REQUIRE CREATE-VC ~profit/lib/bac4th-closures.f

\ �������� � �������������� closure
\ ��� ���������� ��� ���� ��� axt=> �������� �� ������ ����� �� ���� ����� 
\ ���������� �������� node � bac4th-����� � ���������� ��������� �� ������ �������� �� �����
: list-remove-all ( val node -- node1 )
   SWAP S" LITERAL <>" axt=> SWAP reduce-this ;

\ �������� � �������������� closure
: mapcar! ( xt node -- )
   SWAP S" >R R@ car [ COMPILE, ] R> setcar" axt=> SWAP map ;

\ �������� � �������������� closure
: mapcar ( xt node -- )
   SWAP S" car [ COMPILE, ]" axt=> SWAP map ;

\ ������� �� ������ lst ��� ��������-���������
: list-remove-dublicates ( lst -- )
   BEGIN
    DUP empty? 0= 
   WHILE
    DUP car OVER cdr list-remove-all cons
    cdr
   REPEAT DROP ;

: (list) { addr } addr @ DUP cdr addr ! ;
: list-iterator ( list -- xt ) S" A_AHEAD [ HERE SWAP , ] A_THEN LITERAL (list)" axt ;

: list=> ( node --> node1 \ <-- ) \ clean-stack
   PRO
   BEGIN
    DUP empty? 0=
   WHILE
    DUP >R
    CONT
    R> cdr 
   REPEAT DROP ;

\ �������� ������� node1 � ������ list ����� ������� ��������
\ ���� list ���� - ������ �� ������
\ list->...->nil
\ list->node1->...->nil
: insert ( node1 list -- )
   DUP empty? IF 2DROP EXIT THEN
   >R
   R@ cdr cons
   R> SWAP cons DROP ;

\ �������� �� ��������� �� ��������
: equal? ( node1 node2 -- ? )
   BEGIN
    DUP empty? IF DROP empty? EXIT THEN
    OVER empty? IF 2DROP FALSE EXIT THEN
    OVER list-what OVER list-what <> IF 2DROP FALSE EXIT THEN
    DUP value? IF 2DUP car SWAP car <> IF 2DROP FALSE EXIT THEN THEN
    DUP str? IF 2DUP car STR@ ROT car STR@ COMPARE IF 2DROP FALSE EXIT THEN THEN
    DUP list? IF 2DUP car SWAP car RECURSE 0= IF 2DROP FALSE EXIT THEN THEN 
    cdr SWAP cdr
   AGAIN TRUE ;

\ -----------------------------------------------------------------------

/TEST

REQUIRE TESTCASES ~ygrek/lib/testcase.f
REQUIRE write-list ~ygrek/lib/list/write.f

TESTCASES list-more

\
\ equal?

lst( 1 % 2 % " coo zoo " %s lst( " so so" %s 200 % )lst %l 2000 % )lst VALUE l1
lst( 1 % 2 % " coo zoo " %s lst( " so so" %s 200 % )lst %l 2000 % )lst VALUE l2

(( l1 l2 equal? -> TRUE ))

0 VALUE l

\
\ list-remove-all

lst( 1 % 2 % 4 % 2 % 3 % 4 % 6 % 6 % 2 % )lst TO l
\ CR l write-list
2 l list-remove-all TO l 
(( l lst( 1 % 4 % 3 % 4 % 6 % 6 % )lst equal? -> TRUE ))
\ CR l write-list
l list-remove-dublicates 
(( l lst( 1 % 4 % 3 % 6 % )lst equal? -> TRUE ))
\ CR l write-list
l FREE-LIST

lst( :NONAME 10 0 DO 2 % LOOP ; EXECUTE )lst TO l
\ CR l write-list
l list-remove-dublicates
\ CR l write-list
(( l lst( 2 % )lst equal? -> TRUE ))
l FREE-LIST

\
\ mapcar!

lst( 1 % 2 % 3 % )lst TO l
:NONAME 2 + ; l mapcar!
(( l lst( 3 % 4 % 5 % )lst equal? -> TRUE ))
l FREE-LIST

\
\ list-iter

lst( 1 % 2 % 3 % )lst TO l
VECT z
l list-iterator TO z

(( z l equal? -> TRUE ))
(( z l cdr equal? -> TRUE ))
(( z length -> 1 ))
(( z empty? -> TRUE ))

(( 0 :NONAME l list=> car + ; EXECUTE -> 6 ))
l FREE-LIST

END-TESTCASES
