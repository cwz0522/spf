\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ ���� �।�����祭� ��� ����襭�� �⠡��쭮�� ���-⥪�⮢.
\ ���� ����������� ����� �맮�� ᫮� � ����� ����來�� ���� -
\ (( func arg1 , arg2 , arg3 )
\ �ᮡ���� ������� �� �맮�� API-�㭪権.

VOCABULARY PFSupport
GET-CURRENT ALSO PFSupport DEFINITIONS

USER curfunc

: , ; IMMEDIATE

: ) ( -- )
  curfunc @ DUP @ curfunc !
  CELL+ COUNT EVALUATE
  PREVIOUS
; IMMEDIATE

SET-CURRENT

: (( ( "func" -- )
  NextWord
  DUP CELL+ 1+ ALLOCATE THROW
  curfunc @ OVER ! DUP curfunc !
  CELL+ 2DUP C!
  1+ SWAP MOVE
  ALSO PFSupport
; IMMEDIATE
PREVIOUS

\EOF
: foo1  . . ;
: foo2 DUP 1+ ;
: test11 (( foo1 1 , 2 ) CR ;
: test21 1 2 foo1 CR ;
: test12 (( foo1 (( foo2 5 ) ) CR ;
: test22 5 foo2 foo1 CR ;
test11 test21
test12 test22
