\ ������� ������ �������� ������ IP-����������
\ ������ ������������� iphlpapi:GetTcpTable (��� � Eserv/3)
\ ����������� netstat � �������� ��� �����.
\ �������������� ���� - ������� ����������� �� ������ �� -
\ �� Win2000, � ������� ��� ���������� ���� (pid), ������
\ ������ "System" ������ �������� ���������.
\ fixme: �� �������� ��� � ����� "-o" � netstat ��� :)

REQUIRE ChildAppErr ~ac/lib/win/process/child_app.f
REQUIRE PipeLine    ~ac/lib/win/process/pipeline.f
REQUIRE STR@        ~ac/lib/str5.f
REQUIRE GetProcessInfo ~ac/lib/win/process/info.f 
REQUIRE /STRING     lib/include/string.F

USER uNS

: TCP
  SkipDelimiters [CHAR] : PARSE 2DUP S" 0.0.0.0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DUP S" 0" COMPARE 0= IF 2DROP S" " THEN 2>R
  SkipDelimiters [CHAR] : PARSE 2DUP S" 0.0.0.0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DUP S" 0" COMPARE 0= IF 2DROP S" " THEN
  2R> 2R> 2R> " <td>{s}</td><td>{s}</td><td>{s}</td><td>{s}</td>" STR@
  NextWord NextWord 0 0 2SWAP >NUMBER 2DROP D>S
  DUP GetProcessInfo 2DROP 2DUP CUT-PATH NIP /STRING DUP 0= IF 2DROP S" System" THEN
  ROT
  " <tr class='sp_data'><td>TCP</td><td>{n}</td><td>{s}</td><td>{s}</td>{s}</tr>{CRLF}"
  uNS @ S+
;
: UDP
  SkipDelimiters [CHAR] : PARSE 2DUP S" 0.0.0.0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DUP S" 0" COMPARE 0= IF 2DROP S" " THEN 2>R
                 NextWord 2DROP
  2R> 2R> " <td>{s}</td><td>{s}</td><td></td><td></td>" STR@
  S" " NextWord 0 0 2SWAP >NUMBER 2DROP D>S
  DUP GetProcessInfo 2DROP 2DUP CUT-PATH NIP /STRING DUP 0= IF 2DROP S" System" THEN
  ROT
  " <tr class='sp_data'><td>UDP</td><td>{n}</td><td>{s}</td><td>{s}</td>{s}</tr>{CRLF}"
  uNS @ S+
;

: GetNetStatResults
  SOURCE S" ::" SEARCH NIP NIP IF EXIT THEN
  SOURCE S" TCP" SEARCH NIP NIP
  SOURCE S" UDP" SEARCH NIP NIP OR 0=
  IF EXIT
  ELSE
     SOURCE EVALUATE
  THEN
;

: ReadNetStatReply
  >R
  BEGIN
    R@ PipeReadLine \ DUP IF ." =>" 2DUP TYPE ." <=" CR ELSE CR THEN
    ['] GetNetStatResults ['] EVALUATE-WITH CATCH
    ?DUP IF ." ns_err=" . 2DROP THEN
  AGAIN
  RDROP
;
: (NetStatHtml)
  CreateStdPipes S" netstat.exe -ona" ChildAppErr THROW

  \  -1 OVER WaitForSingleObject DROP CLOSE-FILE THROW
  CLOSE-FILE DROP 

  ( ����� ������ � stdin �������)

  StdinWH @ CLOSE-FILE THROW

  StdoutRH @ PipeLine >R
  R@ ['] ReadNetStatReply CATCH IF DROP THEN
  R> FREE THROW
  StdoutRH @ CLOSE-FILE THROW
;

: NetStatHtml ( -- addr u )
  " <table class='sortable' id='sp_table' cellpadding='0' cellspacing='0'>
<thead><tr class='sp_head'><th class='proto'>����</th><th class='pid'>pid</th><th class='process'>�������</th>
<th class='state'>���������</th><th class='ip'>IP</th><th class='port'>�</th><th class='rip'>IP</th><th class='rport'>�</th></tr></thead>
<tbody>"
  uNS !
  ['] (NetStatHtml) CATCH DROP
  " </tbody></table>" uNS @ S+
  uNS @ STR@
;

\ NetStatHtml TYPE CR
