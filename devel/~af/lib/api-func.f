\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ Work in spf3, spf4
\ NOTFOUND ��� �㭪権 � dll
\ �������� �� ����室����� ������ �ᯮ��㥬� API-�㭪樨.
\ ������祭�� dll - USES "name.dll". ��� dll ����� ᮤ�ঠ�� ���� � ����
\ �����祭�� � ����窨. �� �믮������ ᫮�� name.dll � �⥪ ��������
\ ���� 0-��ப� � ������ ���.
\ ���冷� ���᪠: ᭠砫� ����� �࠯��� �㭪樨 � �ਣ����쭮� ����ᠭ��.
\ �᫨ �� ������, � �饬 �࠯��� � ���������� ���䨪ᮬ - ᭠砫� � A, ��⮬
\ � W. �᫨ �࠯��� ��� - �饬 � ������祭��� dll-��. ���砫� � �ਣ����쭮�
\ ����ᠭ��, ��⥬ � ���䨪ᮬ - �᫨ ANSIAPI ON � � A, ���� � W.
\ �� �࠯���� ���������� � ᫮���� FORTH

REQUIRE [DEFINED]  lib\include\tools.f
REQUIRE AddNode    ~ac\lib\list\str_list.f
REQUIRE ON         lib\ext\onoff.f

[UNDEFINED] HOLDS [IF]
  : HOLDS ( addr u -- ) \ from eserv src
    SWAP OVER + SWAP 0 ?DO DUP I - 1- C@ HOLD LOOP DROP
  ;
[THEN]
[UNDEFINED] SEARCH-IN-LIST [IF]
  : SEARCH-IN-LIST ( a u list -- FALSE | addr TRUE )
    ROT ROT 2>R
    BEGIN
      @ DUP
    WHILE
      DUP CELL+ ASCIIZ> 2R@ COMPARE
      0= IF
        RDROP RDROP
        CELL+ TRUE EXIT
      THEN
    REPEAT DROP RDROP RDROP
    FALSE
  ;
[THEN]

\ � �⮬ ᯨ᪥ �࠭���� ����� dll, � ������ ����� �㭪��
VARIABLE DLL-LIST
VARIABLE ANSIAPI
ANSIAPI ON
\ ���� �������� 横� ������樨, ���⮬� �㦭� ����������� �⪫���� ��
VARIABLE API-FUNC
API-FUNC ON

: USES ( "name.dll" -- ) \ ������祭�� dll � ᯨ�� ���᪠
  SkipDelimiters GetChar IF
    [CHAR] " = IF [CHAR] " DUP SKIP PARSE ELSE NextWord THEN
  ELSE DROP NextWord THEN
  2DUP
  DLL-LIST SEARCH-IN-LIST 0= IF
    2DUP + 0 SWAP C!
    OVER LoadLibraryA 0= IF -2009 THROW THEN
    GET-CURRENT >R FORTH-WORDLIST SET-CURRENT
    HERE DLL-LIST @ , DLL-LIST ! ( ��� )
    1+ HERE SWAP DUP ALLOT MOVE
    R> SET-CURRENT
  ELSE
    DROP 2DROP
  THEN
;

VOCABULARY APISupport
GET-CURRENT ALSO APISupport DEFINITIONS

\ � ०��� �������樨 �ᯮ������ �⫮������ ��������� �࠯��஢ �����
\ �맢����� ���-�㭪権. ���᮪ �㭪権, ����� ���� ᪮�����஢���,
\ �࠭���� � �������᪮� ᯨ᪥ ListFunc
USER ListFunc

: FreeListFunc ListFunc FreeList ;

: SWINAPI ( NameLibAddr addr����楤��� u -- )
  <# ROT ASCIIZ> HOLDS S"  " HOLDS HOLDS S" WINAPI: " HOLDS 0 0 #> EVALUATE
;

