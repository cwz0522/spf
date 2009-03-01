\ ������� ������ �������� ������ IP-����������
\ ������ ������������� iphlpapi:GetTcpTable (��� � Eserv/3)
\ ����������� netstat � �������� ��� �����.
\ �������������� ���� - ������� ����������� �� ������ �� -
\ �� Win2000, � ������� ��� ���������� ���� (pid), ������
\ ������ "System" ������ �������� ���������.
\ fixme: �� �������� ��� � ����� "-o" � netstat ��� :)

( ������� ������������� ��. � ����� ����� )

REQUIRE ChildAppErr ~ac/lib/win/process/child_app.f
REQUIRE PipeLine    ~ac/lib/win/process/pipeline.f
REQUIRE STR@        ~ac/lib/str5.f
REQUIRE GetProcessInfo ~ac/lib/win/process/info.f 
REQUIRE /STRING     lib/include/string.F

USER uNS
USER uNSpid

: TCP
  SkipDelimiters [CHAR] : PARSE 2DUP S" 0.0.0.0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DUP S" 0" COMPARE 0= IF 2DROP S" " THEN 2>R
  SkipDelimiters [CHAR] : PARSE 2DUP S" 0.0.0.0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DUP S" 0" COMPARE 0= IF 2DROP S" " THEN
  2R> 2R> 2R> " <td>{s}</td><td>{s}</td><td>{s}</td><td>{s}</td>" STR@
  NextWord NextWord 0 0 2SWAP >NUMBER 2DROP D>S
  DUP uNSpid @ = uNSpid @ TRUE = OR
  IF
    DUP GetProcessInfo 2DROP 2DUP CUT-PATH NIP /STRING DUP 0= IF 2DROP S" System" THEN
    ROT
    " <tr class='sp_data'><td>TCP</td><td>{n}</td><td>{s}</td><td>{s}</td>{s}</tr>{CRLF}"
    uNS @ S+
  ELSE DROP 2DROP 2DROP THEN
;
: UDP
  SkipDelimiters [CHAR] : PARSE 2DUP S" 0.0.0.0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DUP S" 0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DROP
  2R> 2R> " <td>{s}</td><td>{s}</td><td></td><td></td>" STR@
  S" " NextWord 0 0 2SWAP >NUMBER 2DROP D>S
  DUP uNSpid @ = uNSpid @ TRUE = OR
  IF
    DUP GetProcessInfo 2DROP 2DUP CUT-PATH NIP /STRING DUP 0= IF 2DROP S" System" THEN
    ROT
    " <tr class='sp_data'><td>UDP</td><td>{n}</td><td>{s}</td><td>{s}</td>{s}</tr>{CRLF}"
    uNS @ S+
  ELSE DROP 2DROP 2DROP THEN
;
: NETSTAT
  S" command line error" uNS @ STR+
;

: GetNetStatResults { ta tu -- }
  SOURCE S" ::" SEARCH NIP NIP IF EXIT THEN
  SOURCE S" NETSTAT" SEARCH NIP NIP IF SOURCE EVALUATE EXIT THEN
  SOURCE ta tu SEARCH NIP NIP 0= IF EXIT THEN

  SOURCE S" TCP" SEARCH NIP NIP
  SOURCE S" UDP" SEARCH NIP NIP OR
  0=
  IF EXIT
  ELSE
     SOURCE EVALUATE
  THEN
;

: ReadNetStatReply { ta tu l -- }
  BEGIN
    l PipeReadLine \ DUP IF ." =>" 2DUP TYPE ." <=" CR ELSE CR THEN
    ta tu 2SWAP ['] GetNetStatResults ['] EVALUATE-WITH CATCH
    ?DUP IF ." ns_err=" . 2DROP 2DROP THEN
  AGAIN
;
: (NetStatHtml) { ta tu \ l -- }
  CreateStdPipes
  S" netstat.exe -ona" ChildAppErr THROW

  \  -1 OVER WaitForSingleObject DROP CLOSE-FILE THROW
  CLOSE-FILE DROP 

  ( ����� ������ � stdin �������)

  StdinWH @ CLOSE-FILE THROW

  StdoutRH @ PipeLine -> l
  ta tu l ['] ReadNetStatReply CATCH IF DROP 2DROP THEN
  l FREE THROW
  StdoutRH @ CLOSE-FILE THROW

\  StderrRH @ PipeLine -> l
\  ta tu l ['] ReadNetStatReply CATCH IF DROP 2DROP THEN
\  l FREE THROW
  StderrRH @ CLOSE-FILE THROW
;
: NetStatHtml<  ( -- )
  " <table class='sortable' id='sp_table' cellpadding='0' cellspacing='0'>
<thead><tr class='sp_head'><th class='proto'>����</th><th class='pid'>pid</th><th class='process'>�������</th>
<th class='state'>���������</th><th class='ip'>IP</th><th class='port'>�</th><th class='rip'>IP</th><th class='rport'>�</th></tr></thead>
<tbody>"
  uNS !
;
: >NetStatHtml  ( -- addr u )
  " </tbody></table>" uNS @ S+
  uNS @ STR@
;
: >NetStatHtml< ( ta tu pid -- )
  uNSpid !
  ['] (NetStatHtml) CATCH ?DUP IF ." ns_err=" . 2DROP THEN
;
: NetStatHtml ( ta tu pid -- addr u ) \ ��� pid=-1 - ���
  NetStatHtml<
  >NetStatHtml<
  >NetStatHtml
;
: NetStatPort ( port -- addr u )
  " :{-} " STR@
;
: NetStatAddProc ( addr u -- )
  S" " 2SWAP " *{s}" STR@ GetProcessInfoByName NIP NIP NIP NIP >NetStatHtml<
;

\EOF

\ ������ �� ��������� ����������
S" " TRUE NetStatHtml TYPE CR
S" ESTABLISHED" TRUE NetStatHtml TYPE CR
S" LISTENING" TRUE NetStatHtml TYPE CR
S" TIME_WAIT" TRUE NetStatHtml TYPE CR
S" CLOSE_WAIT" TRUE NetStatHtml TYPE CR
S" UDP" TRUE NetStatHtml TYPE CR

\ �� ������:
NetStatHtml<   S" :25 " TRUE >NetStatHtml<  S" :110 " TRUE >NetStatHtml<  S" :143 " TRUE >NetStatHtml< >NetStatHtml TYPE CR
\ ��� �� �� ��� �������:
NetStatHtml<   25 NetStatPort TRUE >NetStatHtml<  110 NetStatPort TRUE >NetStatHtml<  143 NetStatPort TRUE >NetStatHtml< >NetStatHtml TYPE CR

\ ��� ��������� ��������:
S" " S" *Eproxy.exe" GetProcessInfoByName NIP NIP NIP NIP NetStatHtml TYPE CR

\ ��� ������ ���������:
NetStatHtml<
  S" " S" *acSMTP.exe" GetProcessInfoByName NIP NIP NIP NIP >NetStatHtml<
  S" " S" *smtpsend4.exe" GetProcessInfoByName NIP NIP NIP NIP >NetStatHtml<
>NetStatHtml TYPE CR

\ �� ��, ������:
NetStatHtml< S" acSMTP.exe" NetStatAddProc S" smtpsend4.exe" NetStatAddProc >NetStatHtml TYPE CR
