\ ������� ��� �� ��������� �������� (������� ����) � unixtime.
\ ���� ��� ����� ���.

\ %Y-%m-%d %H:%M:%S
\ %d.%m.%Y %H:%M
\ %a, %d %b %Y %H:%M:%S GMT

\ FIXME: S" 19.01.2038" >UnixTime -> 2147461200
\        S" 20.01.2038" >UnixTime -> -1 (��. mktime)
\ http://ru.wikipedia.org/wiki/��������_2038_����
\ ���� ���������� ������� � ���� ������� ������� ������ 67 ���, 
\ �� � �� ���� ���������� :-)

: _IsDigit ( char -- flag )
  DUP [CHAR] 9 > IF DROP FALSE EXIT THEN
  [CHAR] 0 < 0=
;
: DateS>M ( addr u -- m )
  \ ���������� ����� ������ (1-12) �� �����
  \ ��� 0, ���� ������ ������������
  1 ROT ROT
  S" Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
  OVER + SWAP DO
    2DUP I 3 COMPARE 0= IF 2DROP UNLOOP EXIT THEN
    ROT 1+ ROT ROT
  4 +LOOP 2DROP DROP 0
;
: _>NUM 0 0 2SWAP >NUMBER 2DROP D>S ;

0
CELL -- tm_sec     \ * seconds after the minute - [0,59] */
CELL -- tm_min     \ * minutes after the hour - [0,59] */
CELL -- tm_hour    \ * hours since midnight - [0,23] */
CELL -- tm_mday    \ * day of the month - [1,31] */
CELL -- tm_mon     \ * months since January - [0,11] */
CELL -- tm_year    \ * years since 1900 */
CELL -- tm_wday    \ * days since Sunday - [0,6] */
CELL -- tm_yday    \ * days since January 1 - [0,365] */
CELL -- tm_isdst   \ * daylight savings time flag */
CONSTANT /tm

WINAPI: mktime    MSVCRT.DLL

: >tm_year ( n1 -- n2 )
  DUP 100 < IF EXIT THEN
  1900 -
;
: (Rus>UnixTime) ( -- n )
  \ %d.%m.%Y %H:%M
  /tm ALLOCATE THROW >R
  [CHAR] . PARSE _>NUM R@ tm_mday !
  [CHAR] . PARSE _>NUM 1- R@ tm_mon !
  BL PARSE _>NUM >tm_year R@ tm_year !
  [CHAR] : PARSE _>NUM R@ tm_hour !
  [CHAR] : PARSE _>NUM R@ tm_min !
  BL PARSE _>NUM R@ tm_sec !
  1 R@ tm_isdst !
  R@ mktime NIP R> FREE THROW
;
: (Sql>UnixTime) ( -- n )
  \ %Y-%m-%d %H:%M:%S
  /tm ALLOCATE THROW >R
  [CHAR] - PARSE _>NUM >tm_year R@ tm_year !
  [CHAR] - PARSE _>NUM 1- R@ tm_mon !
  BL PARSE _>NUM R@ tm_mday !
  [CHAR] : PARSE _>NUM R@ tm_hour !
  [CHAR] : PARSE _>NUM R@ tm_min !
  BL PARSE _>NUM R@ tm_sec !
  1 R@ tm_isdst !
  R@ mktime NIP R> FREE THROW
;

: (Date>UnixTime) ( -- n )
  \ Wed, 18 Aug 2010 03:15:25 +0400
  /tm ALLOCATE THROW >R
  BL PARSE 2DROP
  BL PARSE _>NUM R@ tm_mday !
  BL PARSE DateS>M 1- R@ tm_mon !
  BL PARSE _>NUM >tm_year R@ tm_year !
  [CHAR] : PARSE _>NUM R@ tm_hour !
  [CHAR] : PARSE _>NUM R@ tm_min !
  BL PARSE _>NUM R@ tm_sec !
  1 R@ tm_isdst !
  R@ mktime NIP R> FREE THROW
;

: >UnixTime ( a u -- n )
  OVER C@ _IsDigit
  IF 2DUP S" ." SEARCH NIP NIP
     IF ['] (Rus>UnixTime) ELSE ['] (Sql>UnixTime) THEN
  ELSE ['] (Date>UnixTime) THEN
  EVALUATE-WITH
;

\EOF

REQUIRE UnixTimeSql ~ac/lib/win/date/unixtime.f 
S" Wed, 18 Aug 2010 03:15:25 +0400" >UnixTime UnixTimeSql TYPE CR
S" 23.06.71 02:03" >UnixTime UnixTimeSql TYPE CR
S" 1988-06-01 12:01:02" >UnixTime UnixTimeSql TYPE CR