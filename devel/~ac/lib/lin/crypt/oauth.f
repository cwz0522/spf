\ ��������� ��������� OAuth ��� ������� � API ���-��������. http://oauth.net/
\ OAuth 1.0 April 2010: RFC 5849

\ OAuth 2.0 July 2010: http://tools.ietf.org/html/draft-ietf-oauth-v2-10
( OAuth 2.0 �� ������� �������� ���������� ������������ ������, �.�. ��������
  client_secret ������ httpS-����������, �������������� ��� ���� ������ � OA2
  ���������� ������� ������� curl'� � �������� )

REQUIRE STR@        ~ac/lib/str5.f
REQUIRE base64      ~ac/lib/string/conv.f
REQUIRE URLENCODE2  ~ac/lib/string/urlencode.f 
REQUIRE SBetween    ~ac/lib/string/between.f 
REQUIRE HMAC-SHA1   ~ac/lib/lin/crypt/gcrypt.f 
REQUIRE UnixTime    ~ac/lib/win/date/unixtime.f 
REQUIRE POST-FILE   ~ac/lib/lin/curl/curlpost.f 

\ ����� ������ ������� ������� ���� ��������� GCryptInit.
\ �������� ��������������� DLL (gcrypt, curl � openssl ��� curl) ����� 3��!

: OAuth1RequestToken { cka cku csa csu urla urlu \ ut par -- ta tu tsa tsu }
  \ �� ����� ������ consumer_key � consumer_secret
  \ (���������� ������ ��� ����������� ���������� � ���������� API �������)
  \ � URL ������� ...oauth/request_token;
  \ �� ������ oauth_token � oauth_token_secret, �������� �� ���������
  \ ���� ������������� ���������� ������������ �� ������ � ��� ������;
  \ ��� ������� ������� (� CURL) �������� ������ ����� ���� �������

  UnixTime -> ut \ �������� twitter ������� ����� !
  ut
  csa csu + 1- C@ ut 2 / csa C@ " o4{n}{n}{n}" STR@ \ nonce
  cka cku 
  " oauth_consumer_key={s}&oauth_nonce={s}&oauth_signature_method=HMAC-SHA1&oauth_timestamp={n}&oauth_version=1.0"
  DUP -> par
  STR@ URLENCODE2
  urla urlu URLENCODE2
  " GET&{s}&{s}" STR@
  csa csu " {s}&" STR@ \ consumer_secret&token_secret
  HMAC-SHA1 base64 URLENCODE2
  " oauth_signature={s}" STR@
  par STR@ urla urlu " {s}?{s}&{s}" STR@
  GET-FILE STR@
  2DUP S" oauth_token=" S" &" SBetween
  2SWAP S" oauth_token_secret=" S" &" SBetween
;
: OAuth2AppToken { cia ciu csa csu urla urlu \ ut par -- ta tu }
  \ �� ����� client_id (app_id) � client_secret (app_secret)
  \ �� ������ ����� � ������������ ��� ������� � ������ ����������
  \ ��� ���� ������� � ���������������� ������
  \ type=client_cred ����� ������ ����������� redirect_uri
  csa csu
  cia ciu
  urla urlu
  " {s}?type=client_cred&client_id={s}&client_secret={s}" STR@ GET-FILE STR@
  S" access_token=" S" &" SBetween
;
