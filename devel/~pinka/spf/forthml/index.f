\ 18.Feb.2007
( ���������� ForthML

�������������
  S" url-of.f.xml" EMBODY [ i*x c-addrz u -- j*x ]
  -- ������� ������ �� ��������� ������ � ������� ���������


�����������
  -- ���� ���������� �� ������������.
)

REQUIRE EXC-DUMP2   ~pinka/spf/exc-dump.f

REQUIRE [UNDEFINED]     lib/include/tools.f
REQUIRE AsQName         ~pinka/samples/2006/syntax/qname.f \ ������� ����������� ����� � ���� `abc
REQUIRE getAttributeNS  ~pinka/lib/lin/xml/libxml2-dom.f
REQUIRE SPLIT-          ~pinka/samples/2005/lib/split.f
REQUIRE FINE-HEAD       ~pinka/samples/2005/lib/split-white.f
REQUIRE Require         ~pinka/lib/ext/requ.f


MODULE: forthml-support

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

UNIX-LINES
Include ~pinka/fml/forthml-core.f \ ������ ����� ���� (������) ForthML
DOS-LINES

`~pinka/fml/src/rules-common.f.xml FIND-FULLNAME EMBODY
`~pinka/fml/src/rules-forth.f.xml  FIND-FULLNAME EMBODY

TO ?C-JMP

EXPORT

`EMBODY `EMBODY aka

;MODULE 
\ ALSO forthml-support
