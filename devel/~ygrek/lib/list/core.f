\ $Id$
\ ��� ���� ���� ��� �������
\ �������� ������� - cons pair, �� ���� ���� CELL'�� : car � ������� � cdr �� ������

\ ������� ������
0
CELL -- list.car \ ������-������
CELL -- list.cdr \ �����
CELL -- list.x1  \ reserved
CELL -- list.x2  \ reserved
CONSTANT /NODE

\ ������� ����� �������
: NEW-NODE ( -- node )
    /NODE ALLOCATE THROW
    DUP /NODE ERASE
;

\ ���������� ������ ���������� ��������� ������
: FREE-NODE ( node -- ) FREE THROW ;

\ ���������� ����� node1->node2
: LINK-NODE ( node1 node2 -- ) SWAP list.cdr ! ;

\ ������� ����� ������� ������ � ������� val
: vnode ( val -- node ) NEW-NODE TUCK list.car ! ;

\ () - ������ ������� - ��������� ��� �� ���� - ����� ������
HERE /NODE ALLOT VALUE ()
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
   BEGIN
   DUP cdr empty? IF EXIT THEN
   cdr
   AGAIN ;

\ �������� ������� � ������ ������ � ������� ������������ ������
\ node1->node2
: cons ( node1 node2 -- node1 ) OVER SWAP LINK-NODE ;

\ node1(value)->node
: vcons ( value node -- node1 ) SWAP vnode SWAP cons ;

\ ������������ ���� ������ node1 � ������ ������ node2
: concat-list ( node1 node2 -- node )
   OVER empty? IF NIP EXIT THEN
   OVER end SWAP LINK-NODE ;

\ ��������� xt �� ���� ��������� ������ node1
\ xt: ( node -- ) \ xt �������� ���������� ������ ������� �� ���������� �����
: map ( xt node1 -- )
   2>R
   BEGIN
    R@ empty? IF RDROP RDROP EXIT THEN
    2R@ SWAP EXECUTE
    R> cdr >R
   AGAIN ;

\ ��������� xt � ������ ���� ��������� ������ node1
\ xt: ( node.car -- ) \ xt �������� ���������� car ������ ������� �������� �� ���������� �����
: mapcar ( xt node -- )
   2>R
   BEGIN
    R@ empty? IF RDROP RDROP EXIT THEN
    2R@ car SWAP EXECUTE
    R> cdr >R
   AGAIN ;

\ �������� n-�� ������� ������, ������ ��������
: nth ( n node -- node ) SWAP 0 ?DO cdr LOOP ;

\ �������� ����� ������ - ������ �������� �� ����� ������
: length ( node -- n )
   0 >R
   BEGIN
    DUP empty? IF DROP R> EXIT THEN
    cdr
    RP@ 1+!
   AGAIN ;

\ ���������� ������ ������� �������
: FREE-LIST ( node -- )
   BEGIN
    DUP empty? IF DROP EXIT THEN
    DUP cdr
    SWAP FREE-NODE
   AGAIN ;

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
