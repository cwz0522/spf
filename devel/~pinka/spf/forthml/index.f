\ 18.Feb.2007
\ $Id$
( ���������� ForthML [��� ���������� � SPF4]

�������������
  S" url-of.f.xml" EMBODY [ i*x c-addrz u -- j*x ]
  -- ������� ������ �� ��������� ������ � ������� ���������


�����������
  -- ���� ���������� �� ������������.
)


REQUIRE [UNDEFINED]     lib/include/tools.f
REQUIRE AsQName         ~pinka/samples/2006/syntax/qname.f \ ������� ����������� ����� � ���� `abc
REQUIRE CORE_OF_REFILL  ~pinka/spf/fix-refill.f
REQUIRE Require         ~pinka/lib/ext/requ.f
REQUIRE AT-SAVING-BEFORE ~pinka/spf/storage.f
REQUIRE WITHIN-FORTH-STORAGE-EXCLUSIVE  ~pinka/spf/storage-sync.f

REQUIRE lexicon.basics-aligned ~pinka/lib/ext/basics.f

REQUIRE CREATE-CS       ~pinka/lib/multi/Critical.f 
\ ���, ������ ��� ������������ ������������� ��� ������ �� ������


Require ULT             aliases.f \ ����� ���������

\ �������� ��������������, ����������� ����, ���������� �������� ����:
REQUIRE CODEGEN-WL      ~pinka/spf/compiler/index.f



\ �������� � libxml2 � XMLDOM -- � ��������� ������� XMLDOM-WL

CODEGEN-WL ALSO!

[UNDEFINED] getAttributeNS [IF]
`XMLDOM-WL WORDLIST-NAMED PUSH-DEVELOP

`~pinka/lib/lin/xml/libxml2-dom.f        INCLUDED

DROP-DEVELOP
[ELSE]
 `getAttributeNS FORTH-WORDLIST SEARCH-WORDLIST  [IF]
  FORTH-WORDLIST CONSTANT XMLDOM-WL              [ELSE]
 .( Wid of libxml2-dom.f is not found ) CR ABORT [THEN]
[THEN]

PREVIOUS



\ -----
\ ������������ ���������� � ������ forthml-hidden

CODEGEN-WL ALSO!  XMLDOM-WL  ALSO!
`forthml-hidden WORDLIST-NAMED PUSH-DEVELOP

VARIABLE cnode-a \ ������� ���� XML-���������

Include cdomnode.immutable.f  \ DOM-������ � �������� ����, ����� XML-������

DROP-DEVELOP PREVIOUS PREVIOUS


?C-JMP TRUE TO ?C-JMP  \ ��������� ��������� �����������: [CALL XXX][RET] --> [JMP XXX]
                       \ ��������� ��� ������� ������������.
( prev-flag )




GET-CURRENT GET-ORDER ( ..prev-context.. )

FORTH-WORDLIST XMLDOM-WL CODEGEN-WL forthml-hidden  4 SET-ORDER  DEFINITIONS

: T-WORD-TC ( i*x addr u -- j*x )
  CODEGEN-WL     FIND-WORDLIST IF EXECUTE EXIT THEN
  FORTH-WORDLIST FIND-WORDLIST IF EXECUTE EXIT THEN
  NOTFOUND
;
: (INCLUDED-PLAIN-TC) ( i*x -- j*x )
  BEGIN PARSE-NAME DUP WHILE T-WORD-TC REPEAT 2DROP
;
: EVALUATE-PLAIN-TC ( a u -- )
  ['] (INCLUDED-PLAIN-TC) EVALUATE-WITH
  \ - relative to the current file
;
: INCLUDED-PLAIN-TC ( a u -- )
  FIND-FULLNAME2 \ - relative to the current file
  ['] EVALUATE-PLAIN-TC FOR-FILENAME-CONTENT
;

`ttext-index.auto.f INCLUDED-PLAIN-TC \ � ���� ����������� ����-������
\ ������������� T-PLAIN -- ����� ��� ���������� ������,
\ ���� ��� ���������� xml-������, ���������� ��������� M � STATE


..: AT-PROCESS-STARTING init-document-context ;.. \ ���  model/trans/document-context2.f.xml
                        init-document-context \ ������ � ������ � ����� ��


VARIABLE _T-PAT  ' T-SLIT _T-PAT !
: T-PAT _T-PAT @ EXECUTE ; \ ������������ ��� <get-name/>

`~pinka/fml/forthml-core.auto.f Included \ ������� ����� ���� (������) ForthML


\ ---

`diagnose-error.f Included \ redefine EMBODY to save error location (spf4 specific)


: _EMBODY FIND-FULLNAME2 EMBODY ; \ ��������� � ���� ������-������������� �����

\ �������� ForthML ������� ������:
`~pinka/fml/src/rules-common.f.xml _EMBODY
`~pinka/fml/src/rules-forth.f.xml  _EMBODY

\ ��������� ����� ��������� �����:
`index.L2.f.xml _EMBODY
`index.L3.f.xml _EMBODY




\ ������������� ��� sharedlex
..: AT-PROCESS-STARTING init-sharedlex ;..
                        init-sharedlex

FORTH-WORDLIST PUSH-CURRENT  0 PUSH-WARNING
: ORDER
  ORDER
  sharedlex-hidden::SCOPE-DEPTH IF SHAREDLEX-ORDER. THEN
;

`EMBODY             2DUP aka

DROP-WARNING  DROP-CURRENT


SET-ORDER SET-CURRENT
TO ?C-JMP  \ ��������� ���������� ������, �.�. ���� ����� ��� r-�������������� ����.


REQUIRE enqueueNOTFOUND  ~pinka/spf/notfound-ext.f

: AsForthmlSourceFile ( a u -- a u false | i*x true )
  2DUP S" .f.xml" MATCH-TAIL NIP NIP 0= IF FALSE EXIT THEN
  2DUP + 0 SWAP B!
  2DUP FILE-EXISTS 0= IF FALSE EXIT THEN
  EMBODY TRUE
;
' AsForthmlSourceFile preemptNOTFOUND


\ �����, ���������� ����:
\   ����������, ���������� � ������������ -- 32 ��
\   ���������� ForthML � ��������� -- 47 ��
