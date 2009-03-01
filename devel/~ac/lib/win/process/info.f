\ ������������/���������� ��� enumproc.f - ��������� ��������� �-�� ������� � ������� ���� ���������.
\ ��. ������� � ����� �����.

REQUIRE {              ~ac/lib/locals.f
REQUIRE ForEachProcess ~ac/lib/win/process/enumproc.f
REQUIRE WildCMP-U      ~pinka/lib/mask.f
REQUIRE WinVer         ~ac/lib/win/winver.f 

WINAPI: NtQuerySystemInformation NTDLL.DLL
WINAPI: OpenProcess              KERNEL32.DLL
WINAPI: GetProcessImageFileNameA PSAPI.DLL \ ������� WinXP, ���������� ���� � device name
WINAPI: GetModuleFileNameExA     PSAPI.DLL \ ������� Win2000, ���� ���� ������ ��� ��������� �������� ������������
WINAPI: QueryFullProcessImageNameA KERNEL32.DLL \ ������� Vista/2008

 0
 4 -- nqsi.NextEntryOffset
52 -- nqsi.Reserved1
12 -- nqsi.Reserved2
 4 -- nqsi.UniqueProcessId
 4 -- nqsi.Reserved3
 4 -- nqsi.HandleCount      \ "�����������" � taskmgr
 4 -- nqsi.Reserved4
44 -- nqsi.Reserved5
 4 -- nqsi.PeakPagefileUsage
 4 -- nqsi.PrivatePageCount \ "���������� ������" (� ������) � taskmgr
48 -- nqsi.Reserved6
CONSTANT /SYSTEM_PROCESS_INFORMATION

5 CONSTANT SystemProcessInformation

: ForEachProcess2 { par xt \ r pi pid a u hc mem fi it h n fn -- pid }
\ ��� ������� �������� ��������� xt �� ���������� �����������:
\ ( a u mem hc pid par -- flag ) a u - ���� � ��� ����� ��������, mem - ���������� ������,
\ hc - �-�� �������, pid - ID ��������, par - ���������������� �������� (����. �����������),
\ xt ���������� flag �����������
\ a u �� ������ ������ ��������� � PAD ! ( ��� ��������� ������ � GetProcessInfo :)
\ �������: pid - �������, �� ������� ���������� ������� (pid=0 ��������), ��� -1, ���� �������� ���
  -1 -> n
  ^ r 300 1024 * DUP ALLOCATE THROW DUP -> pi SystemProcessInformation NtQuerySystemInformation 0= r 0 > AND
  IF
    \ 1024 ALLOCATE THROW -> fi
    PAD 100 + -> fi
    pi
    BEGIN
      DUP
    WHILE
      DUP nqsi.UniqueProcessId @ -> pid
          pid 0 0x0410 OpenProcess DUP 0= IF DROP pid 0 0x1000 OpenProcess THEN
          DUP
          IF -> h
             WinVer 50 = ( Win2000) IF 900 fi 0 h GetModuleFileNameExA fi SWAP THEN \ ������ ������� ������������
             WinVer 51 60 WITHIN ( XP) IF fi 900 fi h GetProcessImageFileNameA >R fi ASCIIZ> R> MIN THEN \ ��� WinXP ���: ������� ���������� ��������� (unicode?) ����� ������
             WinVer 59 > ( Vista/2008/W7) IF 900 -> fn ^ fn fi 0 h QueryFullProcessImageNameA IF fi fn ELSE S" " THEN THEN
             h CLOSE-FILE THROW
          ELSE DROP ( GetLastError ." err=" .) S" " THEN -> u -> a
      DUP nqsi.HandleCount @ -> hc
      DUP nqsi.PrivatePageCount @ -> mem
      -> it ( �������� xt ������ ����, �� ������ �������� )
         a u mem hc pid par xt EXECUTE
      IF it DUP nqsi.NextEntryOffset @ DUP IF + ELSE 2DROP 0 THEN
      ELSE pid -> n 0 THEN
    REPEAT DROP
    \ fi FREE THROW
  THEN pi FREE THROW
  n
;
: (GetProcessInfo) ( a u mem hc pid par -- ... flag )
  = IF FALSE
    ELSE 2DROP 2DROP TRUE THEN
;
: GetProcessInfo ( pid -- a u mem hc ) \ a u � PAD
  ['] (GetProcessInfo) ForEachProcess2
  -1 = IF S" process-not-found" 0 0 THEN
;
: (GetProcessInfoByName) { a u mem hc pid nu -- ... flag }
  ( na ) DUP nu a u 2SWAP WildCMP-U 0= IF DROP a u mem hc pid FALSE ELSE TRUE THEN
;
: GetProcessInfoByName ( na nu -- a u mem hc pid )
  ['] (GetProcessInfoByName) ForEachProcess2
  -1 = IF DROP S" process-not-found" 0 0 0 THEN
;
: ProcessEx. ( -- ) \ ���������� Process. �� enumproc.f ( ' ProcessEx. ForEachProcess )
  DUP P32.th32ProcessID @ .
  DUP P32.szExeFile ASCIIZ> TYPE SPACE
  DUP P32.cntThreads @ .
      P32.th32ProcessID @ GetProcessInfo . . TYPE CR
;

\EOF �������:
\ ����������� ������ 10 ��������� � ����������:
10 PAD :NONAME ( ... a u mem hc pid par -- flag ) DUP 1+! @ . . . . TYPE 1- DUP CR ; ForEachProcess2 . DROP CR CR

\ �������� ���������� � �������� � pid=788
788 GetProcessInfo . . TYPE CR
S" *acWEB.exe" GetProcessInfoByName . . . TYPE CR CR

\ ����������� ���������� � ���� ���������
' ProcessEx. ForEachProcess
WinVer .
