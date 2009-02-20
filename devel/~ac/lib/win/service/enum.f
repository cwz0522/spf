\ ������� ������������� � ������� ��������/��������� � �� ���������

REQUIRE {              ~ac/lib/locals.f
REQUIRE OpenSCManagerA ~ac/lib/win/service/service_struct.f 

WINAPI: EnumServicesStatusExA ADVAPI32.DLL
0x0004 CONSTANT SC_MANAGER_ENUMERATE_SERVICE

0
CELL -- ssp.lpServiceName
CELL -- ssp.lpDisplayName
CELL -- ssp.dwServiceType
CELL -- ssp.dwCurrentState
CELL -- ssp.dwControlsAccepted
CELL -- ssp.dwWin32ExitCode
CELL -- ssp.dwServiceSpecificExitCode
CELL -- ssp.dwCheckPoint
CELL -- ssp.dwWaitHint
CELL -- ssp.dwProcessId
CELL -- ssp.dwServiceFlags
CONSTANT /ENUM_SERVICE_STATUS_PROCESS

: ForEachService { par xt \ mem r cnt size ssp -- }
\ ��� ���� ��������, ��������� ���� � ��������� �� ��������� xt ( a u na nu pid state type par -- flag )
\ ��� a u - "�������� ���", na nu - ��� �������, type - ��� (1-�������,2-��.�������,0x10���0x20-������,0x100-�������������)
\ state (1-����������,2-��������,3-���������������,4-��������,5-������������,6-������������������,7-�������������)
\ pid - id ��������
  0 ^ r ^ cnt ^ size 256 1024 * DUP ALLOCATE THROW DUP -> mem 3 0x3B 0 
  0x0004 0 0 OpenSCManagerA EnumServicesStatusExA
  IF
    cnt 0 ?DO
      mem I /ENUM_SERVICE_STATUS_PROCESS * + -> ssp
      ssp ssp.lpDisplayName @ ASCIIZ>
      ssp ssp.lpServiceName @ ASCIIZ>
      ssp ssp.dwProcessId @
      ssp ssp.dwCurrentState @
      ssp ssp.dwServiceType @
      par xt EXECUTE 0= IF UNLOOP EXIT THEN
    LOOP
  THEN
;
\EOF
0 :NONAME . . . . TYPE SPACE TYPE CR TRUE ; ForEachService
