\ $Id$

REQUIRE WL-MODULES ~day/lib/includemodule.f
NEEDS ~day/wfl/wfl.f
NEEDS ~ygrek/lib/wfl/opengl/GLCanvas.f

\ -----------------------------------------------------------------------

\ � GLCanvas ���� ������ ����� :prepare ��� ������������ ������� �������� ������������� GL
\ �� �.�. ��� GLCanvas ������� ������ GLWindow, ���� ���� ����������� ������� � ����� ������.
\ ���������� - ������� GLWindow>>:prepare �� _�anvas>>:prepare
\ ������������� - �������������� GLWindow>>:prepare
\ �� ��� ���� ���� �������������� �������� ��������� ���� � ���� canvas-��������� (:bind)

CGLCanvas SUBCLASS CGLWindowCanvas

 VAR _obj

init: 0 _obj ! ;
: :bind ( obj -- ) _obj ! ;
: :prepare SUPER :prepare _obj @ IF _obj @ => :prepare THEN ;

;CLASS

\ -----------------------------------------------------------------------

CFrameWindow SUBCLASS CGLWindow
  CGLWindowCanvas OBJ _canvas \ ������� ���������

init:
   \ NULL SUPER class hbrBackground !
   WS_OVERLAPPEDWINDOW WS_CLIPSIBLINGS OR WS_CLIPCHILDREN OR SUPER style OR!
   WS_EX_APPWINDOW WS_EX_WINDOWEDGE OR SUPER exStyle OR! 
   SELF _canvas :bind 
;

dispose: ( CR ." Kill ") ;

: :resize { | WindowRect -- }
\ ��������� ������������� ������� � ��������� GL������
   \ CR ." Request dimensions : " _canvas :width@ . _canvas :height@ .

   RECT::/SIZE ALLOCATE THROW TO WindowRect
                 0 WindowRect RECT::left ! \ Set Left Value To 0
   _canvas :width@ WindowRect RECT::right ! \ Set Right Value To Requested Width
                 0 WindowRect RECT::top ! \ Set Top Value To 0
  _canvas :height@ WindowRect RECT::bottom ! \ Set Bottom Value To Requested Height

   SUPER exStyle @ FALSE SUPER style @ WindowRect AdjustWindowRectEx DROP

   WindowRect RECT::bottom @ WindowRect RECT::top @ - _canvas :height!
   WindowRect RECT::right @ WindowRect RECT::left @ - _canvas :width!
   WindowRect FREE THROW

   \ ������ ������������� GL ��������� ����
   _canvas :resize
   
   \ CR ." Changed dimensions to : " _canvas :width@ . _canvas :height@ .
;

W: WM_CREATE ( -- n )
    SUPER hWnd @ _canvas :initialize
    0 ;

: :maximize SW_MAXIMIZE SUPER hWnd @ ShowWindow DROP ;

: :onPaint _canvas :doPaint ;

: :add _canvas :add ;

: :prepare ;

( 
W: WM_PAINT
   :onPaint
   0 ;)

\ timer was created by canvas!
W: WM_TIMER
   :onPaint
   0 ;

W: WM_DESTROY ( -- n )
   0 0 PostQuitMessage DROP
;

W: WM_SIZE ( -- n )
   \ CR ." WM_SIZE"
   SUPER msg lParam @ LOWORD _canvas :width!
   SUPER msg lParam @ HIWORD _canvas :height!
   :resize
   0
;

: :setShift _canvas :setShift ;
: :setAngleSpeed _canvas :setAngleSpeed ;

;CLASS
