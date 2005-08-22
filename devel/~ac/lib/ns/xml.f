( ~ac 20.08.2005
  $Id$

  ����������� ������� XML-������ [�� ����� ����� ��� URL] �
  �������� ������������ ����-�������. � ���������� �����, 
  ������������ ����������, �������� ����� � XML-�����  
  ������������ ����� ��������������� �����, ��� ������������� 
  ������������� XMLDOM � ������ XML-����������� API.

  �������������:
  ALSO XML_DOC NEW: http://forth.org.ru/rss.xml
  - ������� �������, ����������� � ���������� URL � �������
  �� �� ���, � ��������� ���� ������� � �������� ������.
  ����� ���������� ����� ����� ������������ ��������� ����� -
  ���� XML ������������� ���������� � ����� �� ��� ����� �����
  ������������� ���, ��� ���� �� ��� ��� "����������" ����-�������.
  ���������� ���������� ���� �������� ������� ������� ���������
  ������ �� ��������� ���� � ��������� [��� ���� �� �� ��� ���
  ��������� ����� VOCABULARY], � ���������� ����� ����� �������,
  ������� � ����. ����� ������� �������� ������:
  http://forth.org.ru/rss.xml /rss channel title
  ������� � �������� ���������� ������ ��� �� ����, ��� �
  XPath-��������� /rss/channel/title.
  ����� "@" � "." � ���� ���������� �������������� ��� ����������
  � ������ ��������� �������� "����������� �����" ��������������.

  ���������� ��� � ���������, ������� ������� � ����� �� ���������.
)

REQUIRE XML_READ_DOC_ROOT ~ac/lib/lin/xml/xml.f 

<<: FORTH XML_NODE

: SHEADER ( addr u -- )
\ �������� xml-���� � ������ addr u � ������� xml-���� "����������"
  GET-CURRENT OBJ-DATA@ XML_NEW_NODE DROP
;
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ���� � ������ c-addr u � xml-���� oid

  oid OBJ-DATA@ DUP \ node
  IF c-addr u ROT node@ DUP 
     IF \ ������ ���� � �������� ������
        ( ������ � oid ��� � CONTEXT ?! - ������ �������� �������� ...)
        \ oid
        CONTEXT @
        OBJ-DATA! ['] NOOP 1
     THEN
  THEN
  DUP 0=
  IF \ �� ������ � "��������� �������", ������ � "������� ������"
     DROP c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST
  THEN
;
: setNode CONTEXT @ OBJ-DATA! ;
: getNode CONTEXT @ OBJ-DATA@ ;
: @ getNode text@ ;
: . @ TYPE ;
: WORDS getNode XML_NLIST ;
: SAVE ( addr u -- ) GET-CURRENT OBJ-DATA@ NODE>DOC XML_DOC_SAVE ;

>> CONSTANT XML_NODE-WL

: DOC>NODE
  CONTEXT @ OBJ-DATA@ XML_DOC_ROOT
  TEMP-WORDLIST >R
  R@ OBJ-DATA!
  XML_NODE-WL R@ CLASS!
  R> CONTEXT !
;
: VOC-CLONE
  TEMP-WORDLIST >R
  CONTEXT @ CELL- R@ CELL- WL_SIZE MOVE
  ALSO R> CONTEXT !
;

<<: FORTH XML_DOC

: SAVE ( addr u -- ) GET-CURRENT OBJ-DATA@ XML_DOC_SAVE ;

: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }

  c-addr C@ [CHAR] / <> IF 0 EXIT THEN \ � ��������� ���� ������ ������

  oid OBJ-DATA@ \ doc; ���� �� �������� - ��������
  0= IF oid OBJ-NAME@ " {s}" STR@ XML_READ_DOC oid OBJ-DATA! THEN

  oid OBJ-DATA@ DUP
  IF \ ������� ��������� xml, ������ ����� ������ xt,
     \ ������� ������� �������� ��������� �� �������� ��������� ����
     DROP ['] DOC>NODE 1
  THEN
;
:>>

\ ���� ����� << XML_DOC libxml-parser.html , �� ��� ����������� DEFINITIONS

ALSO XML_DOC NEW: libxml-parser.html
libxml-parser.html / head title .
libxml-parser.html / head style .
PREVIOUS

ALSO XML_DOC NEW: eserv.xml
eserv.xml / head link @ FORTH::TYPE
PREVIOUS

ALSO XML_DOC NEW: http://forth.org.ru/
/html head title . CR
http://forth.org.ru/ /html head link @href . CR
\ http://forth.org.ru/ /html head getNode listNodes
PREVIOUS

ALSO XML_DOC NEW: http://forth.org.ru/rss.xml
/rss channel VOC-CLONE
title . CR ( channel/title �������� � ����� )
copyright . CR ( channel/copyright �������� � ��������� )
getNode 1 libxml2.dll::xmlGetNodePath ASCIIZ> TYPE CR
PREVIOUS ( ������ ���� )
getNode 1 libxml2.dll::xmlGetNodePath ASCIIZ> TYPE CR
PREVIOUS ( ������ �������� )

ALSO http://forth.org.ru/rss.xml /rss channel WORDS PREVIOUS

ORDER

ALSO http://forth.org.ru/rss.xml
/rss DEFINITIONS
VOCABULARY TEST
S" ctest.xml" SAVE
