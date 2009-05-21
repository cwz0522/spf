\ ��� ���� ���������� ��� i18n, �� IBM, ��. http://site.icu-project.org/
\ ��������� icu*.dll ��� .so, ��. http://icu-project.org/download/4.2.html#ICU4C
\ ����� ����� �������� ������������ (�����������, �����, ���������, regexp,
\ ��������� � �������������� ���, idn, � �.�.), �� ������������ ������ dll...
\ ��� ������� ����������� - ��� ������� icuuc42.dll � icudt42.dll (17�� � �����!)

REQUIRE SO            ~ac/lib/ns/so-xt.f
REQUIRE STR@          ~ac/lib/str5.f

ALSO SO NEW: icuuc42.dll
ALSO SO NEW: libicuuc.so.42

\ API ����������� http://icu-project.org/apiref/icu4c/ucnv_8h.html

: ICCONV { a u cpfa cpfu cpta cptu \ ior oa ou -- oa ou }
  u 4 * CELL+ DUP -> ou ALLOCATE THROW -> oa

  ^ ior u a ou oa cpfa cpta 7 ucnv_convert
  oa SWAP
;
PREVIOUS
PREVIOUS

\EOF
\ ����
S" ����test" S" cp1251" S" UTF-8" ICCONV
S" UTF-8" S" cp1251" ICCONV ANSI>OEM TYPE CR

\ �������� ������������� � ICONV
REQUIRE ICONV ~ac/lib/lin/iconv/iconv.f 
S" ����test" S" cp1251" S" UTF-8" ICCONV
S" UTF-8" S" cp1251" ICONV ANSI>OEM TYPE CR