\ ���� �㭪樨, ��� ���ன ����� � PAD, � ������祭��� ���쪠�
: SEARCH-FUNC ( -- NameLibAddr ProcAddr t | f )
  DLL-LIST
  BEGIN
    @ ?DUP
  WHILE
    DUP CELL+ LoadLibraryA DUP 0= IF -2009 THROW THEN
    PAD SWAP GetProcAddress
    ?DUP IF SWAP CELL+ SWAP TRUE EXIT THEN
  REPEAT
  FALSE
;

\ �믮������ ��������� �㭪樨. � ०��� �������樨 �㭪�� ��������
\ � ᯨ᮪ ��� ��᫥���饩 �������樨. � ०��� ������樨 - �믮������
: EXEC-FUNC ( NameLibAddr ProcAddr u -- )
  STATE @ IF
    NIP
    0 [ VERSION 400000 < [IF] ] COMPILE, [ [ELSE] ] _COMPILE, [ [THEN] ]
    3 CELLS ALLOCATE THROW >R
    PAD SWAP HEAP-COPY R@ ! \ 1-�祩�� - ��뫪� �� ��� ��楤���
    R@ CELL+ !               \ 2-�祩�� - ��뫪� �� ��� ������⥪�
    HERE 4 - R@ CELL+ CELL+ ! \ 3-�祩�� - ���� ��� ���४樨
    R> ListFunc AddNode
  ELSE DROP NIP API-CALL
  THEN
;

: FindWrap ( a u -- FALSE | xt TRUE )
  2>R
  WINAPLINK
  BEGIN
    @ DUP
  WHILE
    DUP
    [ VERSION 400007 > [IF] ] 2 CELLS - [ [ELSE] ] CELL- [ [THEN] ]
    @ ASCIIZ> 2R@ COMPARE
    0= IF
      RDROP RDROP
      WordByAddr
      DROP 1- NAME> TRUE EXIT
    THEN
  REPEAT DROP RDROP RDROP
  FALSE
;

\ ��������� �㭪樨 �� ᯨ᪠ � ���४�� ᫮�� � ���஬ ��� �ᯮ������
: AddFuncNode ( node -- )
  NodeValue DUP >R
  @ ASCIIZ> FindWrap 0= IF
    GET-CURRENT FORTH-WORDLIST SET-CURRENT
    R@ CELL+ @   R@ @ ASCIIZ>   SWINAPI
    SET-CURRENT
    R@ @ ASCIIZ> FindWrap DROP
  THEN
  R@ CELL+ CELL+ @ SWAP OVER CELL+ - SWAP !
  R@ @ FREE THROW
  R> FREE THROW
;

SET-CURRENT

FALSE WARNING !
: NOTFOUND ( addr u -- )
  2DUP >R >R ['] NOTFOUND CATCH ?DUP
  IF
    API-FUNC @ IF
      NIP NIP  R> PAD R@ MOVE
      [CHAR] A  PAD R@ + C!
      PAD R@ 1+ FindWrap IF
        NIP RDROP STATE @ IF COMPILE, ELSE EXECUTE THEN
      ELSE
        [CHAR] W  PAD R@ + C!
        PAD R@ 1+ FindWrap IF
          NIP RDROP STATE @ IF COMPILE, ELSE EXECUTE THEN
        ELSE
          0 PAD R@ + C!
          SEARCH-FUNC IF ROT DROP R> EXEC-FUNC
          ELSE
            ANSIAPI IF [CHAR] A ELSE [CHAR] W THEN  PAD R@ + C!
            R> 1+ >R
            0 PAD R@ + C!
            SEARCH-FUNC IF ROT DROP R> EXEC-FUNC ELSE RDROP THROW THEN
          THEN
        THEN
      THEN
    ELSE RDROP RDROP THROW
    THEN
  ELSE RDROP RDROP
  THEN
;

: ;
  POSTPONE ;
  ['] AddFuncNode ListFunc DoList
  FreeListFunc
; IMMEDIATE

TRUE WARNING !

PREVIOUS
