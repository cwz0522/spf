\ 18.Feb.2007
\ $Id$
( ���������� ForthML [��� ���������� � SPF4]

�������������
  S" url-of.f.xml" EMBODY [ i*x c-addrz u -- j*x ]
  -- ������� ������ �� ��������� ������ � ������� ���������


�����������
  -- ���� ���������� �� ������������.
)

REQUIRE EXC-DUMP2   ~pinka/spf/exc-dump.f

REQUIRE [UNDEFINED]     lib/include/tools.f
REQUIRE EQUAL           ~pinka/spf/string-equal.f
REQUIRE AsQName         ~pinka/samples/2006/syntax/qname.f \ ������� ����������� ����� � ���� `abc
REQUIRE getAttributeNS  ~pinka/lib/lin/xml/libxml2-dom.f
REQUIRE SPLIT-          ~pinka/samples/2005/lib/split.f
REQUIRE FINE-HEAD       ~pinka/samples/2005/lib/split-white.f
REQUIRE Require         ~pinka/lib/ext/requ.f

MODULE: forthml-support

EXPORT  CONTEXT @  CONSTANT forthml-hidden  DEFINITIONS

[UNDEFINED] &

REQUIRE GERM-A  ~pinka/spf/compiler/index.f

        [IF]    EXPORT
: & & ;
                DEFINITIONS
        [THEN]

VARIABLE cnode-a

Include cdomnode.immutable.f

EXPORT

Require gtNUMBER aliases.f \ ����� ���������

DEFINITIONS

?C-JMP TRUE TO ?C-JMP  \ ��������� ��������� �����������: [CALL XXX][RET] --> [JMP XXX]
                       \ ��������� ��� ������� ������������.

Include ttext-index.auto.f \ � ���� ����������� ����-������
\ ������������� T-PLAIN -- ����� ��� ���������� ������,
\ ���� ��� ���������� xml-������, ���������� ��������� M � STATE

..: AT-PROCESS-STARTING _document-storage 0! ;.. \ ���  model/trans/document-context.f.xml

UNIX-LINES
Include ~pinka/fml/forthml-core.f \ ������� ����� ���� (������) ForthML
DOS-LINES

: EMBODY ( i*x url-a url-u -- j*x )
\ set and restore CURFILE (spf4 specific)
  CURFILE @ >R   2DUP HEAP-COPY CURFILE !
    ['] EMBODY CATCH
  CURFILE @ FREE THROW   R> CURFILE !
    THROW
;

\ �������� ForthML ������� ������:
`~pinka/fml/src/rules-common.f.xml FIND-FULLNAME EMBODY
`~pinka/fml/src/rules-forth.f.xml  FIND-FULLNAME EMBODY

\ ���������� ��������� ForthML �� ������� ������:
`~pinka/model/lib/string/match-white.f.xml  FIND-FULLNAME EMBODY
`~pinka/model/trans/rules-std.f.xml         FIND-FULLNAME EMBODY
`~pinka/model/trans/split-line.f.xml        FIND-FULLNAME EMBODY
`~pinka/model/trans/rules-ext.f.xml         FIND-FULLNAME EMBODY
`~pinka/model/trans/rules-string.f.xml      FIND-FULLNAME EMBODY

\ ����������� URI-��� (��������, http://forth.org.ru/ �� ������� ��������� �������� �������)
`~pinka/model/trans/xml-uri-map.f.xml       FIND-FULLNAME EMBODY


TO ?C-JMP  \ ��������� ���������� ������, �.�. ���� ����� ��� r-�������������� ����.


EXPORT

`EMBODY             2DUP aka

`CONTAINS           2DUP aka
`STARTS-WITH        2DUP aka
`ENDS-WITH          2DUP aka
`SUBSTRING-AFTER    2DUP aka
`SUBSTRING-BEFORE   2DUP aka
`SPLIT-             2DUP aka
`SPLIT              2DUP aka
`MATCH-STARTS       2DUP aka


`IS-WHITE           2DUP aka
`FINE-HEAD          2DUP aka
`FINE-TAIL          2DUP aka
`SPLIT-WHITE-FORCE  2DUP aka
`-SPLIT-WHITE-FORCE 2DUP aka
`UNBROKEN           2DUP aka
`WORD|TAIL          2DUP aka

`T-PLAIN            2DUP aka

;MODULE 
\ ALSO forthml-support
