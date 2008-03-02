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

REQUIRE lexicon.basics-aligned ~pinka/lib/ext/basics.f


REQUIRE GET-FILE      ~ac/lib/lin/curl/curl.f
REQUIRE UNICODE>UTF8  ~ac/lib/win/com/com.f
\ �����, ����� �� ���� � ��������� ������� ������ � lin/xml/xml.f


Require ULT             aliases.f \ ����� ���������

REQUIRE EQUAL           ~pinka/spf/string-equal.f
REQUIRE SPLIT-          ~pinka/samples/2005/lib/split.f
REQUIRE FINE-HEAD       ~pinka/samples/2005/lib/split-white.f


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
\ ������������ ���������� � ������� forthml-support (������ forthml-hidden)

CODEGEN-WL ALSO!  XMLDOM-WL  ALSO!
MODULE: forthml-support  EXPORT  CONTEXT @ CONSTANT forthml-hidden  DEFINITIONS

VARIABLE cnode-a \ ������� ���� XML-���������

Include cdomnode.immutable.f  \ DOM-������ � ��������� ����, ����� XML-������

;MODULE PREVIOUS PREVIOUS


?C-JMP TRUE TO ?C-JMP  \ ��������� ��������� �����������: [CALL XXX][RET] --> [JMP XXX]
                       \ ��������� ��� ������� ������������.
( prev-flag )




GET-CURRENT GET-ORDER ( ..prev-context.. )

FORTH-WORDLIST XMLDOM-WL CODEGEN-WL forthml-hidden  4 SET-ORDER  DEFINITIONS

: T-WORD-TC ( i*x addr u -- j*x )
  CODEGEN-WL     RESOLVE-NAME IF EXECUTE EXIT THEN
  FORTH-WORDLIST RESOLVE-NAME IF EXECUTE EXIT THEN
  NOTFOUND
;
: (INCLUDED-PLAIN-TC) ( i*x -- j*x )
  BEGIN PARSE-NAME DUP WHILE T-WORD-TC REPEAT 2DROP
;
: INCLUDED-PLAIN-TC ( a u -- )
  FIND-FULLNAME2 FILE ['] (INCLUDED-PLAIN-TC) EVALUATE-WITH
  \ - relative to current file
;

`ttext-index.auto.f INCLUDED-PLAIN-TC \ � ���� ����������� ����-������
\ ������������� T-PLAIN -- ����� ��� ���������� ������,
\ ���� ��� ���������� xml-������, ���������� ��������� M � STATE


..: AT-PROCESS-STARTING init-document-context ;.. \ ���  model/trans/document-context2.f.xml
                        init-document-context \ ������ � ������ � ����� ��


VECT T-PAT  ' T-SLIT TO T-PAT \ ������������ ��� <get-name/>

`~pinka/fml/forthml-core.f Included \ ������� ����� ���� (������) ForthML


\ ---
\ set and restore CURFILE on EMBODY (spf4 specific)
WARNING @  WARNING 0! 

: EMBODY ( i*x url-a url-u -- j*x )
  CURFILE @ >R   2DUP HEAP-COPY CURFILE !
    0 ['] EMBODY RECEIVE-WITH \ ������ SAVE-ERR
  CURFILE @ FREE THROW   R> CURFILE !
    THROW
;
WARNING !


\ �������� ForthML ������� ������:
`~pinka/fml/src/rules-common.f.xml FIND-FULLNAME EMBODY
`~pinka/fml/src/rules-forth.f.xml  FIND-FULLNAME EMBODY


\ ���������� ��������� ForthML �� ������� ������:
`~pinka/model/lib/string/match-white.f.xml  FIND-FULLNAME EMBODY
`~pinka/model/trans/rules-std.f.xml         FIND-FULLNAME EMBODY
`~pinka/model/trans/split-line.f.xml        FIND-FULLNAME EMBODY
`~pinka/model/trans/rules-ext.f.xml         FIND-FULLNAME EMBODY
`~pinka/model/trans/rules-string.f.xml      FIND-FULLNAME EMBODY


document-context-hidden PUSH-SCOPE `tpat-hidden WORDLIST-NAMED PUSH-DEVELOP

`~pinka/model/trans/tpat.f.xml              FIND-FULLNAME EMBODY

DROP-DEVELOP DROP-SCOPE   `T-PAT tpat-hidden RESOLVE-NAME 0EQ THROW TO T-PAT

  


\ ����������� URI-��� (��������, http://forth.org.ru/ �� ������� ��������� �������� �������)
`~pinka/model/trans/xml-uri-map.f.xml       FIND-FULLNAME EMBODY


SET-ORDER SET-CURRENT

TO ?C-JMP  \ ��������� ���������� ������, �.�. ���� ����� ��� r-�������������� ����.


forthml-hidden PUSH-SCOPE

`EMBODY             2DUP aka

`CONTAINS           2DUP aka
`STARTS-WITH        2DUP aka
`ENDS-WITH          2DUP aka
`SUBSTRING-AFTER    2DUP aka
`SUBSTRING-BEFORE   2DUP aka

`MATCH-HEAD         2DUP aka

`IS-WHITE           2DUP aka
`WORD|TAIL          2DUP aka

`T-PLAIN            2DUP aka

DROP-SCOPE
