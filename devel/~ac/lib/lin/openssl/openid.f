\ ��������� OpenID 1.1

REQUIRE X509Pk2PEM ~ac/lib/lin/openssl/x509req.f
REQUIRE base64     ~ac/lib/string/conv.f
REQUIRE POST-FILE  ~ac/lib/lin/curl/curlpost.f 
REQUIRE bUrlencode ~ac/lib/string/burlencode.f 

ALSO libeay32.dll
ALSO libssl.so.0.9.8

: default_p S" defp" FILE ;
: default_g S" 2" ;

0
4 -- DH.pad
4 -- DH.version
4 -- DH.p
4 -- DH.g
4 -- DH.length \ optional
4 -- DH.pub_key \ g^x
4 -- DH.priv_key \ x
DROP

USER assoc_handle
USER assoc_type
USER dh_server_public
USER enc_mac_key
USER expires_in
USER session_type

: (assoc_reply)
  [CHAR] : PARSE SFIND IF EXECUTE ELSE TYPE ." unknown reply" EXIT THEN
  10 PARSE ROT S!
;
: assoc_reply
  BEGIN
    10 PARSE 2DUP ." [" TYPE ." ]" CR
    DUP
  WHILE
    ['] (assoc_reply) EVALUATE-WITH
  REPEAT 2DROP
;
: DhFree ( dh -- )
  1 DH_free DROP
;
: DhGenKeys { \ dh p g pk pklen -- pk pklen dh }
\ ������ ��� ������������ ������ Diffie-Hellman
\ ���������� ���� ������, ���������� �������� ����, ���������������� � big endian,
\ � ��������� dh � �������� ������, ������������ ������� �� �����, �.�. ������ �� ����������
  0 DH_new -> dh
\  dh DH.pub_key @ .
  default_p DROP ^ p 2 BN_dec2bn DROP
  default_g DROP ^ g 2 BN_dec2bn DROP

  p dh DH.p !
  g dh DH.g !
  dh 1 DH_generate_key 1 <> THROW
\  dh DH.pub_key @ @ 10 DUMP CR
\  dh DH.priv_key @ @ 10 DUMP CR
  dh DH.pub_key @ 1 BN_num_bits 7 + 8 / ALLOCATE THROW -> pk
  pk dh DH.pub_key @ 2 BN_bn2bin -> pklen
  pk pklen dh
;
: DhGetSharedKey { pk2 pklen2 dh \ spub ck cklen -- ck cklen }
  0 pklen2 pk2 3 BN_bin2bn -> spub
  dh 1 DH_size ALLOCATE THROW -> ck
  dh spub ck 3 DH_compute_key -> cklen  cklen 1 < THROW
  ck cklen
;
: DhTest { \ pk1 pklen1 dh1 pk2 pklen2 dh2 } \ ������������; ������ ���������� ��� ���������� �����

  \ ������
  DhGenKeys -> dh1 -> pklen1 -> pk1

  \ ������
  DhGenKeys -> dh2 -> pklen2 -> pk2
  pk1 pklen1 dh2 DhGetSharedKey DUMP CR
  dh2 DhFree

  \ ������
  pk2 pklen2 dh1 DhGetSharedKey DUMP CR
  dh1 DhFree
;
: OpenIdGetSharedKey { urla urlu \ dh spub ck cklen key_sha1 mac_key -- ka ku }
\ �� ��������� ������� (consumer'�)
  enc_mac_key 0!
  DhGenKeys -> dh
  ( pk pklen) base64 2DUP ." consumer:" TYPE CR
  bUrlencode
  " openid.mode=associate&openid.assoc_type=HMAC-SHA1&openid.session_type=DH-SHA1&openid.dh_consumer_public={s}" STR@
  S" " urla urlu POST-FILE STR@ \ 2DUP TYPE ." <==" CR
  ['] assoc_reply EVALUATE-WITH
  enc_mac_key @ 0= IF S" " EXIT THEN
  dh_server_public @ STR@ debase64
  dh DhGetSharedKey -> cklen -> ck
  ." Shared ckey:" ck cklen base64 TYPE CR
\ ��� HMAC-�������� � OpenID ������������ �� ���� ������� 1024-������ ����� ����,
\ � �������� ����, ����������� ��������, � ������������ �� ���� � XOR'����� SHA-����� ������ ����� ����
  20 ALLOCATE THROW -> key_sha1
  key_sha1 cklen ck 3 SHA1 DROP \ ��� �� key_sha1
  enc_mac_key @ STR@ debase64 20 <> THROW -> mac_key
  \ mac_key 20 DUMP CR
  20 0 DO mac_key I + C@ key_sha1 I + C@ XOR mac_key I + C! LOOP
  mac_key 20 \ DUMP CR
;
VECT vIsSet ' DROP TO vIsSet

: LF_
  CRLF DROP 1+ 1
;
: OpenIdServerAssociate { \ dh pk pklen ck cklen key_sha1 mac_key enc_mac_key1 s -- addr u }
\ �� ������� openid-�������
  S" openid.dh_consumer_public" vIsSet 0= IF EXIT THEN
  S" openid.session_type" vIsSet 0= IF EXIT THEN
  S" openid.assoc_type" vIsSet 0= IF EXIT THEN
  S" openid.session_type" EVALUATE S" DH-SHA1" COMPARE IF EXIT THEN
  S" openid.assoc_type" EVALUATE S" HMAC-SHA1" COMPARE IF EXIT THEN

  DhGenKeys -> dh -> pklen -> pk
  pk pklen base64 dh_server_public S!

  S" openid.dh_consumer_public" EVALUATE ." consumer:" 2DUP TYPE CR debase64
  dh DhGetSharedKey -> cklen -> ck

." Shared ckey:" ck cklen base64 TYPE CR
  20 ALLOCATE THROW -> key_sha1
  key_sha1 cklen ck 3 SHA1 DROP \ ����� ��� �� key_sha1

  20 ALLOCATE THROW -> mac_key
  mac_key 20 0xA5 FILL
  20 ALLOCATE THROW -> enc_mac_key1
  20 0 DO mac_key I + C@ key_sha1 I + C@ XOR enc_mac_key1 I + C! LOOP
  enc_mac_key1 20 base64 enc_mac_key S!

  "" -> s
  " assoc_handle:1239294864:wkmbT0L2ZFmNKqH9ZFuE:23c31a709a" s S+ LF_ s STR+
  " assoc_type:HMAC-SHA1" s S+ LF_ s STR+
  dh_server_public @ STR@ " dh_server_public:{s}" s S+ LF_ s STR+
  enc_mac_key @ STR@ " enc_mac_key:{s}" s S+ LF_ s STR+
  " expires_in:1207536"  s S+ LF_ s STR+
  " session_type:DH-SHA1"  s S+ LF_ s STR+
  s STR@
;
PREVIOUS
PREVIOUS

\EOF
\ S" http://www.livejournal.com/openid/server.bml" OpenIdGetSharedKey DUMP CR
\ S" http://authn.freexri.com/authentication/" OpenIdGetSharedKey DUMP CR
\ S" http://www.blogger.com/openid-server.g" OpenIdGetSharedKey DUMP CR
\ S" https://open.login.yahooapis.com/openid/op/1.1/auth" OpenIdGetSharedKey DUMP CR
\ S" http://api.screenname.aol.com/auth/openidServer" OpenIdGetSharedKey DUMP CR
\ S" http://rainbow.koenig.ru/openid.e" OpenIdGetSharedKey DUMP CR
\ S" http://www.postbin.org/1b5k0vn" OpenIdGetSharedKey DUMP CR \ �������� :)
\EOF
