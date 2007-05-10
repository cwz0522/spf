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

\ ����� �� ������
\ � ������ ������ (xt ������ -1) ������������ node1 �� ������� ����� ��� ����������
\ xt: ( node-car -- ? ) \ TRUE - stop scan, FALSE - continue
: list-scan ( xt node -- node1 -1 | 0 )
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

\ ������� ������ as-value ������ n �� ��������� �� ����� v1...vn
: nlist ( v1 ... vn n -- l ) () { l } 0 ?DO vnode l cons -> l LOOP l ;

\ bac4th-�������� �� ������
: list-> ( node --> node1 \ <-- ) \ clean-stack
   PRO
   BEGIN
    DUP empty? 0=
   WHILE
    DUP >R
    CONT
    R> cdr 
   REPEAT DROP ;

\ bac4th-�������� �� ������
: list=> ( node <--> node1 )
   PRO
   BEGIN
    DUP empty? 0=
   WHILE
    DUP CONT cdr
   REPEAT DROP ;

\ �������� ������� node1 � ������ list ����� ������� ��������
\ ���� list ���� - ������ �� ������
\ list->...->nil
\ list->node1->...->nil
: insert-after ( node1 list -- )
   DUP empty? IF 2DROP EXIT THEN
   >R
   R@ cdr cons
   R> SWAP cons DROP ;

\ ��������� xt ��������������� � ����� �������� ��������� 
\ � ��������� ��������� � ������� ������
\ ��� ���� ���� ������ ������������� �� ���� �������
\ xt: ( node1-car node2-car )
: zipcar! ( xt node1 -- )
   { xt l }
   l length 1 = IF EXIT THEN
   BEGIN
    l car l cdar xt EXECUTE l setcar
    l cddr empty? IF l cdr FREE-NODE l () LINK-NODE EXIT THEN
    l cdr -> l
   AGAIN ;

\ ��������� xt � "���������������" ����� ��������� ������� node1 node2
\ xt: ( node1i node2i -- )
: map2 ( xt node1 node2 -- ) \ no clean stack
   ROT >R
   BEGIN
    DUP empty? 0= 
   WHILE
    OVER empty? 0= 
   WHILE
    2DUP R@ EXECUTE
    cdr >R cdr R>
   REPEAT
   THEN
   2DROP RDROP ;

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
l1 FREE-LIST
l2 FREE-LIST

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

%[ :NONAME 10 0 DO 2 % LOOP ; EXECUTE ]% TO l
\ CR l write-list
l list-remove-dublicates
\ CR l write-list
(( l %[ 2 % ]% equal? -> TRUE ))
l FREE-LIST

\
\ mapcar!

%[ 1 % 2 % 3 % ]% TO l
:NONAME 2 + ; l mapcar!
(( l lst( 3 % 4 % 5 % )lst equal? -> TRUE ))
l FREE-LIST

\
\ list-iter

%[ 1 % 2 % 3 % ]% TO l
VECT z
l list-iterator TO z

(( z l equal? -> TRUE ))
(( z l cdr equal? -> TRUE ))
(( z length -> 1 ))
(( z empty? -> TRUE ))

(( 0 :NONAME l list-> car + ; EXECUTE -> 6 ))
l FREE-LIST

\
\ zipcar!

%[ 1 % 2 % 3 % 4 % 5 % ]% TO l
' + l zipcar! 
(( l %[ 3 % 5 % 7 % 9 % ]% equal? -> TRUE ))
l FREE-LIST

\
\ map2

1 1 1 1 1 1 DEPTH nlist TO l1
2 3 0 -2 3 4 DEPTH nlist TO l2
%[ :NONAME car SWAP car + % ; l1 l2 map2 ]% TO l
(( l %[ 3 % 4 % 1 % -1 % 4 % 5 % ]% equal? -> TRUE ))
l FREE-LIST
l1 FREE-LIST
l2 FREE-LIST

END-TESTCASES
