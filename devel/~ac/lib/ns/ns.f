\ DLL/SO - �������

REQUIRE HEAP-COPY heap-copy.f
REQUIRE DLOPEN    dlopen.f
REQUIRE NOTFOUND  notfound.f

: OBJ-DATA@ ( oid -- data )
\ ������ ������� (instance).
\ ��� ����-�������� ���������� ��������� �� ��� ���������� ����� � ������ (�����),
\ ��� dll - ����� �� LoadLibrary
  @
;
: OBJ-DATA! ( data oid -- )
  !
;
: OBJ-NAME@ ( oid -- addr-u )
\ "������" ��� �������, ����������� VOCABULARY (� ������ namespaces ����� ����
\ ��� ������ ������.)
  CELL+ @ ?DUP IF COUNT ELSE S" FORTH" THEN
;

: INVOKE ( ... oid addr u -- ... )
\ ��������� ����� � ������ addr u ��� ������� oid
  ROT ( addr u oid )
  DUP CLASS@ DUP 0= IF DROP FORTH-WORDLIST THEN ( addr u oid class-oid )
  SWAP >R ( addr u class-oid )
  SEARCH-WORDLIST1
  IF R> SWAP EXECUTE ELSE -2004 THROW THEN
;

: SEARCH-WORDLIST-V ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH
\ ����� �����������, �������� ������� c-addr u � ������ ����, ���������������� 
\ wid. ���� ����������� �� �������, ������� ����.
\ ���� ����������� �������, ������� ���������� ����� xt � ������� (1), ���� 
\ ����������� ������������ ����������, ����� ����� ������� (-1).
  DUP CLASS@
  IF S" SEARCH-WORDLIST" INVOKE
  ELSE SEARCH-WORDLIST1 THEN
;
' SEARCH-WORDLIST-V TO SEARCH-WORDLIST

USER _PAS-EXEC \ ��� ��������� ���������� �������� ;)
: PAS-EXEC ( ... n dll-xt -- x )
\ n - ����� ���������� �� ����� ��� dll-�������
\ ��������� ������� ����������.
  _PAS-EXEC !
  ?DUP IF N>R RDROP THEN
  0 _PAS-EXEC @ EXECUTE
;
USER _C-EXEC
: C-EXEC ( ... n dll-xt -- x )
\ n - ����� ���������� �� ����� ��� dll/so-�������
\ ��������� ������� ����������.
  _PAS-EXEC ! DUP _C-EXEC !
  ?DUP IF N>R RDROP THEN
  _C-EXEC @ 0 _PAS-EXEC @ EXECUTE
  SWAP BEGIN DUP WHILE RDROP 1- REPEAT DROP
;
\ ���� �� ����� ������ ����� ������� � ���������,
\ �� ����� ���������� ����� ��������� ���������.

: SPAS-EXEC ( dll-xt ... -- x )
  DEPTH 1- N>R RDROP 0 SWAP EXECUTE
;
: SC-EXEC ( dll-xt ... -- x )
  DEPTH 1- _C-EXEC !
  DEPTH 1- N>R RDROP _C-EXEC @ 0 ROT EXECUTE
  SWAP BEGIN DUP WHILE RDROP 1- REPEAT DROP
;

: NEW:
\ ������� ����� ���������� �������, class �������� ����� ����� 
\ �������� ������������ �������. �.�. ������� ������ - ���������
\ �������� ������.
  >IN @ VOCABULARY >IN !
  CONTEXT @ ( ALSO) ' EXECUTE CONTEXT @ CLASS!
;
\ NEW: KERNEL32.DLL ������������� ������ ����:
\ VOCABULARY KERNEL32.DLL
\ ( ALSO) KERNEL32.DLL
\ CONTEXT @ CLASS!


VOCABULARY DL
GET-CURRENT ALSO DL DEFINITIONS

: HEAP-COPY-U
  DUP >R HEAP-COPY R>
;
: SEARCH-WORDLIST ( c-addr u oid -- 0 | xt 1 | xt -1 )
  DUP OBJ-DATA@ ?DUP
  IF NIP ROT ROT HEAP-COPY-U OVER >R ROT DLSYM R> FREE THROW
     DUP IF 1 THEN
  ELSE
     DUP OBJ-NAME@ HEAP-COPY-U OVER >R DLOPEN R> FREE THROW
     ?DUP IF ( addr u oid h ) OVER OBJ-DATA! RECURSE
          ELSE DROP 2DROP 0 THEN \ �� ������� ��������� DLL/SO
  THEN
;
SET-CURRENT PREVIOUS

: NOTFOUND \ ������ ��� ���������� asciiz ��������� "zzz" = S" zzz" DROP
  OVER C@ [CHAR] " = 
  IF NIP >IN @ SWAP - 0 MAX >IN !
     POSTPONE S" DROP
  ELSE NOTFOUND THEN
;

ALSO \ ����� ���� ������� :-]
\ ===========================
DL NEW: KERNEL32.DLL

0 ' GetTickCount PAS-EXEC . CR
0 ' GetCurrentProcessId PAS-EXEC . CR
1000 PAD S" OS" DROP 3 ' GetEnvironmentVariableA PAS-EXEC PAD SWAP TYPE CR
' GetEnvironmentVariableA 1000 PAD "OS" SPAS-EXEC PAD SWAP TYPE CR

\ ===========================
DL NEW: USER32.DLL

0 ' GetDesktopWindow PAS-EXEC . CR

\ ===========================
DL NEW: libcrypt.dll

"zz" "pass" 2 ' crypt C-EXEC ASCIIZ> TYPE CR
' crypt "zz" "pass" SC-EXEC ASCIIZ> TYPE CR

\ ===========================
KERNEL32.DLL ' GetEnvironmentVariableA 
1000 PAD "USERNAME" SPAS-EXEC PAD SWAP TYPE CR

' GetCurrentThreadId SPAS-EXEC . CR
ORDER

\ ===========================
DL NEW: libcurl.dll
VARIABLE CURLH
CREATE URL S" http://xmlsearch.yandex.ru/xmlsearch?query=sp-forth" HERE SWAP DUP ALLOT MOVE 0 C,
\ curl �� �������� ������ ����

0 ' curl_easy_init C-EXEC DUP . CURLH !
URL 10002 ( CURLOPT_URL) CURLH @ 3 ' curl_easy_setopt C-EXEC .
CURLH @ 1 ' curl_easy_perform C-EXEC .
