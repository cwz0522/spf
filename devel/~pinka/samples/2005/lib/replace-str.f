\ Dec.2004
\ $Id$

REQUIRE STR@ ~ac/lib/str5.f

REQUIRE SPLIT- ~pinka/samples/2005/lib/split.f

: replace-str- ( s s-old s-new -- )
  \ ��������  s-old �� s-new � ������ s
  \ s-old � s-new �������������
  "" { s so sn ss }
  s STR@
  BEGIN ( dright' )
    so STR@ SPLIT-
  WHILE ( dright dleft )
    ss STR+
    sn STR@ ss STR+
  REPEAT ss STR+

  ss STR@  s STR!
  ss STRFREE
  so STRFREE
  sn STRFREE
;
: replace-str ( s-new s-old s -- )
  -ROT SWAP replace-str-
;
