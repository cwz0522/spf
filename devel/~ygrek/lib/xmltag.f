\
\ ����� XML ����� ������������
\
\ �� ������ ���� ��������� ����������� ���, ��� ������ - �����������.

REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE /TEST ~profit/lib/testing.f

USER-VALUE xmltag.indent#

\ � ���������
: tag
   PRO
   BACK xmltag.indent# 1- TO xmltag.indent# " </{s}>" STYPE TRACKING
   2RESTB
   CR xmltag.indent# SPACES " <{s}>" STYPE
   xmltag.indent# 1+ TO xmltag.indent#
   CONT ;


\ plain - no indent
: ptag
   PRO
   BACK " </{s}>" STYPE TRACKING
   2RESTB
   " <{s}>" STYPE
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

���� � ���������� �� ������� ��� ������� �����������.
