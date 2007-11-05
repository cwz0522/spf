\ $Id$

\ ���� ~yz
\ �������� ����������� � ������, ������� ����� �����������
\ pre alpha

REQUIRE WFL ~day/wfl/wfl.f
NEEDS ~ygrek/lib/list/all.f
NEEDS lib/include/core-ext.f
REQUIRE NOT ~profit/lib/logic.f

\ -----------------------------------------------------------------------

: (DO-PRINT-VARIABLE) ( a u addr -- ) -ROT TYPE ."  = " @ . ;

: PRINT: ( "name" -- )
   PARSE-NAME
   2DUP
   POSTPONE SLITERAL
   EVALUATE
   POSTPONE (DO-PRINT-VARIABLE) ; IMMEDIATE

\ -----------------------------------------------------------------------

CLASS CGridBoxData
 CELL PROPERTY _yspan \ ���� - ���������� �� ������
 CELL PROPERTY _xspan \ ���� - ���������� �� ������
 CELL PROPERTY _hmin  \ ����������� ������
 CELL PROPERTY _wmin  \ ����������� ������

: :print
   PRINT: _wmin
   PRINT: _xspan

   PRINT: _hmin
   PRINT: _yspan 
;

;CLASS

CGridBoxData NEW DefaultBox

30 DefaultBox _hmin!
50 DefaultBox _wmin!
TRUE DefaultBox _xspan!
TRUE DefaultBox _yspan!

\ ������� ������� ����� - ������
CGridBoxData SUBCLASS CGridBox

 VAR _h     \ ���������� ������
 VAR _w     \ ���������� ������
 VAR _obj   \ ������-�������

init:
  0 _h !
  0 _w !
  0 _obj !
  DefaultBox _wmin@ SUPER _wmin!
  DefaultBox _hmin@ SUPER _hmin!
  DefaultBox _xspan@ SUPER _xspan!
  DefaultBox _yspan@ SUPER _yspan!
;

: :yspan? SUPER _yspan@ ;
: :xspan? SUPER _xspan@ ;

: :xmin SUPER _wmin@ ;
: :ymin SUPER _hmin@ ;

\ ��������� �������� �� x ���� ������ ������������
: :xformat ( given -- ) :xspan? NOT IF DROP 0 THEN :xmin MAX _w ! ;
\ ��������� �������� �� y ���� ������ ������������
: :yformat ( given -- ) :yspan? NOT IF DROP 0 THEN :ymin MAX _h ! ;

: :print
   SUPER :print
   PRINT: _w
   PRINT: _h
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

: :add ( cell -- ) vnode _cells @ append _cells ! ;

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

: :add ( row -- ) 0 OVER => :xformat 0 OVER => :yformat vnode _rows @ append _rows ! ;

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
0 VALUE parent

\ ������� ����� ������ � ������� ���� � ��������� � �� ������� ������ class
: put-box ( box -- )
   TO box
   box row => :add ;

: put ( class -- )
   NewObj TO ctl
   CGridBox NewObj put-box
   parent SELF ctl => create DROP
   ctl box => :control! ;

\ ������ ����� ��� ������
: ROW ( -- )
  CGridRow NewObj TO row
  row grid => :add
;

() VALUE grid-vars

: save-vars ( -- ) 
   %[ parent % grid % row % box % 
      DefaultBox _hmin@ % 
      DefaultBox _wmin@ % 
      DefaultBox _xspan@ % 
      DefaultBox _yspan@ % 
   ]% vnode as-list grid-vars cons TO grid-vars ;

: restore-vars 
   grid-vars car >R
   grid-vars cdr TO grid-vars
   R@ LIST> ( ... )
   DefaultBox _yspan!
   DefaultBox _xspan!
   DefaultBox _wmin!
   DefaultBox _hmin!
   TO box
   TO row
   TO grid
   TO parent
   R> FREE-LIST ;

: DEFAULTS DefaultBox this TO box ;

\ ������ ����� �������
\ ��������� �������� ���������� ����� ��-���������
: GRID ( parent -- )
   save-vars
   TO parent
   CGrid NewObj TO grid
   ROW ;

\ ��������� �������
\ ������������ ���������� �������� ���������� ����� ��-���������
: ;GRID ( -- grid ) grid >R restore-vars R> ;

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
: =command ( xt -- ) ctl => setHandler ;
: =text ( a u -- ) ctl => setText ;

: =xmin ( u -- ) box :: CGridBox._wmin ! ;
: =ymin ( u -- ) box :: CGridBox._hmin ! ;

\ ;MODULE

\ -----------------------------------------------------------------------

CRect SUBCLASS CRect

: rawCopyFrom ( ^RECT -- ) SUPER addr 4 CELLS CMOVE ;
: rawCopyTo ( ^RECT -- ) SUPER addr SWAP 4 CELLS CMOVE ;

: height! ( u -- ) SUPER top @ + SUPER bottom ! ;
: width! ( u -- ) SUPER left @ + SUPER right ! ;

;CLASS

\ -----------------------------------------------------------------------

\ ���������� ��� ���������� ������
\ ������������� :
\ - �������� ������ ������ CGridController
\ - ��������� ��� ����� � ������� :grid!
\ - ������������ ���������� � ���� (�������, ��������)
\
\ ���������� ����� ������������� ��������� WM_SIZE � WM_SIZING 
\ � �������� ���������� ����� ��������������� �������
\
\ FIXME ����������� ������� FALSE setHandled � ������������
CMsgController SUBCLASS CGridController

  VAR _g

: :resize ( w h -- )
   _g @ => :yformat
   _g @ => :xformat
   0 0 _g @ => :finalize ;

: :grid _g @ ;

: :minsize ( w h -- w1 h1 )
   _g @ => :ymin 30 + \ FIXME ������ ���������
   2DUP > IF DROP ELSE NIP THEN
   SWAP
   _g @ => :xmin 8 + \ FIXME ������ �����
   2DUP > IF DROP ELSE NIP THEN
   \ 2DUP CR ." MIN : w = " . ." h = " .
   SWAP ;

: :grid! _g ! ;
: :hw _g @ => _h @ _g @ => _w @ ;

W: WM_SIZE 
   SUPER msg lParam @ LOWORD SUPER msg lParam @ HIWORD :resize
   FALSE
;

W: WM_SIZING ( -- n )
   SUPER msg lParam @
   || R: lpar CRect r ||
   lpar @ r rawCopyFrom
   r width r height :minsize r height! r width!
   lpar @ r rawCopyTo
   TRUE
;

: :init { win }
  _g @ 0= S" Setup controls grid with :grid! before attaching controller" SUPER abort
  win => getClientRect DROP DROP SWAP :minsize :resize
  FALSE :hw win => getClientRect 2SWAP 2DROP SWAP win => clientToScreen SWAP win => moveWindow 
  ;

\ RFD: is it ok to automatically resize grid when controller is injected?
: onAttached SUPER parent-obj@ :init ;

;CLASS

\ -----------------------------------------------------------------------
