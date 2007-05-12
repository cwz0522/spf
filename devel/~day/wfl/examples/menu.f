( The very simple example )

REQUIRE WL-MODULES ~day\lib\includemodule.f
NEEDS ~day\wfl\wfl.f

101 CONSTANT HOORAY_ID
102 CONSTANT BEEP_ID

WINAPI: MessageBeep USER32.DLL

CFrameWindow SUBCLASS CVerySimpleWindow

W: WM_DESTROY ( lpar wpar msg hwnd -- n )
   2DROP 2DROP 0
   0 PostQuitMessage DROP
;

M: HOORAY_ID ( -- )
   S" ���!" SUPER showMessage
;

M: BEEP_ID ( -- )
   MB_OK MessageBeep DROP
;

: createMenu \ -- h
    MENU
       S" ���"  HOORAY_ID MF_GRAYED MENUITEM
       POPUP
          S" ���2" HOORAY_ID 0 MENUITEM
       S" ���" END-POPUP

       POPUP
          S" Beep" BEEP_ID 0 MENUITEM
          S" Beep2" BEEP_ID 0 MENUITEM
       S" ��������" END-POPUP    
    END-MENU
;    

;CLASS

: winTest ( -- n )
  || CVerySimpleWindow wnd CMessageLoop loop ||

  0 wnd create DROP
  SW_SHOW wnd showWindow

  loop run
;

winTest