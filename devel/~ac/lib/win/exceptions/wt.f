REQUIRE {              ~ac/lib/locals.f

\ WINAPI: WTSOpenServerA        WTSAPI32.DLL
WINAPI: WTSEnumerateSessionsA WTSAPI32.DLL

0
CELL -- wts.SessionId
CELL -- wts.pWinStationName
CELL -- wts.State \ 0=WTSActive, 1=WTSConnected, 2=WTSConnectQuery, 3=WTSShadow, 4=WTSDisconnected, 5=WTSIdle, 6=WTSListen, 7=WTSReset, 8=WTSDown, 9=WTSInit 
CONSTANT /WTS_SESSION_INFO

: ForEachWTSession { par xt \ cnt ses wts -- }
\ ��� ������ ������������ ������ ��������� xt �� ���������� �����������:
\ ( a u sid state par -- flag ) ��� a u - ��� ������� (Console,RDP-Tcp), sid - id ������ (0,1,65536),
\ state - ��������� (��. ����, ����.4,0,6), par - ���������������� �������� (����. �����������),
\ xt ���������� flag �����������
  ^ cnt ^ ses 1 0 0 WTSEnumerateSessionsA
  IF
    cnt 0 ?DO
      ses I /WTS_SESSION_INFO * + -> wts
      wts wts.pWinStationName @ ASCIIZ> wts wts.SessionId @ wts wts.State @
      par xt EXECUTE 0= IF UNLOOP EXIT THEN
    LOOP
  THEN
;

\ 0 :NONAME . . . TYPE CR TRUE ; ForEachWTSession
