���������� �� ������ ������������ SPF
=====================================

��������� ����������: $Date$

## ��� ����:

* ������ ������ ������� ����� CVS �����������. ��� ������ ������.
* jpf375c.exe
* GNU make <http://mingw.org/download.shtml> <http://www.gnu.org/software/make/>
* WinRAR <http://www.rarlabs.com>

��� ������ ������� ������ ����� :

* NSIS <http://nsis.sourceforge.net>
* upx (�� �����������) <http://upx.sourceforge.net>
* perl

## ��� ���� ����� perl?

��� ���� ����� ����������� ���� �� markdown � html.
Markdown ��� ������� ��������(������� Wiki) ��������� ������.
���� ���� � ��������� ������ � �������� markdown. ��� �����������
������������ perl-������.

����������� ���� markdown - <http://daringfireball.net/projects/markdown>

## ��� ������ �������� devel

1. ����������� jpf375c.exe � �������� ������� ������� �����.
2. � �������� src ��������� compile.bat
3. ������� � ������� tools/nsis.
4. ���������(���������������) ���� � makensis � winrar � Makefile
5. ���� ������� make devel-snap

��.

## ��� ������ ������������

1. ����������� jpf375c.exe � �������� ������� ������� �����.
2. ����������� ���������� spf4root � �������� ������� ������� �����.
3. ����������� html � ������������� ����� � http://www.forth.org.ru/~yz
   (�������� wget'��) � �������� � devel/~yz
4. ��������� (���� ���������) SPF-KERNEL-VERSION � 
   src/spf.f
   src/win/res/spf.manifest
   src/win/res/spf.rc
   � ������� src/VERSION.SPF ���� ���� (�� ������ ����!)
5. � �������� src ��������� compile.bat
6. ������� � ������� tools/nsis.
7. ���������(���������������) ���� � makensis � winrar � Makefile
8. ���� ������� make
9. ��������� ����� � src ����������� �� CVS

��.
