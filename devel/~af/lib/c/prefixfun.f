\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ ���� �।�����祭� ��� ����襭�� �⠡��쭮�� ���-⥪�⮢.
\ ���� ����������� ����� �맮�� ᫮� � ����� ����來�� ���� -
\ (( func arg1 , arg2 , arg3 )
\ (( foo ()
\ �ᮡ���� ������� �� �맮�� API-�㭪権.
\ ����� ���஥�� ���稪 ��㬥�⮢.

VOCABULARY PFSupport
GET-CURRENT ALSO PFSupport DEFINITIONS

USER curfunc

\ �����頥� ��� ⥪�饣� ᫮��, �᫨ ����
: curname ( -- false | addr u true )
  curfunc @ DUP IF 2 CELLS + COUNT TRUE THEN
;

\ �����頥� �᫮ ��㬥�⮢
: count ( -- -1 | n )
  curfunc @ DUP IF CELL+ @ ELSE DROP -1 THEN
;

\ 㢥��稢��� ���稪 ��㬥�⮢ �� 1
: , ( -- )
  curfunc @ CELL+ 1+!
; IMMEDIATE

\ �믮���� ᫮��, �᢮������� ������
: ) ( -- )
  POSTPONE ,
  curfunc @
  DUP >R 2 CELLS + COUNT EVALUATE
  R> DUP @ curfunc !
  FREE THROW
  PREVIOUS
; IMMEDIATE

\ �⮡� �� ����� DROP ��᫥ �맮�� ������ �㭪樨
: )) ( -- )
  POSTPONE )
  STATE @ IF POSTPONE DROP ELSE DROP THEN
; IMMEDIATE

\ ��� ᫮� ��� ��㬥�⮢
: () ( -- )
  -1 curfunc @ CELL+ ! POSTPONE )
; IMMEDIATE

: ()) ( -- )
  POSTPONE ()
  STATE @ IF POSTPONE DROP ELSE DROP THEN
; IMMEDIATE

SET-CURRENT

\ �⪫��뢠�� �믮������ ᫮�� �� ���⨦���� ���� ᯨ᪠ ��㬥�⮢
: (( ( "func" -- )
  NextWord
  DUP 9 + ALLOCATE THROW
  curfunc @ OVER ! DUP curfunc !
  CELL+ DUP 0!
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
: test12 (( foo1 (( foo2 5 ) , ) CR ;
: test22 5 foo2 foo1 CR ;
test11 test21
test12 test22
23 (( DUP () . .
