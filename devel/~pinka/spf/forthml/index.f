\ 18.Feb.2007
( ���������� ForthML

�������������
  S" url-of.f.xml" EMBODY
  -- ������� ������ �� ��������� ������ � ������� ���������


�����������
  -- ���� ���������� �� ������������.
)

\ REQUIRE EXC-DUMP2   ~pinka/spf/exc-dump.f
REQUIRE [UNDEFINED]     lib/include/tools.f
REQUIRE AsQName         ~pinka/samples/2006/syntax/qname.f \ ������� ����������� ����� � ���� `abc
REQUIRE getAttributeNS  ~pinka/lib/lin/xml/libxml2-dom.f
REQUIRE FINE-HEAD       ~pinka/samples/2005/lib/split-white.f
REQUIRE Require         ~pinka/lib/ext/requ.f

MODULE: forthml-support

REQUIRE GERM-A  ~pinka/spf/compiler/index.f

VARIABLE cnode-a

Include cdomnode.immutable.f

EXPORT

Require gtNUMBER aliases.f \ ����� ���������

DEFINITIONS

Include ttext-index.auto.f \ � ���� ����������� ����-������
\ ������������� T-TEXT -- ����� ��� ���������� ������,
\ ���� ��� ���������� xml-������ � ���������� STATE

Include ~pinka/fml/forthml-rules.f \ � ���� ����������� ����-������
\ ����� ������ ��� ���������� ForthML 

EXPORT

`EMBODY `EMBODY aka

;MODULE