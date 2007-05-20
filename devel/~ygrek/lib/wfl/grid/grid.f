\ $Id$

\ ���� ~yz
\ �������� ����������� � ������, ������� ����� �����������
\ pre alpha

REQUIRE WFL ~day/wfl/wfl.f
NEEDS ~ygrek/lib/list/all.f
NEEDS lib/include/core-ext.f

\ -----------------------------------------------------------------------

: (DO-PRINT-VARIABLE) ( a u addr -- ) -ROT TYPE ."  = " @ . ;

: PRINT: ( "name" -- )
   PARSE-NAME
   2DUP
   POSTPONE SLITERAL
   EVALUATE
   POSTPONE (DO-PRINT-VARIABLE) ; IMMEDIATE

\ -----------------------------------------------------------------------

\ 20 VALUE def-h
\ 20 VALUE def-w
30 VALUE def-hmin
50 VALUE def-wmin
TRUE VALUE def-xspan
TRUE VALUE def-yspan

\ -----------------------------------------------------------------------

\ ������� ������� ����� - ������
CLASS CGridBox

 VAR _h     \ ���������� ������
 VAR _w     \ ���������� ������
 VAR _yspan \ ���� - ���������� �� ������
 VAR _xspan \ ���� - ���������� �� ������
 VAR _hmin  \ ����������� ������
 VAR _wmin  \ ����������� ������
 VAR _obj   \ ������-�������

init:
  0 _h !
  0 _w !
  0 _obj !
  def-wmin _wmin !
  def-hmin _hmin !
  def-xspan _xspan !
  def-yspan _yspan !
;

\ ��������� �������� �� x ���� ������ ������������
: :xformat ( given -- ) _xspan @ 0= IF DROP 0 THEN _wmin @ MAX _w ! ;
\ ��������� �������� �� y ���� ������ ������������
: :yformat ( given -- ) _yspan @ 0= IF DROP 0 THEN _hmin @ MAX _h ! ;

: :xmin _wmin @ ;
: :ymin _hmin @ ;

\ : :yformat ( u -- ) SELF => :ymin - 0 MAX SELF => :yformat-extra ;
\ : :xformat ( u -- ) SELF => :xmin - 0 MAX SELF => :xformat-extra ;

: :yspan? _yspan @ ;
: :xspan? _xspan @ ;

: :print
   PRINT: _wmin
   PRINT: _w
   PRINT: _xspan

   PRINT: _hmin
   PRINT: _h
   PRINT: _yspan
;

: :control! ( ctl-obj -- ) _obj ! ;

\ �������� ���������� � ������������ � ������� ������ �������� � ��� ����� �� ���� ���������
: :finalize { x y -- } _obj @ 0= IF EXIT THEN TRUE _h @ _w @ y x _obj @ => moveWindow ;

;CLASS

\ --------------------------

\ ��� ����� ��� ���� ������
CGridBox SUBCLASS CGridRow

 VAR _cells \ ������ ����� ����� ����

init:
  () _cells !
;

: :add ( cell -- ) vnode _cells @ cons _cells ! ;

: traverse-row ( xt -- ) _cells @ mapcar ;

\ ����������� ������ ���� ��� ����� ����������� ������ ������ ������
: :xmin ( -- n ) 0 LAMBDA{ => :xmin + } traverse-row ;
\ ����������� ������ ���� ��� ����� ����������� ������ ������ ������
: :ymin ( -- n ) 0 LAMBDA{ => :ymin MAX } traverse-row ;

\ ����� �� ���� ��� �������������
: :yspan? ( -- ? ) FALSE LAMBDA{ => :yspan? OR } traverse-row SUPER :yspan? OR ;

\ ����� ����� ������� ����� ��������� �� �����������
: :xspan-count ( -- n ) 0 LAMBDA{ => :xspan? IF 1 + THEN } traverse-row ;

: :xformat { given | extra -- }
   :xspan-count \ ���� � ��� ���� ������ ����������� - ����� �� ��
   DUP
   IF
    given :xmin - 0 MAX SWAP / -> extra

    \ �������� xspan-extra ������ ������
    \ �� � ������� xspan ������� ������ ���
    _cells @
    BEGIN
     DUP empty? 0=
    WHILE
     DUP car DUP => :xmin extra + SWAP => :xformat
     cdr
    REPEAT
    DROP
   ELSE \ ����� �������� �� ����
    DROP
    given SUPER :xformat
   THEN

   0 LAMBDA{ => _w @ + } traverse-row
   \ SUPER _wmin !
   given MAX SUPER :xformat
;

: :yformat { given -- }
   \ ���� ������ ������ ����������� �� ����� ��� �� given
   _cells @
   BEGIN
    DUP empty? 0=
   WHILE
    DUP car given SWAP => :yformat
    cdr
   REPEAT
   DROP

   \ ������� ����� �������� ���������������?
   0 LAMBDA{ => _h @ MAX } traverse-row given MAX SUPER :yformat
;

: :print ( -- )
   CR ." CGridRow :print"
   CR ." Row: " SUPER :print
   CR ." Cells : "
   LAMBDA{ CR => :print } traverse-row
;

: :draw { | x }
   0 -> x
   _cells @
   BEGIN
    DUP empty? 0=
   WHILE
    x 3 .R SPACE
    DUP car => _w @ x + -> x
    cdr
   REPEAT
   DROP
   x 3 .R SPACE
