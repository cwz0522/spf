\ $Id$

( ����� ������������ ����������, ������������ ��� ����������
  �������� ���������� � ���� ���������������� �����������.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

: IF  \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: -- orig )
\ �������� �� ����������� ���� ������� ����� ������������� ������ ������ orig.
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������.
\ ��������� �����������, ���� orig �� ����������, ��������, �� THEN ��� ELSE.
\ ����� ����������: ( x -- )
\ ���� ��� ���� x �������, ���������� ���������� � �������, �������� 
\ ����������� orig.
  ?COMP 0 ?BRANCH, >MARK 1
; IMMEDIATE

: ELSE \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: orig1 -- orig2 )
\ �������� �� ����������� ���� ������� ����� ������������� ������ ������ orig2.
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������.
\ ��������� �����������, ���� orig2 �� ���������� (��������, �� THEN). 
\ ��������� ������ ������ orig1, ��������� ������� ��������� ����������� 
\ ��������� ����������.
\ ����� ����������: ( -- )
\ ���������� ���������� � �������, �������� ����������� orig2.
  ?COMP 0 BRANCH,
  >ORESOLVE
  >MARK 2
; IMMEDIATE

: THEN \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: orig -- )
\ ��������� ������ ������ orig, ��������� ������� ��������� ����������.
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������.
\ ����� ����������: ( -- )
\ ���������� ����������.
  ?COMP \ HERE TO :-SET
  >ORESOLVE
; IMMEDIATE

: BEGIN \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: -- dest )
\ �������� ��������� ������� �������� ����������, dest, �� ����������� ����.
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������.
\ ����� ����������: ( -- )
\ ���������� ����������.
  ?COMP
  ALIGN-BYTES @ ALIGN-NOP
\  HERE TO :-SET
  <MARK 3
; IMMEDIATE

: UNTIL \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: dest -- )
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������.
\ ��������� ������ ����� dest.
\ ����� ����������: ( x -- )
\ ���� ��� ���� x �������, ���������� ���������� � �������, �������� dest.
  ?COMP 3 <> IF -2004 THROW THEN \ ABORT" UNTIL ��� BEGIN !"
  ?BRANCH,
  0xFFFFFF80  DP @ 4 - @  U<
  IF  DP @ 5 - W@ 0x3F0 + DP @ 6 - W!   -4 ALLOT
  THEN  DP @ TO :-SET
; IMMEDIATE

: WHILE \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: dest -- orig dest )
\ �������� ������� ����� ������������� ������ ������ orig �� ����������� ����
\ ��� ��������� dest. �������� ��������� ������� ����������, ������ ����, � 
\ �������� �����������. ��������� �����������, ���� orig � dest �� ���������� 
\ (��������, �� REPEAT).
\ ����� ����������: ( x -- )
\ ���� ��� ���� x �������, ���������� ���������� � �������, ��������
\ ����������� orig.
  ?COMP [COMPILE] IF
  2SWAP
; IMMEDIATE

: REPEAT \ 94
\ �������������: ��������� ������������.
\ ����������: ( C: orig dest -- )
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������,
\ �������� ������ ����� dest. ��������� ������ ������ orig, ��������� 
\ ������� ����������� ��������� ����������.
\ ����� ����������: ( -- )
\ ���������� ���������� � �������, �������� dest.
  ?COMP
  3 <> IF -2005 THROW THEN \ ABORT" REPEAT ��� BEGIN !"
  DUP DP @ 2+ - DUP
  SHORT?
  IF SetJP 0xEB C, C, DROP
  ELSE DROP BRANCH, THEN
  >ORESOLVE
; IMMEDIATE

: AGAIN  \ 94 CORE EXT
\ �������������: ��������� ������������.
\ ����������: ( C: dest -- )
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������,
\ �������� ������ ����� dest.
\ ����� ����������: ( -- )
\ ���������� ���������� � �������, �������� dest. ���� ������ ����������� �����
\ �� ������������, �� ����� ����������� ��� ����� AGAIN �� ����� �����������.
  ?COMP 3 <> IF -2006 THROW THEN \ ABORT" AGAIN ��� BEGIN !"
  DUP DP @ 2+ - DUP
  SHORT?
  IF SetJP 0xEB C, C, DROP
  ELSE DROP BRANCH, THEN  DP @ TO :-SET
; IMMEDIATE

: RECURSE   \ 94
\ ������������: ��������� �� ����������.
\ ����������: ( -- )
\ �������� ��������� ���������� �������� ����������� � ������� �����������.
\ ������������� �������� ���������, ���� RECURSE ������������ ����� DOES>.
  ?COMP
  LAST-NON  DUP 0= 
  IF DROP  LATEST NAME>  THEN _COMPILE,
; IMMEDIATE
