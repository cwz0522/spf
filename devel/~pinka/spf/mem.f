\ 03.Oct.2003 Ruv
\ 02.Aug.2004 ������� ��� � ����������������� � mem2.f, 
\             ��� ������� ������� ��� �������������� ������ ��� HEAP-ID
\
\ $Id$


REQUIRE [DEFINED] lib/include/tools.f

: HEAP-ID! ( heap -- )
\ ���������� ���, � ������� ����� �������� ALLOCATE/FREE
  THREAD-HEAP !
;
: HEAP-ID ( -- heap )
\ ���� ������������� ����� ��� ��� ALLOCATE/FREE
  THREAD-HEAP @
;

\ ===

[DEFINED] GetProcessHeap [IF]

: HEAP-GLOBAL ( -- )
  GetProcessHeap HEAP-ID!
;

[THEN]
