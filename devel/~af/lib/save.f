\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ Work in spf3, spf4

\ save v2
\ ���࠭�� � exe � ����ᠬ� �� fres 䠩��
( addr_exe u_exe addr_fres u_fres -- )
\ �᫨ ������ �� �㦭�, � u_fres = 0
\ ���� save ᮧ���� �� �᭮�� resources.f �. ������ (~yz\lib\resources.f )
\ � ���� SaveWithRes

DECIMAL

GET-CURRENT
TEMP-WORDLIST DUP ALSO CONTEXT ! DEFINITIONS
REQUIRE [DEFINED]  lib\include\tools.f

0x080 CONSTANT START-PE-HEADER
0x400 CONSTANT SIZE-HEADER
0x2000 CONSTANT BASEOFCODE
0 VALUE END-CODE-SEG
0 VALUE END-RES-SEG
TRUE VALUE ?Res
0 VALUE START-RES-TABLE

: relocate ( adr xt -- ) 
\ �ਬ����� �� �ᥬ ������⠬ ��⠫��� adr ᫮�� xt
  >R
  DUP 12 + W@ ( ���������� �����) OVER 14 + W@ ( ������������ �����) +
  SWAP 16 + SWAP
  BEGIN ( adr #) DUP WHILE
    OVER CELL+ @ 0x7FFFFFFF AND END-CODE-SEG + R@ EXECUTE
  SWAP 2 CELLS + ( ����� �����) SWAP 1-
  REPEAT 2DROP
  RDROP
;

: relocate3 ( leaf --) IMAGE-SIZE BASEOFCODE + SWAP +! ;
: relocate2 ( dir -- ) ['] relocate3 relocate ;
: relocate1 ( dir -- ) ['] relocate2 relocate ;

: ADD-RES ( addr u -- )
  DUP IF
    R/O OPEN-FILE THROW >R
    END-CODE-SEG R@ FILE-SIZE 2DROP R@ READ-FILE THROW ALLOT
    END-CODE-SEG ['] relocate1 relocate \ �������� �� �ᥬ ���ᠬ ����ᮢ
     \ IMAGE-SIZE BASEOFCODE +
    R> CLOSE-FILE DROP
  ELSE
    2DROP
  THEN
;

: SAVE ( offset c-addr u -- )
  ( ��࠭���� ��ࠡ�⠭��� ���-��⥬� � EXE-䠩�� �ଠ� PE - Win32 )
  R/W CREATE-FILE THROW >R
  ModuleName R/O OPEN-FILE-SHARED THROW >R
  HERE SIZE-HEADER R@ READ-FILE THROW SIZE-HEADER < THROW
  R> CLOSE-FILE THROW

  \ �᫨ ����ᮢ ��� (u_coff = 0), � END-CODE-SEG = END-RES-SEG
  END-CODE-SEG END-RES-SEG = IF FALSE ELSE TRUE THEN TO ?Res

  ?Res IF 3 ELSE 2 THEN HERE START-PE-HEADER 0x06  + + W! ( Num of Objects)
  ?GUI IF 2 ELSE 3 THEN HERE START-PE-HEADER 0x5C  + + W!
  BASEOFCODE            HERE START-PE-HEADER 0x28  + +  ! ( EntryPointRVA )
  IMAGE-BASE            HERE START-PE-HEADER 0x34  + +  ! ( ImageBase )
  IMAGE-SIZE BASEOFCODE + END-RES-SEG END-CODE-SEG - 0xFFF + 0x1000 / 0x1000 * +
                        HERE START-PE-HEADER 0x50  + +  ! ( ImageSize )
  ?Res IF IMAGE-SIZE BASEOFCODE + ELSE 0 THEN
                        HERE START-PE-HEADER 0x88  + + !
  ?Res IF END-RES-SEG END-CODE-SEG - ELSE 0 THEN
                        HERE START-PE-HEADER 0x8C  + + !

  IMAGE-SIZE            HERE START-PE-HEADER 0x128 + + ! ( VirtualSize code)
  END-CODE-SEG IMAGE-BEGIN -
                        HERE START-PE-HEADER 0x130 + + ! ( PhisicalSize code)

  HERE 0x1C8 + TO START-RES-TABLE
  START-RES-TABLE 0x38 ERASE
  ?Res IF
    S" .rsrc"             START-RES-TABLE SWAP CMOVE
    END-RES-SEG END-CODE-SEG - 0xFFF + 0x1000 / 0x1000 *
                          START-RES-TABLE 0x08 + !
    IMAGE-SIZE BASEOFCODE +
                          START-RES-TABLE 0x0C + !
    END-RES-SEG END-CODE-SEG -
                          START-RES-TABLE 0x10 + !
    END-CODE-SEG IMAGE-BEGIN - SIZE-HEADER +
                          START-RES-TABLE 0x14 + !
                          START-RES-TABLE 0x18 + 0xC ERASE
    0x40 0x40000000 OR    START-RES-TABLE 0x24 + !
  THEN

  [ VERSION 400000 < [IF] ] 
    AOLL @ @ AOGPA @ @ ROT
    IMAGE-BASE 0x1034 + AOLL @ !
    IMAGE-BASE 0x1038 + AOGPA @ !
    HERE SIZE-HEADER R@ WRITE-FILE THROW ( ��������� � ⠡��� ������ )
    ERASED-CNT 0!
    IMAGE-BEGIN HERE OVER -   ROT ALLOT   R@ WRITE-FILE THROW
    ERASED-CNT 1+!
    AOGPA @ ! AOLL @ !
  [ [ELSE] VERSION 400008 < [IF] ] 
    HERE SIZE-HEADER R@ WRITE-FILE THROW
    ERASED-CNT 0!
    IMAGE-BEGIN HERE OVER -   ROT ALLOT SetOP   R@ WRITE-FILE THROW
    ERASED-CNT 1+!
  [ [ELSE] ] 
    HERE SIZE-HEADER R@ WRITE-FILE THROW
    IMAGE-BEGIN HERE OVER -   ROT ALLOT   R@ WRITE-FILE THROW
  [ [THEN] [THEN] ] 
  R> CLOSE-FILE THROW
;

SWAP SET-CURRENT

HERE
ALIGN-BYTES @ 512 ALIGN-BYTES ! ALIGN ALIGN-BYTES !
HERE TO END-CODE-SEG

2SWAP ADD-RES

ALIGN-BYTES @ 512 ALIGN-BYTES ! ALIGN ALIGN-BYTES !
HERE TO END-RES-SEG

HERE -

2SWAP SAVE
PREVIOUS
FREE-WORDLIST
