\ $Id$
\ ��� ���� ���� ��� �������
\ �������� ������� - cons pair, �� ���� ���� CELL'�� : car � ������� � cdr �� ������

0
CELL -- list.car
CELL -- list.cdr
CELL -- list.x1
CELL -- list.x2
CONSTANT /NODE

: NEW-NODE ( -- node )
    /NODE ALLOCATE THROW 
    DUP /NODE ERASE 
; 

: FREE-NODE ( node -- ) FREE THROW ;

\ ���������� ����� node1->node2
: LINK-NODE ( node1 node2 -- ) SWAP list.cdr ! ;

\ ������� cons pair � �������
: vnode ( val -- node ) NEW-NODE TUCK list.car ! ;

\ () - ������ ������� - ��������� ��� �� ���� - ����� ������
NEW-NODE VALUE ()
\ C" <NULL>" () !
() () LINK-NODE

\ TRUE - ������� ����, ��� ��������
\ FALSE - �����
: empty? ( node -- ? ) () = ;

\ ������� � ���������� �������� � ������ ����� �������� node1
: cdr ( node1 -- node2 ) list.cdr @ ;

\ ���������� ������ ������ �������� node
: car ( node -- val ) list.car @ ;

\ ���������� ������ ������
: setcar ( val node -- ) DUP empty? IF 2DROP EXIT THEN list.car ! ;

\ ���������� :)
: cddr cdr cdr ;
: cdddr cdr cdr cdr ;
: cdar cdr car ;
: cddar cdr cdr car ;

\ ������ �� ������� ��������� �� ���������� - ������������ �� ()
: end ( node -- node2 )
   DUP cdr empty? IF EXIT THEN
   cdr RECURSE ;

\ �������� ������� � ������ ������ � ������� ������������ ������ 
\ node1->node2
: cons ( node1 node2 -- node1 ) OVER SWAP LINK-NODE ;

\ ��������� xt �� ���� ��������� ������ node1
\ xt: ( node -- ) \ xt �������� ���������� ������ ������� �� ���������� �����
: map ( xt node1 -- )
   DUP empty? IF 2DROP EXIT THEN
   2DUP 2>R SWAP EXECUTE 
   2R> cdr RECURSE ;

\ ��������� xt � ������ ���� ��������� ������ node1
\ xt: ( node.car -- ) \ xt �������� ���������� car ������ ������� �������� �� ���������� �����
: mapcar ( xt node -- )
   DUP empty? IF 2DROP EXIT THEN
   2DUP 2>R car SWAP EXECUTE 
   2R> cdr RECURSE ;

\ �������� n-�� ������� ������, ������ ��������
: nth ( n node -- node )
   OVER 0= IF NIP EXIT THEN
   cdr SWAP 1- SWAP
   RECURSE ;

\ �������� ����� ������ - ������ �������� �� ����� ������
: length ( node -- n )
   DUP empty? IF DROP 0 EXIT THEN
   cdr RECURSE 1+ ;

\ ���������� ������ ������� �������
: FREE-LIST ( node -- ) 
   DUP empty? IF DROP EXIT THEN
   DUP cdr 
   SWAP FREE-NODE 
   RECURSE ;

\ node2->...->node1->nil
: (append) ( node1 node2 -- )
    end OVER LINK-NODE
    () LINK-NODE ;

\ �������� ������� node1 � ����� ������ node2 (����� ������ ���������)
\ node2->...->node1->nil
: append ( node1 node2 -- node ) DUP empty? IF DROP DUP () LINK-NODE ELSE TUCK (append) THEN ;

\ ���������� ������ � �������� �������
: reverse ( node -- node1 )
   () >R
   BEGIN
    DUP empty? 0=
   WHILE
    DUP cdr
    SWAP
    R> cons >R
   REPEAT 
   DROP R> ;

\ �������� �� ��������������
: member? ( n node -- ? ) 
   BEGIN
    DUP empty? 0=
   WHILE
    2DUP car = IF 2DROP TRUE EXIT THEN
    cdr
   REPEAT 
   2DROP FALSE ;
