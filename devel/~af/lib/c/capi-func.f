\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ NOTFOUND ��� �㭪権 � dll, �ᯮ��஢����� �� c-�ࠢ���� -
\ �⥪ ���� ��뢠�騩.
\ ������祭�� dll - USES_C "name.dll". ��� dll ����� ᮤ�ঠ�� ���� � ����
\ �����祭�� � ����窨.
\ �� �࠯���� ���������� � ᫮���� FORTH

REQUIRE ((	~af\lib\c\prefixfun.f
REQUIRE CAPI:	~af\lib\c\capi.f
REQUIRE USES	~af\lib\api-func.f

\ � �⮬ ᫮��� �࠭���� ᯨ᮪ dll, � ������ ����� �㭪��
VOCABULARY CAPI-FUNC-VOC

GET-CURRENT ALSO APISupport DEFINITIONS

: SCAPI ( n NameLibAddr addr����楤��� u -- )
  <# ROT ASCIIZ> HOLDS S"  " HOLDS HOLDS
  S" CAPI: " HOLDS S"  " HOLDS S>D #S #> EVALUATE
;

\ ���� �㭪樨, ��� ���ன ����� � PAD, � ������祭��� ���쪠�
: SEARCH-CFUNC ( -- NameLibAddr ProcAddr t | f )
  [ ALSO CAPI-FUNC-VOC CONTEXT @  PREVIOUS ] LITERAL (SEARCH-FUNC)
;

\ �믮������ ��������� �㭪樨. � ०��� �������樨 �㭪�� ��������
\ � ᯨ᮪ ��� ��᫥���饩 �������樨. � ०��� ������樨 - �믮������
: EXEC-CFUNC ( n NameLibAddr ProcAddr u -- )
  STATE @ IF
    NIP ,FUNC
  ELSE DROP NIP CAPI-CALL
  THEN
;

: (AddFuncNode2) ( node -- )
  NodeValue DUP >R
  @ ASCIIZ> FindWrap 0= IF
    GET-CURRENT FORTH-WORDLIST SET-CURRENT
    R@ 3 CELLS + @ DUP -1 = IF
      DROP R@ CELL+ @   R@ @ ASCIIZ>   SWINAPI
    ELSE
      R@ CELL+ @   R@ @ ASCIIZ>   SCAPI
    THEN
    SET-CURRENT
    R@ @ ASCIIZ> FindWrap DROP
  THEN
  R@ CELL+ CELL+ @ SWAP OVER CELL+ - SWAP !
  R@ @ FREE THROW
  R> FREE THROW
;
' (AddFuncNode2) TO AddFuncNode

SET-CURRENT

: USES_C ( "name.dll" -- ) \ ������祭�� dll � ᯨ�� ���᪠
  [ ALSO CAPI-FUNC-VOC CONTEXT @  PREVIOUS ] LITERAL (USES)
;

FALSE WARNING !
: NOTFOUND ( addr u -- )
  2DUP 2>R ['] NOTFOUND CATCH ?DUP
  IF
    API-FUNC @ IF
      PFSupport::curname IF
        2R@ COMPARE 0= IF
          NIP NIP  2R> PAD SWAP DUP >R MOVE
          0 PAD R@ + C!
          SEARCH-CFUNC IF ROT DROP PFSupport::count ROT ROT R> EXEC-CFUNC
          ELSE RDROP THROW
          THEN
        ELSE RDROP RDROP THROW
        THEN
      ELSE RDROP RDROP THROW
      THEN
    ELSE RDROP RDROP THROW
    THEN
  ELSE RDROP RDROP
  THEN
;

TRUE WARNING !

PREVIOUS
