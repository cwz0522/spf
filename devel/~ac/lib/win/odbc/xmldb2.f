( ~ac 14.07.2003 )
( ������� SqlQueryXml [ S" query" -- "xml-result" ] �����������
  ��� ������������ XML-������� �� ������ ������� �� ��� ������.
  ����� ����� XML+XSLT �������������� � HTML.
  ������� �������� � ������� ������ ForthScripter [text/xml � ����������
  �������� �������������]

  S" select * from table" SqlQueryXml ���� �� ������ XML-��������������� ������
  <Row N="1"><Email>ac@eserv.ru</Email><Msgs>191650</Msgs><Size>10</Size></Row>
  ������ ��. � ����� �����
)

REQUIRE ConnectFile ~ac/lib/win/odbc/odbc2.f
REQUIRE STR@         ~ac/lib/str2.f

VARIABLE SqlQ

: SqlInit ( S" sqldriver" -- )
  StartSQL 0= IF S" sql_init_error.html" ( FILE) TYPE BYE THEN
  SqlQ !
  SqlQ @ ConnectFile SQL_OK?
  0= IF S" sql_connect_error.html" ( FILE) TYPE BYE THEN
;

: SqlStruc { \ s }
  "" -> s
    S" <Row N='1' struct='1'>" s STR+
    SqlQ @
    SqlQ @ ResultCols 0 ?DO
      I 1+ OVER ColName 2DUP
      " <{s}></{s}>" s S+
    LOOP DROP
    " </Row>{CRLF}" s S+
  s
;
USER &escape_tmp
: &escape1
  BEGIN
    [CHAR] & PARSE DUP
  WHILE
    &escape_tmp @ STR+
    CharAddr #TIB @ >IN @ - DUP -1 >
    IF 4 MIN S" amp;" COMPARE 0=
       IF S" &" ELSE S" &amp;" THEN &escape_tmp @ STR+
    ELSE 2DROP THEN
  REPEAT 2DROP
;
: &escape
  2DUP S" &" SEARCH NIP NIP 0= IF EXIT THEN
  "" &escape_tmp !
  ['] &escape1 EVALUATE-WITH
  &escape_tmp @ STR@
;
: SqlQueryResult
  { \ n s }
  "" -> s
  BEGIN
    SqlQ @ NextRow
  WHILE
    n 1+ DUP -> n " <Row N={''}{n}{''}>" s S+
\   SqlQ @ Row ANSI>OEM TYPE CR
    SqlQ @
    SqlQ @ ResultCols 0 ?DO
      I 1+ OVER 2DUP
      ColName 2SWAP Col DUP 1 < 
      IF 2DROP S" 0" 
      ELSE &escape THEN 
      2OVER
      " <{s}>{s}</{s}>" s S+
    LOOP DROP
    " </Row>{CRLF}" s S+
  REPEAT
  n 0= IF SqlStruc s S+ THEN
  s STR@
  SqlQ @ UnbindCols
  0 SqlQ @ odbcStat @ SQLFreeStmt DROP
;
: SqlQueryResult@
  { \ n s }
  "" -> s
  BEGIN
    SqlQ @ NextRow
  WHILE
    n 1+ DUP -> n " <Row N={''}{n}{''}>" s S+
\   SqlQ @ Row ANSI>OEM TYPE CR
    SqlQ @
    SqlQ @ ResultCols 0 ?DO
      I 1+ OVER 2DUP
      ColName 2SWAP Col DUP 1 < 
      IF 2DROP S" 0"
      ELSE &escape THEN 
      S@ 2OVER
      " <{s}>{s}</{s}>" s S+
    LOOP DROP
    " </Row>{CRLF}" s S+
  REPEAT s STR@
  SqlQ @ UnbindCols
  0 SqlQ @ odbcStat @ SQLFreeStmt DROP
;
: SqlQueryXml ( S" sql_query" -- S" xml-result" )
  SqlQ @ ExecSQL SqlQ @ SQL_Error
  SqlQueryResult
;
: SqlQueryXml@ ( S" sql_query" -- S" xml-result" )
  SqlQ @ ExecSQL SqlQ @ SQL_Error
  SqlQueryResult@
;
: SqlQueryXmlFile ( S" file" -- S" xml-result" )
  EVAL-FILE SqlQueryXml
;
: SqlQueryXmlFile@ ( S" file" -- S" xml-result" )
  EVAL-FILE SqlQueryXml@
;
: SqlExit
  SqlQ @ StopSQL
  SqlQ @ FREE DROP
; 

\  S" Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=G:\Eserv3\CONF\lists" SqlInit
\ S" select * from [AS.txt]" SqlQueryXml TYPE
\ CR CR
\ S" select EMAIL_TO as Email, COUNT(EMAIL_TO) as Msgs, SUM(SIZE) as Total from [200307mail-spam.txt] group by EMAIL_TO order by COUNT(EMAIL_TO)" SqlQueryXml TYPE
\ SqlExit