\   SUPER _w @ 3 .R SPACE
;

: :finalize { x y -- }
   _cells @
   BEGIN
    DUP empty? 0=
   WHILE
    DUP car x y ROT => :finalize
    DUP car => _w @ x + -> x
    cdr
   REPEAT
   DROP
;

;CLASS

\ --------------------------

\ ����� - ��� ������ �����
\ � ������������ ����� ���� ������
CGridBox SUBCLASS CGrid

 VAR _rows

init:
  () _rows ! ;

: traverse-grid ( xt -- ) _rows @ mapcar ;

: :xmin ( -- n ) 0 LAMBDA{ => :xmin MAX } traverse-grid ;
: :ymin ( -- n ) 0 LAMBDA{ => :ymin + } traverse-grid ;

\ ����� ����� ������� ����� ��������� �� ���������
: :yspan-count ( -- n ) 0 LAMBDA{ => :yspan? 1 AND + } traverse-grid ;

: :xformat { given -- }

   _rows @
   BEGIN
    DUP empty? 0=
   WHILE
    DUP car given SWAP => :xformat
    cdr
   REPEAT
   DROP

   \ ������� ������ ��� �������� �� ������ ������� ����
   0 LAMBDA{ => _w @ MAX } traverse-grid SUPER _w !
;

: :yformat { given | extra -- }

   \ ����� ��������� ������� +yspan ���� �������
   :yspan-count
   DUP
   IF
    given :ymin - 0 MAX SWAP / -> extra

    \ �������� extra ������� ����
    \ �� � ������� yspan ������� ������ ���
    _rows @
    BEGIN
     DUP empty? 0=
    WHILE
     DUP car DUP => :ymin extra + SWAP => :yformat
     cdr
    REPEAT
    DROP
   ELSE
    DROP
    given SUPER :yformat
   THEN

   \ ������� ������ ��� ����� ������ ������ ������
   0 LAMBDA{ => _h @ + } traverse-grid SUPER _h !
;

: :add ( row -- ) 0 OVER => :xformat 0 OVER => :yformat vnode _rows @ cons _rows ! ;

: :print ( -- )
   CR ." CGrid :print"
   CR ." Grid: " SUPER :print
   CR ." Rows----- "
   LAMBDA{ CR => :print } traverse-grid
   CR ." ------End"
;

: :draw { | y }
   0 -> y
   _rows @
   BEGIN
    DUP empty? 0=
   WHILE
    CR y 3 .R SPACE ." --->"
    DUP car => :draw
    DUP car => _h @ y + -> y
    cdr
   REPEAT
   DROP
;

: :finalize { x y -- }
   _rows @
   BEGIN
    DUP empty? 0=
   WHILE
    DUP car x y ROT => :finalize
    DUP car => _h @ y + -> y
    cdr
   REPEAT
   DROP
;

;CLASS

\ -----------------------------------------------------------------------

\ �������

\ ������, ������� - �� �����

\ MODULE: WG

0 VALUE box \ ������� ������
0 VALUE ctl  \ ������� � ������� ������
0 VALUE row  \ ������� ���
0 VALUE grid \ ������� �����

\ ������� ����� ������ � ������� ���� � ��������� � �� ������� ������ class
: put-box ( box -- )
   TO box
   box row => :add ;

: put ( class -- )
   NewObj TO ctl
   CGridBox NewObj put-box
   0 SELF ctl => create DROP
   ctl box => :control! ;

\ ������ ����� ��� ������
: ROW ( -- )
  CGridRow NewObj TO row
  row grid => :add
;

: save-vars ( -- l )  %[ grid % row % box % def-hmin % def-wmin % def-xspan % def-yspan % ]% ;

: restore-vars { l -- }
   ['] NOOP l mapcar ( ... )
   TO def-yspan
   TO def-xspan
   TO def-wmin
   TO def-hmin
   TO box
   TO row
   TO grid
   l FREE-LIST ;

\ ������ ����� �������
\ ��������� �������� ���������� ����� ��-���������
: GRID ( -- i*x )
   save-vars
   CGrid NewObj TO grid
   ROW ;

\ ��������� �������
\ ������������ ���������� �������� ���������� ����� ��-���������
: ;GRID ( i*x -- grid ) grid >R restore-vars R> ;

: xspan! ( ? -- ) box :: CGridBox._xspan ! ;

\ �������� ���������� ������ �� ������
: +xspan ( -- ) TRUE xspan! ;
\ ��������� ���������� ������ �� ������
: -xspan ( -- ) FALSE xspan! ;

: yspan! ( ? -- ) box :: CGridBox._yspan ! ;

\ ��������� ���������� ������ �� ������
: +yspan ( -- ) TRUE yspan! ;
\ ��������� ���������� ������ �� ������
: -yspan ( -- ) FALSE yspan! ;

\ ���������� ���������� �������
\ xt: ( obj -- )
: -command! ( xt -- ) ctl => setHandler ;
: -text! ( a u -- ) ctl => setText ;

: -xmin! ( u -- ) box :: CGridBox._wmin ! ;
: -ymin! ( u -- ) box :: CGridBox._hmin ! ;

\ ;MODULE

\ -----------------------------------------------------------------------
