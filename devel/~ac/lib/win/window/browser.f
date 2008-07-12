\ ���������� ������ �������� ����������� ���������� IE
\ ��� ��������� ������ ����������.
\ �������� ����� ( urla urlu ) Browser � BrowserThread.
\ ���� NewBrowserWindow+AtlMainLoop. ��. ������� � �����.

\ ������������� ������ ��� �������� TAB:
\ ��.���� IOleInPlaceActiveObject::TranslateAccelerator
   \ ������������, ��� ���� ��� � TAB'�� ������ �����:
   \ http://www.microsoft.com/0499/faq/faq0499.asp
   \ �� ���� URL MS �������, ���������� ��������� � ������ :)
   \ � ������ ����������� ��� � AtlAx.
\ ������������ � ����������� ������ ~day/wfl.

\ + 07.07.2008 ��� ��� ��������� �������.

REQUIRE {                lib/ext/locals.f
REQUIRE Window           ~ac/lib/win/window/window.f
REQUIRE WindowTransp     ~ac/lib/win/window/decor.f
REQUIRE LoadIcon         ~ac/lib/win/window/image.f 
REQUIRE IID_IWebBrowser2 ~ac/lib/win/com/ibrowser.f 
REQUIRE NSTR             ~ac/lib/win/com/variant.f 
REQUIRE EnumConnectionPoints ~ac/lib/win/com/events.f 
REQUIRE IID_IWebBrowserEvents2 ~ac/lib/win/com/browser_events.f 
REQUIRE IID_IHTMLDocument3 ~ac/lib/win/com/ihtmldocument.f 

\ ������ ��� BrowserThread:
REQUIRE STR@             ~ac/lib/str5.f

WINAPI: AtlAxWinInit     ATL.dll
WINAPI: AtlAxGetControl  ATL.dll

VARIABLE BrTransp \ ���� �� ����, �� ������ ������� ������������ ���������
VARIABLE BrEventsHandler \ ���� �� ����, �� ��� ����������� �������� ����������
                         \ ���������� ��� ������� (������ � ��-�������� Browser)
SPF.IWebBrowserEvents2 BrEventsHandler !

: TranslateBrowserAccelerator { mem iWebBrowser2 \ oleip -- flag }
  \ ������� ��������, �� �������� �� ������� ���������� �������������
  mem CELL+ @ WM_KEYDOWN =
  IF
    ^ oleip IID_IOleInPlaceActiveObject iWebBrowser2 ::QueryInterface 0= oleip 0 <> AND
    IF
      mem oleip ::TranslateAccelerator \ ���������� 1 ��� wm_char'���
                                       \ �������, ������� ����� ������������ ������
    ELSE TRUE THEN
  ELSE TRUE THEN
     \ 1, ���� �� �����������
     \ -1 ��� ���� �� ������� ��������� ��� ������ �� �������
     \ �.�. ����� = true, ���� ����� ���������� � ������� �������
  0= \ ����������� ���� ��� �������� TranslateAcceleratorA
;

: WindowGetMessage { mem wnd -- flag }
\ ����������� ������������� ���������� ����� MessageLoop
\ ��� ����������� WndProc
  wnd IsWindow
  IF
    0 0 0 mem GetMessageA 0 >
    mem CELL+ @ WM_CLOSE <> AND
    mem CELL+ @ WM_QUIT <> AND
  ELSE FALSE THEN
  DUP IF DEBUG @ 
         IF mem CELL+ @ WM_SYSTIMER <>
            mem CELL+ @ WM_TIMER <> AND
            IF mem 16 DUMP CR THEN
         THEN
      THEN
;

VECT vPreprocessMessage ( msg -- flag )
\ ����������� "������" � ���� �������� ��������� �������
\ ��� ����������/������������� ��-������, �� ��������� �����������.
\ ���� ���������� TRUE, �� ��������� ��������� ������������ � ����� �� ���������.

VECT vContextMenu ( msg -- ) ' DROP TO vContextMenu

: PreprocessMessage1 ( msg -- flag )
  DUP CELL+ @ WM_RBUTTONUP =
  IF vContextMenu TRUE
  ELSE DROP FALSE THEN
;
' PreprocessMessage1 TO vPreprocessMessage

: AtlMessageLoop  { wnd iWebBrowser2 \ mem -- }

\ ���� ���������� ��������� �� ���� ���������� ����,
\ com-��������� �������� � ����� ������������� ���� �������� � �������� 
\ ����������. �� ���������� �� ��� ������� ������ (0 � GetMessage), �.�.
\ ����� �� ������������ �������� ���� - ���������� �������.
\ ���� ����� ��������� ���������� ���� - ��. BrowserThread
\ ���� AtlMainLoop ����.

  /MSG ALLOCATE THROW -> mem
  BEGIN
    mem wnd WindowGetMessage
  WHILE
    mem vPreprocessMessage 0=
    IF
      mem iWebBrowser2 TranslateBrowserAccelerator 0=
      IF
        \ ��� ����� ��������� ����� TranslateAccelerator, ���� ���� ���� ����
        mem TranslateMessage DROP
        mem DispatchMessageA DROP
      THEN
    THEN
  REPEAT
  mem FREE THROW
;
: Navigate { addr u bro -- res }
  S" " NSTR   \ headers
  0 VT_ARRAY VT_UI1 OR NVAR \ post data
  S" " NSTR    \ target frame name
  0 VT_I4 NVAR \ flags

  addr u NSTR bro ::Navigate2
;
VARIABLE AtlInitCnt

: BrowserSetIcon1 { addr u h -- }
\ ����� � ����������� �� ���� �������� ������, �� � stub'� �� ������������
  1 LoadIconResource16 GCL_HICON h SetClassLongA DROP
;
VECT vBrowserSetIcon ' BrowserSetIcon1 TO vBrowserSetIcon

: BrowserSetTitle1 { addr u h -- }
  addr u
  " {s} -- SP-Forth embedded browser" STR@ DROP h SetWindowTextA DROP
;
VECT vBrowserSetTitle ' BrowserSetTitle1 TO vBrowserSetTitle

: BrowserSetMenu1 { addr u h -- }
;
VECT vBrowserSetMenu ' BrowserSetMenu1 TO vBrowserSetMenu

: BrowserInterface { hwnd \ iu bro -- iwebbrowser2 ior }
  ^ iu hwnd AtlAxGetControl DUP 0=
  IF
    DROP
    ^ bro IID_IWebBrowser2 iu ::QueryInterface DUP 0=
    IF
      bro SWAP
    ELSE ." Can't get browser" DUP . 0 SWAP THEN
  ELSE ." AtlAxGetControl error" DUP . 0 SWAP THEN
;
USER uBrowserInterface \ ��� ������ "���� ���� �� �����" ����� ����� �� �������
USER uBrowserWindow

/COM_OBJ \ ��������� �� VTABLE ������ ����������� WebBrowserEvents2, � ��.����.
CELL -- b.BrowserThread
CELL -- b.BrowserWindow
CELL -- b.BrowserInterface
CELL -- b.BrowserMainDocument \ IDispatch, � �������� ����� �������� IHTMLDocument,2,3
CELL -- b.HtmlDoc2
CELL -- b.HtmlDoc3
\ ��������� ����� �������� � ��������
CONSTANT /BROWSER

: BrowserWindow { addr u style parent_hwnd \ h bro b -- hwnd }
\ ������� ���� �������� � ��������� URL addr u � ����.
  AtlInitCnt @ 0= IF AtlAxWinInit 0= IF 0x200A EXIT THEN AtlInitCnt 1+! THEN
  0 0 0 parent_hwnd 0 CW_USEDEFAULT 0 CW_USEDEFAULT style addr S" AtlAxWin" DROP 0
  CreateWindowExA -> h
  h 0= IF EXIT THEN

  addr u h vBrowserSetTitle
  addr u h vBrowserSetIcon
  addr u h vBrowserSetMenu
  BrTransp @ ?DUP IF h WindowTransp THEN

  h uBrowserWindow !

\ PAD bro ::get_AddressBar .
  h BrowserInterface ?DUP IF NIP THROW THEN -> bro
  bro uBrowserInterface !

  BrEventsHandler @ ?DUP
  IF /BROWSER SWAP NewComObj -> b \ � ������������ ������� ���� ���-�� ���� ��������...
     TlsIndex@ b b.BrowserThread !
     h         b b.BrowserWindow !
     bro       b b.BrowserInterface !
     b IID_IWebBrowserEvents2 bro ConnectInterface \ ������� ������� ��������� �������
  THEN
  h
;

: Browser { addr u \ h -- ior }

  addr u WS_OVERLAPPEDWINDOW 0 BrowserWindow -> h
  h 0= IF 0x200B EXIT THEN

  h WindowShow
  h uBrowserInterface @ AtlMessageLoop 0
  h WindowDelete
  0
;
: AtlMainLoop  { hwnd \ mem -- }
\ ���� ���������� �������� � �������� �������� �������� �����.
\ ����� ����������� ����� ��������� ���������� ���� � ����� ������,
\ ������ �� ����������� ����� �������.
\ ����� "�������� ����" hwnd, ����� ������ ��� ���� ����� ������,
\ ����� ����� �����������...

  /MSG ALLOCATE THROW -> mem
  BEGIN
    hwnd IsWindow
    IF
      0 0 0 mem GetMessageA 0 >
    ELSE FALSE THEN
  WHILE
    mem CELL+ @ WM_KEYDOWN =
    IF
      mem @ GA_ROOT OVER GetAncestor BrowserInterface ( i ior )
      IF DROP TRUE
      ELSE mem SWAP TranslateBrowserAccelerator 0= THEN
    ELSE TRUE THEN

    IF
      mem TranslateMessage DROP
      mem DispatchMessageA DROP
    THEN
  REPEAT
  mem FREE THROW
;

: NewBrowserWindow { addr u \ h -- h }
\ C������ ���������� ���� c ����� addr u � ������� ��� �����
\ ��� ���������� ���������. 
\ ����� �������� ���� ���� ����� ��������� ���� AtlMainLoop.
  addr u WS_OVERLAPPEDWINDOW 0 BrowserWindow
  DUP WindowShow
;
:NONAME ( url -- ior )
  STR@ ['] Browser CATCH ?DUP IF NIP NIP THEN
; TASK: (BrowserThread)

: BrowserThread ( addr u -- )
\ ������ �������� � ��������� ������.
  >STR (BrowserThread) START DROP
;
:NONAME ( url -- ior )
  STR@ ['] Browser CATCH ?DUP IF NIP NIP THEN
  BYE
; TASK: (BrowserMainThread)

: BrowserMainThread ( addr u -- )
\ ������ �������� � ��������� ������.
\ ��� �������� ��� ���� ��������� ����������.
  >STR (BrowserMainThread) START DROP
;

\ ������������� ��������� ����������� ������� �� ��������:


GET-CURRENT SPF.IWebBrowserEvents2 SpfClassWid SET-CURRENT

ID: DISPID_DOCUMENTCOMPLETE 259 { urla urlu bro \ obj tls doc doc2 doc3 -- }
    \ =onload
    ." @DocumentComplete! doc=" bro . \ IWebBrowser2 ������������ ������
    uOID @ -> obj
    TlsIndex@ -> tls
    obj b.BrowserThread @ TlsIndex!
    bro uBrowserInterface @ = 
    IF \ ���� �������� �������� ������, �� ��� DocumentComplete ��������� ��� ����� �������� �������
       ^ doc bro ::get_Document DROP \ ��������� ������� �� ������ ��������
       doc . CR
       doc obj b.BrowserMainDocument !
       ^ doc3 IID_IHTMLDocument3 doc ::QueryInterface 0= doc3 0 <> AND
       IF doc3 obj b.HtmlDoc3 !
\ ������:
\         ^ elcol S" TITLE" >BSTR doc3 ::getElementsByTagName . elcol . CR
       THEN

       ^ doc2 IID_IHTMLDocument2 doc ::QueryInterface 0= doc2 0 <> AND
       IF doc2 obj b.HtmlDoc2 ! THEN

\       ^ disp IID_DispHTMLDocument doc ::QueryInterface 0= disp 0 <> AND
\       IF ." ---" THEN

       doc2 IF
\ �������, ������ �������� ����� ���������:
\         uCRes doc2 ::get_title THROW uCRes @ UASCIIZ> UNICODE> TYPE CR
\         S" title" doc2 CP@ TYPE CR
\         S" New TITLE" >BSTR doc2 ::put_title THROW
\         S" New TITLE" >VBSTR 1 S" title" doc2 CP!
\         S" <H1>TEST</H1>" >SARR doc2 ::write ." wr=" .
\         S" <H1>TEST</H1>" >VBSTR 1 S" write" doc2 CNEXEC .

\ � ����������:
\          doc S" title" doc2 CP@
\          " {s} (�������� doc={n})" STR@ >BSTR doc2 ::put_title THROW
       THEN
    THEN
    urla urlu TYPE CR
    tls TlsIndex!
;
ID: DISPID_STATUSTEXTCHANGE   102 ( addr u -- )
    ." @StatusTextChange:" TYPE CR
;
ID: DISPID_TITLECHANGE    113  ( addr u -- )
    \ sent when the document title changes
   ." @Title:" 2DUP TYPE CR
    uOID @ b.BrowserWindow @ ?DUP IF vBrowserSetTitle ELSE 2DROP THEN
;
SET-CURRENT

\EOF
\ ��� ���� �� ��������� �������� �����, �������� ���� �� ����.
\ TRUE COM-DEBUG !
S" http://127.0.0.1:89/index.html" BrowserThread
S" http://127.0.0.1:89/email/" BrowserThread

\EOF
\ ������ ��������� ���������� ����������������� ���������� ���� ����� ������.
\ ���� ������� ���� � ��� �������������� ����������� "���������" ����� ���.
: TEST1 { \ h }
  S" http://127.0.0.1:89/index.html" NewBrowserWindow -> h
  128 BrTransp !
  S" http://127.0.0.1:89/email/" 0 h BrowserWindow
     DUP 500 400 ROT WindowSize DUP 90 90 ROT WindowRC WindowShow
  S" http://127.0.0.1:89/chat/" WS_OVERLAPPEDWINDOW h BrowserWindow
     DUP 300 300 ROT WindowSize WindowShow
  h AtlMainLoop
  ." done"
; TEST1
