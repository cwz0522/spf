\ ������� ������ �������� ������ ARP-�������
\ ������ ������������� iphlpapi:GetIpNetTable
\ ����������� arp � �������� ��� �����.

( ������� ������������� ��. � ����� ����� )

REQUIRE ChildAppErr ~ac/lib/win/process/child_app.f
REQUIRE PipeLine    ~ac/lib/win/process/pipeline.f
REQUIRE STR@        ~ac/lib/str5.f
REQUIRE GetProcessInfo ~ac/lib/win/process/info.f 
REQUIRE /STRING     lib/include/string.F
REQUIRE GetHostName ~ac/lib/win/winsock/sockets.f 

USER uARP
USER uArpIface

: GetArpIface
  NextWord 2DROP NextWord uArpIface S!
;
: GetArpResults ( -- )
  SOURCE NIP 0= IF EXIT THEN
  SOURCE DROP C@ BL <> IF GetArpIface EXIT THEN

  SOURCE S" 224.0.0." SEARCH NIP NIP IF EXIT THEN \ multicast
  SOURCE S" 239.255.255.250" SEARCH NIP NIP IF EXIT THEN \ upnp broadcast
  SOURCE S" 0.0.0.0" SEARCH NIP NIP IF EXIT THEN \ def
  SOURCE S" ff-ff-ff-ff-ff-ff" SEARCH NIP NIP IF EXIT THEN \ �������

  SOURCE S" -" SEARCH NIP NIP 0= IF EXIT THEN \ ��� mac-������, �.�. �����������
                                              \ �����������������, ���� ���� �������� ��� ������� �������...

  NextWord 2DUP S" ." SEARCH NIP NIP 0= IF 2DROP EXIT THEN
  2DUP " <tr><td class='ip'>{s}</td>" uARP @ S+
  >STR STR@ GetHostIP DROP GetHostName DROP 2>R
  NextWord 2DUP S" -" SEARCH NIP NIP
  IF NextWord ELSE S" -" 2SWAP THEN OEM>ANSI
  2SWAP 2R> 2SWAP 
  " <td class='mac'>{s}</td><td class='host'>{s}</td><td class='type'>{s}</td>" uARP @ S+
  uArpIface @ STR@ " <td class='if'>{s}</td></tr>{CRLF}" uARP @ S+
;

: ReadArpReply { l -- }
  BEGIN
    l PipeReadLine \ DUP IF ." =>" 2DUP TYPE ." <=" CR ELSE CR THEN
    ['] GetArpResults ['] EVALUATE-WITH CATCH
    ?DUP IF ." arp_err=" . 2DROP 2DROP THEN
  AGAIN
;
: (ArpHtml) { \ l -- }
  CreateStdPipes
  S" arp.exe -a" ChildAppErr THROW

  \  -1 OVER WaitForSingleObject DROP CLOSE-FILE THROW
  CLOSE-FILE DROP 

  ( ����� ������ � stdin �������)

  StdinWH @ CLOSE-FILE THROW

  StdoutRH @ PipeLine -> l
  l ['] ReadArpReply CATCH IF DROP THEN
  l FREE THROW
  StdoutRH @ CLOSE-FILE THROW

\  StderrRH @ PipeLine -> l
\  ta tu l ['] ReadArpReply CATCH IF DROP 2DROP THEN
\  l FREE THROW
  StderrRH @ CLOSE-FILE THROW
;
: ArpHtml ( -- addr u )
  " <table class='sortable' id='sp_table' cellpadding='0' cellspacing='0'>
<thead><tr class='sp_head'><th class='ip'>IP</th><th class='mac'>MAC</th><th class='host'>���</th>
<th class='type'>���</th><th class='if'>���������</th></tr></thead>
<tbody>"
  uARP !
  ['] (ArpHtml) CATCH ?DUP IF ." arp_err=" . THEN
  " </tbody></table>" uARP @ S+
  uARP @ STR@
;

\EOF �������� �������� ��-�� GetHostIP
SocketsStartup DROP
ArpHtml TYPE CR
