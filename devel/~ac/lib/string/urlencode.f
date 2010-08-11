\ URLENCODE - ����������� ������ � "Percent-encoding"-�������������, �������� � HTTP
\ ��� ����������� URL'��, ���������� QUERY_STRING � ��� POST-�������� application/x-www-form-urlencoded.
\ ������� ����������� URI-DECODE, ������� (� ������ acWEB/src/proto/http/uri-decode.f)
\ ���� �������� UTF-8.

( ��� ����������� POST-�������� ����� �� ������������, �.�. ��� ��� ������
  ���������� ������������ ������, ����� ����� �������� �������.
  ���� ��� �� ������������, �� ���� ��������, ��� BL ���������� �� %20, ��� � URL,
  � �� �� "+", ��� ������ ���� ������� � POST. ����� ���������� ��� �������.
)

REQUIRE >UTF8 ~ac/lib/lin/iconv/iconv.f 

: IsUrlUnreservedChar ( char -- flag ) \ � ������� �������, ��� CharInSet �� Eserv
  DUP 97 123 WITHIN IF DROP TRUE EXIT THEN \ a-z
  DUP 65  91 WITHIN IF DROP TRUE EXIT THEN \ A-Z
  DUP 48  58 WITHIN IF DROP TRUE EXIT THEN \ 0-9
  DUP [CHAR] - = IF DROP TRUE EXIT THEN
  DUP [CHAR] _ = IF DROP TRUE EXIT THEN
  DUP [CHAR] . = IF DROP TRUE EXIT THEN
  DUP [CHAR] ~ = IF DROP TRUE EXIT THEN
  DUP [CHAR] / = IF DROP TRUE EXIT THEN \ js �� ��������
  DROP FALSE
;
: UTF8URLENCODE { a u \ mem o b -- a2 u2 } \ �������� ������ �������������� � UTF-8-���������
  \ ��������� � allocated-������; �������� ������� <# #>

  u 3 * 1 + ALLOCATE THROW -> mem
  BASE @ -> b HEX
  u 0 ?DO a I + C@
          DUP IsUrlUnreservedChar
          IF mem o + C! o 1+ -> o
          ELSE 0 <# # # [CHAR] % HOLD #> mem o + SWAP MOVE o 3 + -> o
          THEN
  LOOP
  b BASE !
  mem o
;
: URLENCODE ( a u -- a2 u2 ) \ �������� ������ �������������� � Windows-1251-���������
  >UTF8
  UTF8URLENCODE
;
: IsUrlUnreservedChar2 ( char -- flag )
  \ � ������� �� IsUrlUnreservedChar �������� � "/"
  DUP 97 123 WITHIN IF DROP TRUE EXIT THEN \ a-z
  DUP 65  91 WITHIN IF DROP TRUE EXIT THEN \ A-Z
  DUP 48  58 WITHIN IF DROP TRUE EXIT THEN \ 0-9
  DUP [CHAR] - = IF DROP TRUE EXIT THEN
  DUP [CHAR] _ = IF DROP TRUE EXIT THEN
  DUP [CHAR] . = IF DROP TRUE EXIT THEN
  DUP [CHAR] ~ = IF DROP TRUE EXIT THEN
\  DUP [CHAR] / = IF DROP TRUE EXIT THEN \ js �� ��������
  DROP FALSE
;
: URLENCODE2 { a u \ mem o b -- a2 u2 } \ �������� ������ �������������� � UTF-8-���������
  \ ��������� � allocated-������; �������� ������� <# #>

  u 3 * 1 + ALLOCATE THROW -> mem
  BASE @ -> b HEX
  u 0 ?DO a I + C@
          DUP IsUrlUnreservedChar2
          IF mem o + C! o 1+ -> o
          ELSE 0 <# # # [CHAR] % HOLD #> mem o + SWAP MOVE o 3 + -> o
          THEN
  LOOP
  b BASE !
  mem o
;
