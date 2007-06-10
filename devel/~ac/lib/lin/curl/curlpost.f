\ POST-������� � ������� CURL.
\ $Id$

REQUIRE GET-FILE      ~ac/lib/lin/curl/curl.f

10015 CONSTANT CURLOPT_POSTFIELDS
10023 CONSTANT CURLOPT_HTTPHEADER
10060 CONSTANT CURLOPT_POSTFIELDSIZE
10084 CONSTANT CURLOPT_HTTP_VERSION

ALSO libcurl.dll

: POST-FILE-VIAPROXY { adata udata act uct addr u paddr pu \ h data slist -- str }
\ ���� ������ paddr pu - �������� ������, �� ���� ������������ ���� ������
\ curl ����� ������������ ���������� ��������� http_proxy, ftp_proxy
\ ������� ����� �� �������� ������ ����.
\ adata udata - ������������ ����� POST ������.
\ act uct - content-type; ���� uct=0, �� �������� default application/x-www-form-urlencoded

  "" -> data
  0 curl_easy_init -> h
  addr CURLOPT_URL h 3 curl_easy_setopt DROP

\  S" name:passw" DROP CURLOPT_USERPWD  h 3 curl_easy_setopt DROP

  pu IF paddr CURLOPT_PROXY h 3 curl_easy_setopt DROP THEN

  CURL_CALLBACK CURLOPT_WRITEFUNCTION h 3 curl_easy_setopt DROP
  ^ data CURLOPT_WRITEDATA h 3 curl_easy_setopt DROP

  udata CURLOPT_POSTFIELDSIZE h 3 curl_easy_setopt DROP
  adata CURLOPT_POSTFIELDS    h 3 curl_easy_setopt DROP

  1 CURLOPT_HTTP_VERSION h 3 curl_easy_setopt DROP

  S" User-Agent: SP-Forth" DROP 0 2 curl_slist_append -> slist
  uct IF act slist 2 curl_slist_append -> slist  THEN
  slist CURLOPT_HTTPHEADER h 3 curl_easy_setopt DROP

  h 1 curl_easy_perform
  ?DUP IF 1 curl_easy_strerror ASCIIZ> TYPE CR THEN
  slist 1 curl_slist_free_all DROP
  h 1 curl_easy_cleanup DROP
  data
;
PREVIOUS

: POST-FILE ( adata udata act uct addr u -- str )
  \ ��� ������ ��� � �������� � ���������� ��������� http_proxy
  2DUP FILE ?DUP
  IF 2SWAP 2DROP 2SWAP 2DROP 2SWAP 2DROP OVER >R sALLOT R> FREE THROW
  ELSE DROP S" " POST-FILE-VIAPROXY THEN
;

\EOF
S" <test>test</test>" S" Content-Type: text/xml" S" http://www.forth.org.ru/test.e" S" http://localhost:3128/" POST-FILE-VIAPROXY STR@ TYPE
