\ $Id$
\ ���������� ��������� - regular expression, regex, regexp, RE
\ ������������ ������� (unicode to do)
\ ������ ���������� NFA ��������� �� http://swtch.com/~rsc/regexp/regexp1.html

\ ������������ ���������� �� ����� ��-��������� � �������� dll
\ 1 - �� ����� dll :)
\ 2 - ����� ������� ����������� �������
\ 3 - ��������� ���� �������� ������ RE" �������� �� ����� ���������� � ��������� �
\     �������� ������� ��������� ������ ��������� ������� �� ���� � ��������!

\ TODO: �������� matching
\ TODO: ���������� ������
\ TODO: ������������ �������-������������
\ TODO: ����� 2

\ POSIX standard - http://www.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap09.html
\ Perl RE doc - http://perldoc.perl.org/perlre.html

\ ������� :
\ () ��������� ������������
\ + �������� "1 ��� ������"
\ ? �������� "0 ��� 1"
\ * �������� "1 ��� ������"
\ | �������� "���"
\ . ����� ������
\ \ ������������ ����������� (����) ��������

\ -----------------------------------------------------------------------

\ ��������� ���������� ��������� re-a re-u � ������ a u, ������� TRUE � ������ ������
\ re_match? ( a u re-a re-u -- ? )

\ �������������� ���� �������� �������
\ RE" ( -- re )

\ ����������� ���������������� ������� � ������
\ regex_match? ( a u re -- ? )

\ -----------------------------------------------------------------------

