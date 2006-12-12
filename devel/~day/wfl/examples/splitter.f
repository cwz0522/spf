( The very simple example )

REQUIRE WL-MODULES ~day\lib\includemodule.f
NEEDS ~day\wfl\wfl.f
NEEDS ~day\wfl\controls\splitter.f

( ������ � ������� ��������� ������ )

CPanel SUBCLASS CPercentPanel

: drawPercent ( dc )
    || R: dc CRect r ||
    SUPER getClientRect r !

    DT_VCENTER DT_CENTER OR DT_SINGLELINE OR
    r addr
    SUPER getPercent 100 / S>D <# [CHAR] % HOLD #S #> SWAP
    dc @
    DrawTextA SUPER -wthrow
;

W: WM_PAINT
    2DROP 2DROP
    || CPaintDC dc ||
    SUPER hWnd @ dc create
    DUP TRANSPARENT SWAP SetBkMode SUPER -wthrow
    drawPercent
    0
;

;CLASS

CFrameWindow SUBCLASS CVerySimpleWindow

       CSplitterController OBJ hsplitter
       CSplitterController OBJ vsplitter
       CPercentPanel       OBJ leftPane
       CPercentPanel       OBJ rightPane

W: WM_CREATE
   2DROP 2DROP
   hsplitter setHorizontal

   \ ������� �������� �������
    \ ���������� ��� ������� � ������ ������

   SELF hsplitter createPanels
   SELF hsplitter createSplitter

   \ ����� �������
    \ �� �������� �� �������� � �������� �������� �������
     \ ���������� �������� �� ������������� ������� (�������� win ����)
   
   hsplitter getUpperPane ( �������� )
   leftPane this OVER vsplitter setLeftPane
   rightPane this OVER vsplitter setRightPane

   vsplitter createSplitter
   0
;

W: WM_DESTROY ( lpar wpar msg hwnd -- n )
   2DROP 2DROP 0
   0 PostQuitMessage DROP
;

;CLASS

: winTest ( -- n )
  || CVerySimpleWindow wnd CMessageLoop loop ||

  0 wnd create DROP
  SW_SHOW wnd showWindow

  loop run
;

winTest