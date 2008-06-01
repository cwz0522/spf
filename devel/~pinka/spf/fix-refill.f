\ Dec.2006 ruvim@forth.org.ru
\ $Id$
( ����������� ������ SPF4, ��������� � �������� ����������� ������ �� ������.
  ��������� ���������� ����������������� ������ �������� ������ ����� READ-LINE
  [����������� ��� � 2000-�� :]

  ���� ���������� �������� 8-13% ��� ������������ �������� ������
  [��������� ��� ���������� QuickSWL]

  �������� ������ - ����� REFILL ������� ������ ����� �� ����������� ����� 
  � �������� ��������� �� ��������� ������.  ��� ������������ � �����������, 
  ������� ������ �� �������� ������ �������� ������ � ��������� �� �������� ������.

  ��� ����������� ������ �������� ������ �� �������� ������ 
  ����� ���������� ����� READOUT-SOURCE [ addr u1 -- addr u2 ]

  ������������ 0A � �������� ����������� ������, ����� 0D0A �� ������.

  ������ ���������� ������������ � ����� ������������ ���������� SAVE-INPUT [������� � core-ext.f]

  ���� ��������� ������� � ��������� ACCEPT - ��� �������� PARSE-AREA ����� SOURCE-ID �������.
)

REQUIRE REPLACE-WORD lib/ext/patch.f
REQUIRE SPLIT- ~pinka/samples/2005/lib/split.f
REQUIRE UNBROKEN ~pinka/samples/2005/lib/split-white.f

REQUIRE Included ~pinka/lib/ext/requ.f

: SPLIT-LINE ( a u -- a1 u1 a2 u2 true | a u false )
  LT LTL @ SPLIT DUP IF EXIT THEN DROP
  LT CHAR+ 1 SPLIT  \ support of 0x0A as line terminator
;

: READOUT-FILE ( a u1 h -- a u2 ior )
  >R OVER SWAP R> READ-FILE ( a u2 ior )
  DUP 109 = IF 2DROP 0. THEN
;

WARNING @  WARNING 0!

S" fix-accept.f" Included

S" fix-receive.f" Included

WARNING !