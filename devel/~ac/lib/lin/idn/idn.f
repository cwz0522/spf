\ ������� ��� LibIDN.
\ ����������� ������� �������� ����, ��������� ��������� ����� �� ��������������.
\ $Id$
\ ��������� libidn-11.dll - http://www.gnu.org/software/libidn/

\ �����, ������������ >PUNYCODE, PUNYCODE>, >IDN � IDN> ���� ����������� �� FREE, ��� ��� ���� ICONV-�������.

REQUIRE SO            ~ac/lib/ns/so-xt.f
REQUIRE >UNICODE      ~ac/lib/lin/iconv/iconv.f 

ALSO SO NEW: libidn-11.dll
ALSO SO NEW: libc.so.6 \ �� �� ����

\ 0 stringprep_locale_charset ASCIIZ> TYPE \ ���������� "ASCII", �.�. �� �������� Windows
\ S" test" DROP 1 stringprep_locale_to_utf8 ASCIIZ> TYPE
\ ���������� libidn: warning: libiconv not installed, cannot convert data to UTF-8,
\ ������ ��� ������ ��� ���������� (��. � ���������� "#if HAVE_ICONV"), �.�. �� ��������
\ �����: ��� ����������� ����� ����� ��������� ����������� ��� Windows libidn-11 ����������,
\ �� ��� ��� � �� ����, �.�. wrapper ��� iconv ����� ���� :)

: IDNA_ACE_PREFIX S" xn--" ;

: IDNA_FREE ( addr -- )
  1 idn_free DROP
;
: >PUNYCODE { a u \ m l -- a2 u2 } \ ansi to punycode
  a u >UCS4 -> u -> a
  u -> l
  l ALLOCATE THROW -> m
  m ^ l 0 a u 4 / 5 punycode_encode THROW
  a FREE THROW
  m l
;
: PUNYCODE> { a u \ m l -- a2 u2 } \ punycode to ansi
  u -> l
  l 4 * ALLOCATE THROW -> m
  0 m ^ l a u 5 punycode_decode THROW
  m l 4 * UCS4>
  m FREE THROW
;
: >IDN { a u \ m -- a2 u2 } \ ansi to idna
  0 ^ m a u >UCS4 DROP DUP -> a 3 idna_to_ascii_4z THROW
  a FREE THROW
  m ASCIIZ>
  2DUP HEAP-COPY SWAP
  ROT IDNA_FREE
;
: IDN> { a u \ m -- a2 u2 } \ idna to ansi
  0 ^ m a u >UCS4 DROP 3 idna_to_unicode_4z4z THROW
  m 4ASCIIZ> UCS4>
  m IDNA_FREE
;

PREVIOUS PREVIOUS

\EOF
S" �����" >PUNYCODE TYPE CR
S" 80a1acny" PUNYCODE> ANSI>OEM TYPE CR

S" �����.eserv.ru" >IDN TYPE CR
S" xn--80a1acny.eserv.ru" IDN> ANSI>OEM TYPE CR
