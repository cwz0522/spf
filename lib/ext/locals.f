( 28.Mar.2000 Andrey Cherezov  Copyright [C] RU FIG

  ������������ ���� ��������� �������:
  Ruvim Pinka; Dmitry Yakimov; Oleg Shalyopa; Yuriy Zhilovets;
  Konstantin Tarasov; Michail Maximov.

  !! �������� ������ � SPF4.
)

( ������� ���������� ��-����� ���������� �����������.
  ����������� ��� ������������� LOCALS ��������� 94.

  ���������� ��������� ����������, ������� ������ ������
  �������� ����� � ������������ �������� ������ �������
  ����� ����������� � ������� ����� "{". ������ ����������� 
  ����� ������������ �����������, �������� �������� ������� �����
  { ������_������������������_������� \ ��.������.������� -- ��� ������ }
  ��������:

  { a b c d \ e f -- i j }

  ��� { a b c d \ e f[ EVALUATE_��������� ] -- i j }
  ��� ������ ��� ��� ���������� f[ ����� ������� �� ����� ��������� �������
  ������ ������ n ����. ������������� ���������� f[ ���� ����� ������ �����
  �������. \� ����� MPE\

  ��� { a b c d \ e [ 12 ] f -- i j }
  ��� ������ ��� ��� ���������� f ����� ������� �� ����� ��������� �������
  ������ ������ 12 ����. ������������� ���������� f ���� ����� ������ �����
  �������. 

  ����� "\ ��.������.�������" ����� �������������, ��������:

  { item1 item2 -- }

  ��� ���������� ��-���� ������������� �������� ����� �
  ����� ��������� ��� ���� ���������� � ������ ������ �����
  � ������������� ����������� ����� ��� ������ �� ����.

  ��������� � ����� ��������� ���������� - ��� � VALUE-����������
  �� �����. ���� ����� ����� ����������, �� ������������ "^ ���"
  ��� "AT ���".


  ������ \ ����� ������������ |
  ������ -> ����� ������������ TO

  �������:

  : TEST { a b c d \ e f -- } a . b . c .  b c + -> e  e .  f .  ^ a @ . ;
   Ok
  1 2 3 4 TEST
  1 2 3 5 0 1  Ok

  : TEST { a b -- } a . b . CR 5 0 DO I . a . b . CR LOOP ;
   Ok
  12 34 TEST
  12 34
  0 12 34
  1 12 34
  2 12 34
  3 12 34
  4 12 34
   Ok

  : TEST { a b } a . b . ;
   Ok
  1 2 TEST
  1 2  Ok

  : TEST { a b \ c } a . b . c . ;
   Ok
  1 2 TEST
  1 2 0  Ok

  : TEST { a b -- } a . b . ;
   Ok
  1 2 TEST
  1 2  Ok

  : TEST { a b \ c -- d } a . b . c . ;
   Ok
  1 2 TEST
  1 2 0  Ok

  : TEST { \ a b } a . b .  1 -> a  2 -> b  a . b . ;
   Ok
  TEST
  0 0 1 2  Ok

  ����� ��������� ���������� ���������� � ������������
  ��������� ������� ������ � ������ ���������� �����, �
  ����� ����� ���������� � ����� ����������.

  ������������ ����������� "{ ... }" ������ ������ ����������� �����
  ������ ���� ���.

  ���������� ���� ���������� ��������� � ������� ������� ����������
  ������ ��� �����:
  ������� "vocLocalsSupport" � "{"
  ��� ��������� ������ "��������" � �������, ������������ ��
  �� �������������.
)


MODULE: vocLocalsSupport

USER widLocals
USER uLocalsCnt
USER uLocalsUCnt
USER uPrevCurrent
USER uAddDepth

: (Local^) ( N -- ADDR )
  RP@ +
;
: LocalOffs ( n -- offs )
  uLocalsCnt @ SWAP - CELLS CELL+ uAddDepth @ +
;

BASE @ HEX
: CompileLocalsInit
  uPrevCurrent @ SET-CURRENT
  uLocalsCnt  @ uLocalsUCnt @ - ?DUP IF CELLS LIT, POSTPONE DRMOVE THEN
  uLocalsUCnt @ ?DUP
  IF 
     LIT, POSTPONE (RALLOT)
  THEN
  uLocalsCnt  @ ?DUP 
  IF CELLS RLIT, ['] (LocalsExit) RLIT, THEN
;

: CompileLocal@ ( n -- )
  ['] DUP MACRO,
  DUP LocalOffs  SHORT?
  OPT_INIT SetOP
  IF    8B C, 44 C, 24 C, LocalOffs C, \ mov eax, offset [esp]
  ELSE  8B C, 84 C, 24 C, LocalOffs  , \ mov eax, offset [esp]
  THEN
  OPT_CLOSE
;

\ : CompileLocal@ ( n -- )
\   LocalOffs LIT, POSTPONE RP+@
\ ;

: CompileLocalRec ( u -- )
  DUP LocalOffs 
  ['] DUP MACRO,
  SHORT?
  OPT_INIT SetOP
  IF    8D C, 44 C, 24 C, LocalOffs C, \ lea eax, offset [esp]
  ELSE  8D C, 84 C, 24 C, LocalOffs  , \ lea eax, offset [esp]
  THEN
  OPT_CLOSE
;

BASE !

: LocalsStartup
  TEMP-WORDLIST widLocals !
  GET-CURRENT uPrevCurrent !
  ALSO vocLocalsSupport
  ALSO widLocals @ CONTEXT ! DEFINITIONS
  uLocalsCnt 0!
  uLocalsUCnt 0!
  uAddDepth 0!
;
: LocalsCleanup
  PREVIOUS PREVIOUS
  widLocals @ FREE-WORDLIST
;

: ProcessLocRec ( "name" -- u )
  [CHAR] ] PARSE
  STATE 0!
  EVALUATE CELL 1- + CELL / \ ������ ������� 4
  -1 STATE !
  DUP uLocalsCnt +!
  uLocalsCnt @ 1-
;

: CreateLocArray
  [CHAR] [ SKIP
  ProcessLocRec
  CREATE ,
;

: LocalsRecDoes@ ( -- u )
  DOES> @ CompileLocalRec
;

: LocalsRecDoes@2 ( -- u )
  ProcessLocRec ,
  DOES> @ CompileLocalRec
;

: LocalsDoes@
  uLocalsCnt @ ,
  uLocalsCnt 1+!
  DOES> @ CompileLocal@
;

: ;; POSTPONE ; ; IMMEDIATE


: ^ 
  ' >BODY @ 
  CompileLocalRec
; IMMEDIATE


: -> ' >BODY @ LocalOffs LIT, POSTPONE RP+! ; IMMEDIATE

WARNING DUP @ SWAP 0!

: AT
  [COMPILE] ^
; IMMEDIATE

: TO ( "name" -- )
  >IN @ NextWord widLocals @ SEARCH-WORDLIST 1 =
  IF >BODY @ LocalOffs LIT, POSTPONE RP+! DROP
  ELSE >IN ! [COMPILE] TO
  THEN
; IMMEDIATE

WARNING !

: � POSTPONE -> ; IMMEDIATE

WARNING @ WARNING 0!
\ ===
\ ��������������� ��������������� ���� ��� ����������� ������������
\ ��������� ���������� ������  ����� DO LOOP  � ���������� �� ���������
\ ����������� ����� ���������  �������   >R   R>

: DO    POSTPONE DO     [  3 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: ?DO   POSTPONE ?DO    [  3 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: LOOP  POSTPONE LOOP   [ -3 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: +LOOP POSTPONE +LOOP  [ -3 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: >R    POSTPONE >R     [  1 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: R>    POSTPONE R>     [ -1 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: RDROP POSTPONE RDROP  [ -1 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: 2>R   POSTPONE 2>R    [  2 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE
: 2R>   POSTPONE 2R>    [ -2 CELLS ] LITERAL  uAddDepth +! ; IMMEDIATE

\ ===

\  uLocalsCnt  @ ?DUP 
\  IF CELLS RLIT, ['] (LocalsExit) RLIT, THEN

: ;  LocalsCleanup
     S" ;" EVAL-WORD
; IMMEDIATE

WARNING !

\ =====================================================================


EXPORT

: {
  LocalsStartup
  BEGIN
    BL SKIP PeekChar DUP [CHAR] \ <> 
                    OVER [CHAR] - <> AND
                    OVER [CHAR] } <> AND
                    SWAP [CHAR] ) <> AND
  WHILE
    CREATE LocalsDoes@ IMMEDIATE
  REPEAT

  PeekChar >IN 1+! DUP [CHAR] } <>
  IF
    DUP [CHAR] \ =
    SWAP [CHAR] | = OR
    IF
      BEGIN
        BL SKIP PeekChar DUP DUP [CHAR] - <> SWAP [CHAR] } <> AND
        SWAP [CHAR] ) <> AND
      WHILE
        PeekChar [CHAR] [ =
        IF CreateLocArray LocalsRecDoes@
        ELSE
             CREATE LATEST DUP C@ + C@
             [CHAR] [ =
             IF  
               LocalsRecDoes@2
             ELSE
               LocalsDoes@ 1 
             THEN
        THEN
        uLocalsUCnt +!
        IMMEDIATE
      REPEAT
    THEN
    [CHAR] } PARSE 2DROP
  ELSE DROP THEN
  CompileLocalsInit
;; IMMEDIATE

;MODULE
