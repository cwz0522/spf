\ ��������� ������ �� HTTP/FTP ����� ���������� CURL
\ ~ac: ��������� ����� xt-so.f 18.08.2005
\ $Id$

WARNING @ WARNING 0!
REQUIRE SO            ~ac/lib/ns/so-xt.f
REQUIRE QUICK_WNDPROC ~af/lib/quickwndproc.f 
REQUIRE STR@          ~ac/lib/str5.f
WARNING !

ALSO SO NEW: libcurl.dll

10001 CONSTANT CURLOPT_FILE
10002 CONSTANT CURLOPT_URL
10004 CONSTANT CURLOPT_PROXY
20011 CONSTANT CURLOPT_WRITEFUNCTION
CURLOPT_FILE CONSTANT CURLOPT_WRITEDATA

:NONAME { stream nmemb size ptr \ asize -- stream nmemb size ptr size*nmemb }
  size nmemb * -> asize
  ptr asize stream @ STR+
  stream nmemb size ptr asize
; QUICK_WNDPROC CURL_CALLBACK

: GET-FILE-VIAPROXY { addr u paddr pu \ h data -- str }
\ ���� ������ paddr pu - �������� ������, �� ���� ������������ ���� ������
\ curl ����� ������������ ���������� ��������� http_proxy, ftp_proxy
\ ������� ����� �� �������� ������ ����.

  "" -> data
  0 curl_easy_init -> h
  addr CURLOPT_URL h 3 curl_easy_setopt DROP

  pu IF paddr CURLOPT_PROXY h 3 curl_easy_setopt DROP THEN

  CURL_CALLBACK CURLOPT_WRITEFUNCTION h 3 curl_easy_setopt DROP
  ^ data CURLOPT_WRITEDATA h 3 curl_easy_setopt DROP

  h 1 curl_easy_perform
  ?DUP IF 1 curl_easy_strerror ASCIIZ> TYPE CR THEN
  h 1 curl_easy_cleanup DROP
  data
;
: GET-FILE ( addr u -- str )
  \ ��� ������ ��� � �������� � ���������� ��������� http_proxy
  2DUP FILE ?DUP
  IF 2SWAP 2DROP OVER >R sALLOT R> FREE THROW
  ELSE DROP S" " GET-FILE-VIAPROXY THEN
;

PREVIOUS
\EOF
: TEST
  S" http://xmlsearch.yandex.ru/xmlsearch?query=sp-forth" GET-FILE STYPE
  S" http://xmlsearch.yandex.ru/xmlsearch?query=sp-forth" S" http://otradnoe:3128/" GET-FILE-VIAPROXY STYPE
  S" ftp://ftp.forth.org.ru/" GET-FILE STYPE
;
TEST
