���������� �� ������ ������������ SPF
=====================================

��������� ����������: $Date$

## ��� ����:

* ������ ������� ����� CVS �����������. ��� ������ ������.
* jpf375c.exe
* spf4_notitle ������� �� ������� ������������ ��������� � stdout. �������� ���
        spf4.exe ' NOOP MAINX ! S" spf4_notitle.exe" SAVE BYE
* NSIS <http://nsis.sourceforge.net>
* upx (�� �����������) <http://upx.sourceforge.net>
* markdown
* GNU make <http://mingw.org/download.shtml> <http://www.gnu.org/software/make/>

## ��� ����� markdown?

Markdown ��� ������� ��������(������� Wiki) ��������� ������ ��� ����������� �
HTML. ���� ���� � ��������� ������ � ��������� markdown. ��� �����������
������������ ����������� ������� - ������������ ������� �� �����, ���� �����
���������� �� Python, Lua, PHP etc. ���������� � ���������� markdown -
����������� �� ���������� ������ � ����
        markdown input.md
������� html �������� (��� ����������) �� stdout. �������� � ���� ��� .bat ����
� PATH �� ��������� ����������
        python D:\WORK\markdown\markdown-1-5.py %*

����������� ���� - <http://daringfireball.net/projects/markdown>
������ �� �������������� ���������� - <http://en.wikipedia.org/wiki/Markdown>

## ��� ������:

1. ����������� jpf375c.exe � �������� ������� ������� �����.
2. ������� � ������� tools/nsis.
3. ��������� (���������������) ��������� � Makefile
4. ��������� make

��.
