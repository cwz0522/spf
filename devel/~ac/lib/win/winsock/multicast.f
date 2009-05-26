\ ��������� IP-multicast (������� � Windows XP)

REQUIRE ReadFrom  ~ac/lib/win/winsock/sockname.f
REQUIRE ForEachIP ~ac/lib/win/winsock/foreach_ip.f 

WINAPI: getsockopt      WSOCK32.DLL

\ struct ip_mreq {
\         struct in_addr  imr_multiaddr;  /* IP multicast address of group */
\         struct in_addr  imr_interface;  /* local IP address of interface */
\ };

\ 5 CONSTANT IP_ADD_MEMBERSHIP
\ 6 CONSTANT IP_DROP_MEMBERSHIP
\ ��� � ���� ����� ����� winsock.h, ���������� �������� � ws2ipdef

 9 CONSTANT IP_MULTICAST_IF
12 CONSTANT IP_ADD_MEMBERSHIP
13 CONSTANT IP_DROP_MEMBERSHIP

: SocketAddMembership ( ip_if ip_mc s -- ior )
\ ��������� ��������� �����������!
  >R 8 ALLOCATE ?DUP IF NIP RDROP EXIT THEN
  >R
  R@ !
  R@ CELL+ !
  8 R> IP_ADD_MEMBERSHIP 0 ( IPPROTO_IP) R> setsockopt SOCKET_ERROR =
  IF WSAGetLastError ELSE 0 THEN
;
: SocketSetMcInterface ( ip s -- ior )
  >R
  SP@ 4 SWAP IP_MULTICAST_IF 0 ( IPPROTO_IP) R> setsockopt NIP SOCKET_ERROR =
  IF WSAGetLastError ELSE 0 THEN
;
: SocketGetMcInterface ( s -- ip ior )
  4 >R RP@ 0 >R RP@
  ROT >R
  IP_MULTICAST_IF 0 ( IPPROTO_IP) R> getsockopt SOCKET_ERROR =
  IF WSAGetLastError ELSE 0 THEN
  R> RDROP SWAP
;
: CreateMcSocket ( -- socket ior )
  0 SOCK_DGRAM PF_INET
  socket DUP INVALID_SOCKET =
  IF WSAGetLastError
  ELSE
     DUP ReuseAddrSocket THROW
     0
  THEN
;
USER uMC_IP
USER uMC_SOCK
USER uMC_CNT

: (CreateMcListener) ( ip -- ) \ throwable
\ ." cml:" DUP NtoA TYPE SPACE
  uMC_IP @ uMC_SOCK @ SocketAddMembership ?DUP
  IF \ ������ 10022 ����� ����� �������� ��� ������������ ��������� (���� ��������� IP �� ����������)
    DROP \ . CR
  ELSE uMC_CNT 1+!
    \ ." ok" CR
  THEN
;
: CreateMcListener ( mc_ip_a mc_ip_u mc_port -- socket cnt ) \ throwable
  >R GetHostIP THROW R>
  CreateMcSocket THROW >R
  0 R@ BindSocketInterface THROW \ ������� ��������� ���� �� ���� �����������
  ( mc_ip ) uMC_IP ! \ �������� ForEachIP ������ �� ����� ������ IP, ������� �������� � xt ���.��������� ������
  R@ uMC_SOCK !
  uMC_CNT 0!
  ['] (CreateMcListener) ForEachIP \ ���������� ����� � ��������� multicast-������ �� ���� �����������
  R> uMC_CNT @
;
: SsdpGroup S" 239.255.255.250" ; \ multicast-������ ��� Simple Service Discovery Protocol
1900 CONSTANT SsdpPort

\EOF

\ ������ ����������� � SSDP-����������.
\ ������� �������� �� ����������, ������ �������������� ���.
\ ���� UPnP-��������� (���������������, �������������, �������������,...)
\ � ���� ���, �� ����� �������� ����� ;)

REQUIRE STR@         ~ac/lib/str5.f

: MC-DUMP
  SocketsStartup THROW

  SsdpGroup SsdpPort CreateMcListener ?DUP
  IF
   ." �������� � " . ." �����������. ������..." CR
   >R
   BEGIN
     PAD 1500 R@ ReadFrom ." A:"
     . NtoA TYPE CR 
     PAD SWAP TYPE CR ." -----------------------------" CR
   AGAIN
   RDROP
  ELSE ." �� ���� ������������ � multicast-������" CR THEN
;
MC-DUMP
