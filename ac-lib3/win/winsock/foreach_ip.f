( 25.04.2001 [C] Andrey Cherezov mailto:spf@users.sourceforge.net )
( ForEachIP - ���������� ��������� �������� ��� ������� IP �����,
              �� ������� ��� �����������. ���������, �����������
              ���� ������, ������ ����� ������� 3 IP:
              127.0.0.1     [������] - localhost
              10.1.1.1      [������] - ����� LAN-����������
              194.186.20.62 [������] - ����� WAN-����������
)
\ ��������� 23.01.2002: �������� ExternIP ��� ��� ����������,
\ ��� �������� �� NAT-proxy, �� ����� ������� ��� IP �����

REQUIRE {            ~ac/lib/locals.f
REQUIRE CreateSocket ~ac/lib/win/winsock/sockets.f

VARIABLE ExternIP

: ExternIP:
  NextWord 2DUP + 0 SWAP C!
  GetHostIP IF DROP 0 THEN
  ExternIP !
;

: ForEachIP { xt \ addr -- ior }
\ xt - ��������� ( IP -- ), ����������� ��� ������� IP
  255 PAD gethostname 0=
  IF \ PAD ASCIIZ> TYPE ."  - localhost name" CR
     PAD gethostbyname
     DUP IF -> addr
            \ addr @ ASCIIZ> TYPE ."  - domain name" CR
            0
            addr @
            addr CELL+ CELL+ CELL+ @ @
            DO I @ 4 +LOOP
            0x0100007F xt EXECUTE \ localhost
            ExternIP @ ?DUP IF xt EXECUTE THEN
            BEGIN
              DUP
            WHILE
              \ HostName. CR
              xt EXECUTE
            REPEAT
         ELSE DROP WSAGetLastError THEN
  ELSE WSAGetLastError THEN
;
: IsMyIP { ip \ addr sp -- flag }
  ip 0x0100007F = IF TRUE EXIT THEN
  ExternIP @ ?DUP IF ip = IF TRUE EXIT THEN THEN
  255 PAD gethostname 0=
  IF 
     PAD gethostbyname
     DUP IF -> addr
            SP@ -> sp
            0
            addr @
            addr CELL+ CELL+ CELL+ @ @
            DO I @ 4 +LOOP
            BEGIN
              DUP
            WHILE
              ip = IF sp SP! TRUE EXIT THEN
            REPEAT
         ELSE DROP FALSE THEN
  ELSE FALSE THEN
;
: IsMyHostname ( addr u -- flag )
  GetHostIP IF DROP FALSE EXIT THEN
  IsMyIP
;
(
SocketsStartup . CR 
ExternIP: 194.186.20.1
: TEST NtoA TYPE SPACE ; ' TEST ForEachIP CR . CR
1 IsMyIP . CR
S" 127.0.0.1" GetHostIP THROW IsMyIP . CR
S" 10.1.1.1" GetHostIP THROW IsMyIP . CR
S" ac" IsMyHostname . CR
S" localhost" IsMyHostname . CR
S" somehost.com" IsMyHostname . CR
S" 194.186.20.1" IsMyHostname . CR
)
