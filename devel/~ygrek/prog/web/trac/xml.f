\
\ ����� XML ����� ������������
\
\ �� ������ ���� ��������� ����������� ���, ��� ������ - �����������.

REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE /TEST ~profit/lib/testing.f

0 VALUE indent#

\ � ���������
: tag ( a u -- )
   2DUP
   PRO
   CR indent# SPACES " <{s}>" STYPE
   indent# 1+ TO indent#
   BACK indent# 1- TO indent# " </{s}>" STYPE TRACKING
   CONT ;

\ plain - no indent
: ptag
   2DUP
   PRO
   " <{s}>" STYPE
   BACK " </{s}>" STYPE TRACKING
   CONT ;


/TEST \ Example

0 VALUE counter

: inner=> PRO 
   3 0 DO
   counter " inner{n}" DUP STR@ CONT STRFREE
   counter 1+ TO counter 
   LOOP
;

: sub=> PRO S" sub1" CONT S" sub2" CONT ;

: start
   S" start" tag
     sub=> tag inner=> tag " {counter DUP *}" STYPE ;

start

\EOF

������ S" a" tag S" b" tag S" c" tag ����������� ��������� ���� 
 <a><b><c></c></b></a>
����� �������� ���� �� ����� ������ �� ���� ���������� � ������� *> <*> <* ��� PRO CONT 
 S" a" tag PRO S" b" tag CONT S" c" CONT
���
 S" a" tag *> S" b" tag <*> S" c" <*
����
 <a><b></b><c></c></a> 

���� � ���������� (����?) �� ������� ��� ������� �����������.
