\ �������� ��� ����

REQUIRE STR@ ~ac/lib/str5.f
REQUIRE FileLines=> ~ygrek/lib/filelines.f
S" ~ygrek/lib/list/all.f" INCLUDED
REQUIRE GENRAND ~ygrek/lib/neilbawd/mersenne.f
REQUIRE UPPERCASE ~ac/lib/string/uppercase.f
REQUIRE re_match? ~ygrek/lib/re/re.f
REQUIRE ULIKE ~pinka/lib/like.f
REQUIRE 2VALUE ~ygrek/lib/2value.f
REQUIRE LAMBDA{ ~pinka/lib/lambda.f
REQUIRE ATTACH ~pinka/samples/2005/lib/append-file.f
REQUIRE ms@ lib/include/facil.f

MODULE: quotes

ms@ SGENRAND
..: AT-PROCESS-STARTING ms@ SGENRAND ;..

list::nil VALUE quotes

: quotes-file S" quotes.txt" ;

\ : dump-quotes ( -- )
   \ �������� ����
\   quotes-file EMPTY
   \ �������� ���� ������
\   LAMBDA{ STR@ quotes-file ATTACH-LINE-CATCH DROP } quotes mapcar ;

EXPORT

: quotes-total quotes list::length ;

\ ~ygrek/lib/debug/inter.f

: load-quotes
  \ quotes FREE-LIST
  S" REMINDER: BUG! MEMORY LEAK. Cant do FREE-LIST cause it is in another thread. Fix it (easy)" log::debug
  list::nil TO quotes
  %[
  START{
   quotes-file FileLines=>
   DUP STR@
   \ 2DUP TYPE CR
   RE" (\S+)\s+(\S.*)" re_match?
   IF
    2 get-group DROP C@ 0x20 = IF ." !" THEN
    1 get-group 2 get-group " {s} [{s}]" %
   THEN
  }EMERGE
  ]%
  TO quotes
  quotes-total quotes-file " Quotes reloaded from '{s}'. Total {n}" log::info ;

: type-quotes ( -- ) quotes list::each-> STR@ CR TYPE ;

DEFINITIONS

: list-random-quote ( list -- node ) DUP list::length GENRANDMAX SWAP list::nth ;
: node>s DUP list::empty? IF DROP " no quotes" ELSE list::car THEN ;

0 VALUE re

EXPORT

: random-quote ( -- s ) quotes list-random-quote node>s ;
: quote[] ( n -- s ) quotes list::nth node>s ;

: search-quote ( a u -- s )
   \ " .*{s}.*" DUP STR@ BUILD-REGEX TO re STRFREE
   " *{s}*" TO re
   %[ quotes LAMBDA{ DUP STR@ re STR@ ULIKE IF % ELSE DROP THEN } list::iter ]%
   DUP list-random-quote node>s SWAP ['] STRFREE list::free-with
   re STRFREE ;

: register-quote ( quote-au author-au -- )
   " {s} {s}" DUP STR@ quotes-file ATTACH-LINE-CATCH DROP STRFREE 
   load-quotes ;

;MODULE

/TEST

load-quotes
CR S" ����" search-quote STR@ TYPE
