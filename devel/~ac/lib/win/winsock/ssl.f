REQUIRE {             ~ac/lib/locals.f
REQUIRE CreateSocket  ~ac/lib/win/winsock/sockets.f
\ REQUIRE FreeLibrary   ~ac/lib/win/dll/load_lib.f

VARIABLE SSL_LIB
VARIABLE SSLE_LIB

: LoadSslLibrary ( -- )
  S" libssl32.dll" DROP LoadLibraryA ?DUP IF SSL_LIB ! EXIT THEN
  S" conf\plugins\ssl\libssl32.dll" DROP LoadLibraryA ?DUP IF SSL_LIB ! EXIT THEN
  S" ..\CommonPlugins\plugins\ssl\libssl32.dll" DROP LoadLibraryA ?DUP IF SSL_LIB ! EXIT THEN
  -2009 THROW
;
: LoadSsleLibrary ( -- )
  S" libeay32.dll" DROP LoadLibraryA ?DUP IF SSLE_LIB ! EXIT THEN
  S" conf\plugins\ssl\libeay32.dll" DROP LoadLibraryA ?DUP IF SSLE_LIB ! EXIT THEN
  S" ..\CommonPlugins\plugins\ssl\libeay32.dll" DROP LoadLibraryA ?DUP IF SSLE_LIB ! EXIT THEN
  -2009 THROW
;

VARIABLE SSLAPLINK

: SSLAPI:
  >IN @ CREATE >IN ! 
  HERE SSLAPLINK @ , SSLAPLINK ! ( ����� )
  0 , 
  BL WORD ", 0 C,
  DOES> CELL+ DUP @ ?DUP IF NIP API-CALL EXIT THEN
  SSL_LIB @ 0= IF LoadSslLibrary THEN
  DUP CELL+ COUNT DROP SSL_LIB @ GetProcAddress DUP ROT ! API-CALL
;
: SSLEAPI:
  >IN @ CREATE >IN ! 
  HERE SSLAPLINK @ , SSLAPLINK ! ( ����� )
  0 , 
  BL WORD ", 0 C,
  DOES> CELL+ DUP @ ?DUP IF NIP API-CALL EXIT THEN
  SSLE_LIB @ 0= IF LoadSsleLibrary THEN
  DUP CELL+ COUNT DROP SSLE_LIB @ GetProcAddress DUP ROT ! API-CALL
;

SSLAPI: SSL_load_error_strings
SSLAPI: SSL_library_init
SSLAPI: SSL_CTX_new
SSLAPI: TLSv1_method
SSLAPI: SSLv3_method
SSLAPI: SSLv23_method
SSLAPI: SSL_new
SSLAPI: SSL_set_fd
SSLAPI: SSL_connect
SSLAPI: SSL_accept
SSLAPI: SSL_write
SSLAPI: SSL_read
SSLAPI: SSL_get_error
SSLAPI: SSL_CTX_use_certificate_file
SSLAPI: SSL_load_client_CA_file
SSLAPI: SSL_CTX_set_client_CA_list
SSLAPI: SSL_CTX_load_verify_locations
SSLAPI: SSL_CTX_use_RSAPrivateKey_file
SSLAPI: SSL_CTX_set_default_passwd_cb
SSLAPI: SSL_set_accept_state
SSLAPI: SSLv23_server_method
SSLAPI: SSLv23_client_method
SSLAPI: SSLv3_client_method
SSLAPI: SSL_free

SSLAPI: SSL_CTX_set_verify
SSLAPI: SSL_get_verify_result
SSLAPI: SSL_get_peer_certificate
SSLAPI: SSL_CTX_set_verify_depth

SSLEAPI: X509_get_subject_name
SSLEAPI: X509_NAME_oneline
SSLEAPI: X509_verify_cert_error_string

\ SSLAPI: ERR_error_string       libssl32.dll
\ SSLAPI: SSL_CTX_set_client_cert_cb libssl32.dll

1 CONSTANT X509_FILETYPE_PEM
2 CONSTANT X509_FILETYPE_ASN1
3 CONSTANT X509_FILETYPE_DEFAULT

0 CONSTANT SSL_VERIFY_NONE
1 CONSTANT SSL_VERIFY_PEER
2 CONSTANT SSL_VERIFY_FAIL_IF_NO_PEER_CERT
4 CONSTANT SSL_VERIFY_CLIENT_ONCE

USER uSSL_INIT

: SslInit ( -- )
  uSSL_INIT @ 0=
  IF
    SSL_load_error_strings DROP
    SSL_library_init uSSL_INIT !
  THEN
;
: SslNewServerContext { pema pemu type \ c -- context }
  SSLv23_server_method SSL_CTX_new DUP 0= THROW NIP
\ http://www.openssl.org/docs/ssl/SSL_CTX_new.html#
  -> c

\ ����������� � �����, ������������ � ����������
  pemu
  IF
    type pema c SSL_CTX_use_certificate_file NIP NIP NIP 1 <> THROW
    type pema c SSL_CTX_use_RSAPrivateKey_file NIP NIP NIP 1 <> THROW
  THEN
  c
;
: SslNewClientContext { pema pemu type \ c -- context }
  SSLv23_client_method SSL_CTX_new DUP 0= THROW NIP
  -> c

\ ����������� � �����, ������������ � ����������
  pemu
  IF
    type pema c SSL_CTX_use_certificate_file NIP NIP NIP 1 <> THROW
    type pema c SSL_CTX_use_RSAPrivateKey_file NIP NIP NIP 1 <> THROW
  THEN
  c
;
: SslSetVerifyDepth  ( depth context -- )
  SSL_CTX_set_verify_depth DROP 2DROP
;
: SslSetVerify { pema pemu mode context -- }
  pemu
  IF
    0 pema context SSL_CTX_load_verify_locations NIP NIP NIP 1 <> THROW
  THEN
  0 mode context SSL_CTX_set_verify 2DROP 2DROP

\ ��� CA ���������� �������� � ������� �����������, � ������ �����
\ ������������� �������� ������ ����������, ��� ������ ������ �� ������� �����
\  pema SSL_load_client_CA_file NIP
\  ?DUP IF context SSL_CTX_set_client_CA_list NIP NIP . THEN
;
: SslGetVerifyResults { conn \ cert name mem -- cert addr u ior } \ ior=X509_V_OK=0
\ addr ����� ����� ������������� �����������
  conn SSL_get_peer_certificate NIP -> cert
  cert
  IF
    cert X509_get_subject_name NIP -> name
    name
    IF
      500 DUP ALLOCATE THROW DUP -> mem name X509_NAME_oneline 2DROP 2DROP
      cert mem ASCIIZ>
    ELSE cert S" " THEN
  ELSE 0 S" " THEN
  conn SSL_get_verify_result NIP
;
: SslObjConnect ( socket context -- conn_obj ) \ connection
  SSL_new DUP 0= THROW NIP
  DUP >R SSL_set_fd 0= THROW 2DROP R>
  SSL_connect DUP 1 <> IF SWAP SSL_get_error THROW ELSE DROP THEN
;
: SslObjAccept ( socket context -- conn_obj ) \ connection
  SSL_new DUP 0= THROW NIP
  DUP >R SSL_set_fd 0= THROW 2DROP R>
  SSL_accept DUP 1 <> IF SWAP SSL_get_error THROW ELSE DROP THEN
;
: SslWrite ( addr u conn_obj -- n )
  >R SWAP R> SSL_write NIP NIP NIP
;
: SslRead ( addr u conn_obj -- n )
  >R SWAP R> SSL_read NIP NIP NIP
;