REQUIRE ANSI-FILE lib/include/ansi-file.f
REQUIRE ��������� ~profit/lib/chartable.f
REQUIRE { lib/ext/locals.f
REQUIRE list-find ~ygrek/lib/list/more.f
REQUIRE LAMBDA{ ~pinka/lib/lambda.f
REQUIRE DOT-LINK ~ygrek/lib/dot.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE TYPE>STR ~ygrek/lib/typestr.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE BOUNDS ~ygrek/lib/string.f
REQUIRE ENUM: ~ygrek/lib/enum.f
REQUIRE A_BEGIN ~mak/lib/a_if.f

MODULE: regexp

\ ������� chartable.f
: state ��������� ;
: symbol: ������: ;
: all: ���: ;
: symbol ������ ;
: rollback1 �������-����� ;
: on-enter: ��-�����: ;
: current-state chartable::�������-��������� ;
: current-state! chartable::TO �������-��������� ;
: execute-one ���������-����-��� ;
: state-table ������� ;
: eol: ������-���������: ;

state in-branch-0
state in-branch-1
state in-branch-2
state in-branch-3

state start-fragment
state no-brackets-fragment
state brackets-fin
state fragment-final current-state VALUE 'fragment-final
state fragment-error

state quoted-symbol

0 VALUE re_limit \ �������� ����� ���������
0 VALUE re_start \ ��������� ����� ���������

VARIABLE process-continue

: run-parser ( a - )
   1 TO ������-�������
   ���������-������
   process-continue ON
   BEGIN
    process-continue @
   WHILE
    ������ re_limit >= IF ���������-��������� EXIT THEN
    ����-����� ���������-����-���
   REPEAT ;

\ VARIABLE indent

\ : doi CR indent @ SPACES  ;

: get-fragment ( -- frag )
   \ doi ." get-fragment " DEPTH .
   \ indent 1+!
   current-state >R
   start-fragment
   ������ run-parser
   current-state 'fragment-final <>
   R> current-state!
   process-continue ON
   IF ABORT THEN
   \ indent @ 1- indent !
   \ IF doi ." get-fragment fail" ABORT THEN
   \ doi ." get-fragment done"
;

\ ��������-�������-��������

\ -----------------------------------------------------------------------

:NONAME DUP CONSTANT 1+ ; ENUM 1+const:

256 1+const: STATE_SPLIT STATE_FINAL STATE_MATCH_ANY ; DROP

0
CELL -- .c    \ ���������
CELL -- .out1 \ ������ �����
CELL -- .out2 \ ������
CONSTANT /NFA

0
CELL -- .i  \ ��������� ��������� ����� ���������
CELL -- .o  \ ������ ������� ����� ���������
CONSTANT /FRAG

: FREE-FRAG ( frag -- ) DUP .o @ FREE-LIST FREE THROW ;
: FREE-NFA ( nfa -- ) FREE THROW ;

VECT NEW-NFA

: NEW-NFA-DYN /NFA ALLOCATE THROW ;
: NEW-NFA-STATIC HERE /NFA ALLOT ;

: frag ( nfa out-list -- frag )
   /FRAG ALLOCATE THROW >R
   R@ .o !
   R@ .i !
   R> ;

: nfa { c link1 link2 | nfa -- nfa }
   NEW-NFA -> nfa
   c nfa .c !
   link1 nfa .out1 !
   link2 nfa .out2 !
   nfa ;

\ ������� �������� � ���������� ����� c
: liter ( c -- frag ) 0 0 nfa %[ DUP .out1 % ]% frag ;

\ ���������� . ��� ���� ������
: liter1 ( c -- frag ) DUP [CHAR] . = IF DROP STATE_MATCH_ANY THEN liter ;

\ ��������� ��� ������ ��������� frag1 � ��������� nfa
: link { frag1 nfa -- }
   nfa LAMBDA{ OVER SWAP ! } frag1 .o @ mapcar DROP ;

\ ������������ ��� ������ ��������� frag � ������� ������
: outs% ( frag -- ) .o @ ['] % SWAP mapcar ;

\ �������� ���������
: finalstate ( -- nfa ) STATE_FINAL 0 0 nfa ;

\ ������ ��������
: emptyfragment ( -- nfa ) STATE_SPLIT liter ;

\ �������� �������� ���������
: finalize ( frag -- frag ) DUP finalstate link ;

\ ���������������� ���������� ���� ����������
: concat { e1 e2 -- e }
  e1 e2 .i @ link
  e1 .i @ %[ e2 outs% ]% frag
  e2 FREE-FRAG
  e1 FREE-FRAG ;

\ 0 or 1
: op-? { e1 -- e }
  STATE_SPLIT e1 .i @ 0 nfa
  %[ DUP .out2 % e1 outs% ]% frag
  e1 FREE-FRAG ;

\ 0 or more
: op-* { e1 -- e }
  STATE_SPLIT e1 .i @ 0 nfa
  e1 OVER link
  ( nfa )
  %[ DUP .out2 % ]% frag
  e1 FREE-FRAG ;

\ 1 or more
: op-+ { e1 -- e }
  STATE_SPLIT e1 .i @ 0 nfa
  e1 OVER link
  ( nfa )
  e1 .i @ %[ SWAP .out2 % ]% frag
  e1 FREE-FRAG ;

\ alternation
: op-| { e1 e2 }
  STATE_SPLIT e1 .i @ e2 .i @ nfa
  %[ e1 outs% e2 outs% ]% frag
  e1 FREE-FRAG
  e2 FREE-FRAG ;

\ -----------------------------------------------------------------------

: RANGE>S ( addr1 addr2 -- addr1 u ) OVER - 0 MAX ;

: op: S" +?*" all-asc: ;
: |: [CHAR] | asc: ;
: left: [CHAR] ( asc: ;
: right: [CHAR] ) asc: ;
: backslash: [CHAR] \ asc: ;

: unquote-next ( -- c ) current-state >R quoted-symbol ����-����� execute-one R> current-state! ;


256 state-table perform-operation

all: CR ." Bad operation!" ABORT ;
symbol: * op-* ;
symbol: ? op-? ;
symbol: + op-+ ;


\ ������������
quoted-symbol

all: CR ." ERROR: Quoting \" symbol EMIT ."  not allowed!" fragment-error ;
S" .\()*|+?{" all-asc: symbol ;


: get-branch ( -- frag )
    \ doi ." get-branch " DEPTH .
    \ indent 1+!
    current-state >R
    in-branch-0
    ������ run-parser
    current-state 'fragment-final <>
    R> current-state!
    process-continue ON
    IF ABORT THEN
    \ indent @ 1- indent !
    \ IF doi ." get-branch fail" ABORT THEN
    \ doi ." get-branch done"
;


\ �� ����� �����
in-branch-0

all: rollback1 get-fragment in-branch-1 ;
|: emptyfragment in-branch-2 ;
right: fragment-error ;
eol: fragment-error ;


\ �� ����� ���� ��������
in-branch-1

all: rollback1 get-fragment concat ;
|: in-branch-2 ;
right: rollback1 fragment-final ;
eol: fragment-final ;


\ �� ����� ���� �����
in-branch-2

all: rollback1 get-fragment in-branch-3 ;
|: emptyfragment op-| ;
right: emptyfragment op-| rollback1 fragment-final ;
eol: emptyfragment op-| fragment-final ;


\ �� ����� ���� ����� � ���� ��������
in-branch-3

all: rollback1 get-fragment concat ;
|: op-| in-branch-2 ;
right: op-| rollback1 fragment-final ;
eol: op-| fragment-final ;


\ ������ RE ���������
start-fragment

all: symbol liter1 no-brackets-fragment ;
op: fragment-error ;
left: get-branch brackets-fin ;
right: fragment-error ;
backslash: unquote-next liter no-brackets-fragment ;
eol: fragment-final ;
|: fragment-error ;


\ ��������� �� ���������, �.�. ���� ������ ��� ���� (� �������� ������ ����� ��������)
no-brackets-fragment

all: rollback1 fragment-final ;
op: symbol perform-operation fragment-final ;
eol: fragment-final ;


\ ����� ���������� ��������� - ������ ���� ����������� ������
brackets-fin

all: fragment-error ;
right: no-brackets-fragment ;
eol: fragment-error ;


\ �������� �������
fragment-final

on-enter: process-continue OFF ;
all: CR ." ALREADY IN FINAL STATE!" ;


\ ������
fragment-error

on-enter:
 ALSO regexp
 " REGEX SYNTAX ERROR : position {������ re_start -} in {re_start ������ RANGE>S}<!>{������ re_limit RANGE>S}"
 PREVIOUS
 CR STYPE CR
 process-continue OFF ;
all: CR ." ALREADY IN ERROR STATE!" ;

\ -----------------------------------------------------------------------

\ ��� ���������� �� ����� ������ ����
() VALUE visited

: clean-visited ( -- ) visited FREE-LIST () TO visited ;

\ ����������� ������������ NFA
: (FREE-NFA-TREE) ( nfa -- )
   DUP visited member? IF DROP EXIT THEN
   DUP visited vcons TO visited
   DUP .out1 @ ?DUP IF RECURSE THEN
   DUP .out2 @ ?DUP IF RECURSE THEN
   FREE-NFA ;

\ ���������� ��� ��������� ������ �������������� ���������� ���������
: FREE-NFA-TREE ( nfa -- ) (FREE-NFA-TREE) clean-visited ;

\ ��������� RE �������� ������� a u
\ � ������ ������ ���������� - ������������ ����������
: (parse-full) ( a u -- nfa )
    OVER TO re_start + TO re_limit
    re_start ���������-������
    get-branch
    finalize
    DUP .i @
    SWAP FREE-FRAG ;

EXPORT

: build-regex-static
   ['] NEW-NFA-STATIC TO NEW-NFA (parse-full) ;

: build-regex
   \ 0 indent !
   ['] NEW-NFA-DYN TO NEW-NFA (parse-full) ;

DEFINITIONS

: BUILD-REGEX-HERE
   POSTPONE A_AHEAD
   build-regex-static
   POSTPONE A_THEN
   POSTPONE LITERAL ; IMMEDIATE

\ -----------------------------------------------------------------------

: STATE>S { nfa -- a u }
   nfa .c @ STATE_SPLIT = IF S" " EXIT THEN
   nfa .c @ STATE_FINAL = IF S" final" EXIT THEN
   nfa .c @ STATE_MATCH_ANY = IF S" any" EXIT THEN
   nfa .c @ [CHAR] \ = IF S" \\" EXIT THEN
   nfa .c @ BL 1+ < IF nfa .c @ <# [CHAR] ) HOLD S>D #S S" ascii(" HOLDS #> EXIT THEN
   nfa .c 1 ;

: (dot-draw) { from nfa | s1 s2 -- }
   nfa " {n}" DUP STR@ nfa STATE>S DOT-LABEL STRFREE
   from " {n}" -> s1  nfa " {n}" -> s2
   s1 STR@ s2 STR@ DOT-LINK
   s1 STRFREE s2 STRFREE
   nfa visited member? IF EXIT THEN
   nfa visited vcons TO visited
   nfa .out1 @ ?DUP IF nfa SWAP RECURSE THEN
   nfa .out2 @ ?DUP IF nfa SWAP RECURSE THEN ;

: dot-draw ( nfa -- ) 0 SWAP (dot-draw) clean-visited ;

EXPORT

\ ����������� RE � ���� dot-��������� � ����� a u
: dottify ( nfa a u -- ) dot{ dot-draw }dot ;
: dotto: ( "name" -- ? )
   ['] build-regex CATCH IF 2DROP PARSE-NAME 2DROP FALSE ELSE PARSE-NAME dottify TRUE THEN ;

DEFINITIONS

\ -----------------------------------------------------------------------

\ �������� ��������� � ������ �������
\ nondeterm ������� ������ ����
: addstate { nfa l -- l2 }
   nfa 0 = IF l EXIT THEN
   nfa l member? IF l EXIT THEN
   nfa .c @ STATE_SPLIT = IF
    nfa .out1 @ l RECURSE -> l
    nfa .out2 @ l RECURSE
    EXIT
   THEN
   nfa l vcons ;

\ ������ c ������������� ��������� r
: char-match? { r c -- ? }
   r 256 < IF r c = EXIT THEN
   r STATE_MATCH_ANY = IF TRUE EXIT THEN
   FALSE ;

\ l1 - ������ ��������� ����������� ����
\ c - �������������� ������ �� ������
\ ������� ������ ���������
: step { c l1 | l2 -- l }
   () TO l2
   l1
   BEGIN
    DUP empty? 0=
   WHILE
    DUP car DUP .c @ c char-match? IF .out1 @ l2 addstate -> l2 ELSE DROP THEN
    cdr
   REPEAT
   DROP
   l2 ;

\ REQUIRE write-list ~ygrek/lib/list/write.f

EXPORT

\ ������������� RE ��������� � ������
: regex_match? { a u re | l1 -- ? }
   () -> l1
   re l1 addstate -> l1
   a u BOUNDS ?DO
    I C@ l1 step ( l ) l1 FREE-LIST ( l ) -> l1
    \ CR I a - . l1 write-list
   LOOP
   LAMBDA{ .c @ STATE_FINAL = } l1 list-find NIP
   l1 FREE-LIST ;

\ ��������� ���������� ��������� r-a r-u � ������ a u, ������� TRUE � ������ ������
: re_match? ( a u re-a re-u -- ? )
   build-regex >R
   R@ regex_match?
   R> FREE-NFA-TREE ;

\ �������� ������ ������������ ��������
\ ������� ������ ������ �������� ��������� \" - ����� �������� �� ����� ���������� �� ���� �������
\ ��� ������ �������������� � �������
\ �� ����� ���������� �������� ���������������� ������� �� ����
\
\ update: is is illegal RE!
\ corner case - ���� ����� �������� ���� � ����� ������, �� �������� �� ��������� ��������
\ RE" (my_\"regex\"_here\\)" �������� ������� ����, �.�. ���� ������� (��� �� ������ ���������� ���������!)
\
: RE" \ Compile-time: ( "regex" -- )
\ runtime: ( -- re )
   "" >R
   BEGIN
    [CHAR] " PARSE
    2DUP + 1- C@ [CHAR] \ =
   WHILE
    1- R@ STR+
    " {''}" R@ S+
   REPEAT
   R@ STR+
   R@ STR@ POSTPONE BUILD-REGEX-HERE
   R> STRFREE ; IMMEDIATE

\ �������� ������ �� ������� ����� ������, �������������� � RE
\ �� ����� ���������� ������� RE �� ����
: EOLRE: ( -- re ) -1 PARSE POSTPONE BUILD-REGEX-HERE ; IMMEDIATE

;MODULE

\ -----------------------------------------------------------------------

/TEST

REQUIRE TESTCASES ~ygrek/lib/testcase.f

TESTCASES regex parsing

(( S" 1+"               dotto: 01.dot -> TRUE ))
(( S" (1+234*5?)"       dotto: 02.dot -> TRUE ))
(( S" (1)"              dotto: 03.dot -> TRUE ))
(( S" (1(23)?(4)+)"     dotto: 04.dot -> TRUE ))
(( S" 1"                dotto: 05.dot -> TRUE ))
(( S" (32|46)2"         dotto: 06.dot -> TRUE ))
(( S" ((32)|(46))7"     dotto: 07.dot -> TRUE ))
(( S" ((32)|((46)+))+2" dotto: 08.dot -> TRUE ))
(( S" (1|2|3)+"         dotto: 09.dot -> TRUE ))
(( S" .*abc.*"          dotto: 10.dot -> TRUE ))
(( S" \.\*ab\\c\.\*"    dotto: 11.dot -> TRUE ))
(( S" for(th(er)?|um|)" dotto: 12.dot -> TRUE ))

CR .( NB: 'REGEX SYNTAX ERROR' messages are expected in this test!)

(( S" (1"     dotto: error.dot -> FALSE ))
(( S" (1++)"  dotto: error.dot -> FALSE ))
(( S" ()"     dotto: error.dot -> FALSE ))
(( S" +"      dotto: error.dot -> FALSE ))
(( S" (*)"    dotto: error.dot -> FALSE ))
(( S" 123(*)" dotto: error.dot -> FALSE ))
(( S" a\bc"   dotto: error.dot -> FALSE ))

END-TESTCASES



TESTCASES regex matching

(( S" 12+1?3" S" 12222213" 2SWAP re_match? -> TRUE ))
(( S" 12+1?3" S" 1223" 2SWAP re_match? -> TRUE ))
(( S" 12+1?3" S" 1213" 2SWAP re_match? -> TRUE ))
(( S" 12+1?3" S" 123" 2SWAP re_match? -> TRUE ))

(( S" 12+1?3" S" 113" 2SWAP re_match? -> FALSE ))
(( S" 12+1?3" S" 1222221" 2SWAP re_match? -> FALSE ))
(( S" 12+1?3" S" 2222213" 2SWAP re_match? -> FALSE ))

(( S" 1((ab)|(cd))+" S" 1ababcdab" 2SWAP re_match? -> TRUE ))
(( S" 1((ab)|(cd))+" S" 1ababab" 2SWAP re_match? -> TRUE ))
(( S" 1((ab)|(cd))+" S" 1cdcdcd" 2SWAP re_match? -> TRUE ))
(( S" 1((ab)|(cd))+" S" 1cdabcdab" 2SWAP re_match? -> TRUE ))
(( S" 1((ab)|(cd))+" S" 1ab" 2SWAP re_match? -> TRUE ))
(( S" 1((ab)|(cd))+" S" 1cd" 2SWAP re_match? -> TRUE ))

(( S" 1((ab)|(cd))+" S" 1" 2SWAP re_match? -> FALSE ))
(( S" 1((ab)|(cd))+" S" 1abc" 2SWAP re_match? -> FALSE ))

(( S" (ab|cd)+" S" abdacd" 2SWAP re_match? -> FALSE ))
(( S" (ab|cd)+" S" abdabdacdabd" 2SWAP re_match? -> FALSE ))
(( S" (ab|cd)+" S" acd" 2SWAP re_match? -> FALSE ))
(( S" (ab|cd)+" S" abd" 2SWAP re_match? -> FALSE ))
(( S" (ab|cd)+" S" acdacd" 2SWAP re_match? -> FALSE ))
(( S" (ab|cd)+" S" " 2SWAP re_match? -> FALSE ))

(( S" (ab|cd)+" S" abcd" 2SWAP re_match? -> TRUE ))
(( S" (ab|cd)+" S" abab" 2SWAP re_match? -> TRUE ))
(( S" (ab|cd)+" S" ababcd" 2SWAP re_match? -> TRUE ))
(( S" (ab|cd)+" S" abcdab" 2SWAP re_match? -> TRUE ))
(( S" (ab|cd)+" S" cdcdab" 2SWAP re_match? -> TRUE ))
(( S" (ab|cd)+" S" cd" 2SWAP re_match? -> TRUE ))
(( S" (ab|cd)+" S" ab" 2SWAP re_match? -> TRUE ))

(( S" a(1|2|3)b(1|2|3)c" S" a1b1c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a1b2c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a1b3c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a2b1c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a2b2c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a2b3c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a3b1c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a3b2c" 2SWAP re_match? -> TRUE ))
(( S" a(1|2|3)b(1|2|3)c" S" a3b3c" 2SWAP re_match? -> TRUE ))

(( S" a(1|2|3)b(1|2|3)c" S" a4b1c" 2SWAP re_match? -> FALSE ))
(( S" a(1|2|3)b(1|2|3)c" S" a22c" 2SWAP re_match? -> FALSE ))
(( S" a(1|2|3)b(1|2|3)c" S" a2b3" 2SWAP re_match? -> FALSE ))

(( S" forther" S" for(th(er)?|um|)" re_match? -> TRUE ))
(( S" forth"   S" for(th(er)?|um|)" re_match? -> TRUE ))
(( S" forum"   S" for(th(er)?|um|)" re_match? -> TRUE ))
(( S" for"     S" for(th(er)?|um|)" re_match? -> TRUE ))

(( S" fort"     S" for(th(er)?|um|)" re_match? -> FALSE ))
(( S" forther1" S" for(th(er)?|um|)" re_match? -> FALSE ))
(( S" forthum"  S" for(th(er)?|um|)" re_match? -> FALSE ))

END-TESTCASES


: qqq RE" 123\"qwerty\"" regex_match? ;
: email? RE" .+@.+\..+" regex_match? ;

TESTCASES RE"

(( " 123{''}qwerty{''}" STR@ qqq -> TRUE ))
(( " 123{''}qwerty"     STR@ qqq -> FALSE ))

(( S" he!!o@example.com" email? -> TRUE ))
(( S" a@a.com" email? -> TRUE ))
(( S" a@a.b.com" email? -> TRUE ))

(( S" a[at]a.com" email? -> FALSE ))
(( S" a@acom" email? -> FALSE ))

END-TESTCASES


\EOF