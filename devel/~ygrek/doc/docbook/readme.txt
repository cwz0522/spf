$Id$

������������ � SPF devel
========================

��������� ��������� � docs/code, ��� ���� ������������ �� �� �������, � ��
�������� ���������. �������� ����� ���������� ��� ������������� ���������� ���������.
�������� docbook ����� ����� ���������� � ���������� � tools ����� ��� ��
�������� � �����, � ������ ��� ��������������� ������������.

��� ����
========

GNU make <http://mingw.org/download.shtml> <http://www.gnu.org/software/make/>
libxml2, iconv, libxslt <http://www.zlatkovic.com/pub/libxml/>
docbook-xsl <http://sourceforge.net/project/showfiles.php?group_id=21935&package_id=16608>
docbook-xml <http://www.oasis-open.org/docbook/xml/4.5/docbook-xml-4.5.zip>
            ��� <http://www.oasis-open.org/docbook/xml/4.4/docbook-xml-4.4.zip>

xsltproc make � spf ������ ����������� �� ����� (��� �������� ����).

�������
=======

����������� ������ ������������ ��� ~pinka/lib/hash-table.f

������� �������������� �������� ��� :

1. �������� ��� �� ����� � ������� xmlhelp.f ������������ � xml
     spf xmlhelp.f S" hash-table.xml" START-XMLHELP S" ~pinka/lib/hash-table.f" INCLUDED FINISH-XMLHELP BYE

2. ���������� xml � ������� xsltproc.exe � xmlhelp2docbook.xsl ������������ � docbook
     xsltproc xmlhelp2docbook.xsl hash-table.xml > hash-table.docbook

2a. ��������� description, ���������� ������ (������ �� ����� hash-table.more, ���� ��� ��� - ���������)
     spf describe.f S" hash-table.docbook" DESCRIBE BYE

3. � ������������ � ������� docbook-xsl �������� �������� html
     make hash-table.html

� �������� ����� ������� ���������� ���� �������.

�� ����������� ���������� �������������� ������� ������������ ���������� �����
����, ������� ���� ��� ��������
- ���� �� ����� ������ ���� - �������� � �� ������������ ����� �������� ���� ���������
- ����� ���������� docbook ������������ ��� ������ � �������� ����� ������

�� CVS ������� ��������� _������_ ����� docbook.

�������� XML
============

��� ���� ����� ����� ����������� ��������� �� ����� xsl, dtd �� �������� ��
��������� ��������� �� ���������� ������ ������� ������� XML ���������. �
�������� � ��� ����� ����� �������� ���� ���� ��������������.
�� ��-�������� ���� ������� ���������� ��������� XML_CATALOG_FILES
� ��������� �� ���� � �����-�������� docbook-xsl, ���� DTD ���
docbook, � � ������������ ����� ��� xsl, ���������� ����� ������
� ���� ��� ���� -
file:///D:/WORK/docbook/docbook-xsl-1.71.1/catalog.xml
file:///D:/WORK/docbook/docbook-xml-4.4/catalog.xml
file:///D:/WORK/docbook/xslcatalog.xml

��������� ���� � �������� ���, �� �������� ���

<?xml version="1.0"?>
<!DOCTYPE catalog
   PUBLIC "-//OASIS/DTD Entity Resolution XML Catalog V1.0//EN"
   "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd">

<catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
    <uri
        name="html/docbook.xsl"
        uri="file:///D:/WORK/docbook/docbook-xsl-1.71.1/html/docbook.xsl"/>
    <uri
        name="htmlhelp/htmlhelp.xsl"
        uri="file:///D:/WORK/docbook/docbook-xsl-1.71.1/htmlhelp/htmlhelp.xsl"/>
</catalog>


���� ����� �������� - ���������� ���������� XML_DEBUG_CATALOG ��� �������
