( �������� �������� ������ � �������� WORDLIST.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999, ���� 2000
)

VARIABLE VOC-LIST \ ������ ��������

VARIABLE LAST \ ��������� �� ���� ����� ��������� 
              \ ���������������� ��������� ������
              \ � ������� �� LATEST, ������� ����
              \ ����� ���������� ����� � CURRENT

1 CONSTANT &IMMEDIATE \ ��������� ��� ��������� ������ IMMEDIATE
2 CONSTANT &VOC

HERE ' VOC-LIST EXECUTE !

0 ,                   \ ��� VOC-LIST
HERE 0 ,              \ ����� ����� ���������� �����
0 ,                   \ ����� ����� ����� �������
0 ,                   \ ������
0 ,                   \ �����
0 ,                   \ ���������� ���������� SEARCH-WORDLIST
( ������� �������, � �� �� WORDLIST, ����� ������=0 )

VALUE FORTH-WORDLIST  ( -- wid ) \ 94 SEARCH
\ ���������� wid - ������������� ������ ����, ����������� ��� ����������� 
\ �����, �������������� �����������. ���� ������ ���� ���������� ������ 
\ ���������� � ����� ���������� ������� ������.

: >BODY ( xt -- a-addr ) \ 94
\ a-addr - ����� ���� ������, ��������������� xt.
\ �������������� �������� ���������, ���� xt �� �� �����,
\ ������������� ����� CREATE.
(  1+ @ ���� � ������ 2.5 )
  5 +
;

: +WORD ( A1, A2 -> ) \ ���������� ��������� ������ � ������,
         \ �������� ������� �� ��������� A1, � ������, ���������
         \ ���������� A2. ��������� ������ ���� ����� � ����� �
         \ ���������� ������ �� ALLOT. � �������� ����� ��
         \ ������ A2 ���������� ����� ���� ����� ������, �
         \ ������� ���������� ����� � ���� ������.
         \ ������: C" SP-FORTH" CONTEXT @ +WORD
  HERE LAST !
  HERE ROT ", SWAP DUP @ , !
;

: +SWORD ( addr u wid -> ) \ ���������� ��������� ������ � ������,
         \ �������� ������� addr u, � ������, ��������� wid.
         \ ��������� ������ ���� ����� � ����� �
         \ ���������� ������ �� ALLOT.
  HERE LAST !
  HERE 2SWAP S", SWAP DUP @ , !
;

100000 VALUE WL_SIZE  \ ������ ������, ���������� ��� ���������� �������

LOAD-VERSION 1+ DUP VALUE VERSION  \ ������ (����� �����, ������) SPF
SAVE-VERSION

CREATE BUILD-DATE
NOWADAYS ,"

: WORDLIST ( -- wid ) \ 94 SEARCH
\ ������� ����� ������ ������ ����, ��������� ��� ������������� wid.
\ ����� ������ ���� ����� ���� ��������� �� �������������� �������������� 
\ ������� ���� ��� ����� ����������� �������������� � ������������ ������.
\ ������� ������ ��������� �������� ��� ������� 8 ����� ������� ���� � 
\ ���������� � ��������� � �������.

  HERE VOC-LIST @ , VOC-LIST !
  HERE 0 , \ ����� ����� ��������� �� ��� ���������� ����� ������
       0 , \ ����� ����� ��������� �� ��� ������ ��� ����������
       0 , \ wid �������-������
       0 , \ ����� ������� = wid �������, ������������� �������� �������
;
\ ��� ��������� �������� �������������� ����������:
\       0 , \ ����� �������� ���������� ������� (����� ��������)
\       0 , \ ������ ����, ������� ������������� ��������� �������
\       0 , \ DP ���������� ������� (������� ������)

: TEMP-WORDLIST ( -- wid )
\ ������� ��������� ������� (� ����������� ������)

  WL_SIZE ALLOCATE THROW DUP >R WL_SIZE ERASE
  -1      R@ ! \ �� ������������ � VOC-LIST, ������ ������� ����������� �������
  R@      R@ 5 CELLS + !
  VERSION R@ 6 CELLS + !
  R@ 8 CELLS + DUP CELL- !
  R> CELL+
;
: FREE-WORDLIST ( wid -- )
  CELL- FREE THROW
;

: CLASS! ( cls wid -- ) CELL+ CELL+ CELL+ ! ;
: CLASS@ ( wid -- cls ) CELL+ CELL+ CELL+ @ ;
: PAR!   ( Pwid wid -- ) CELL+ CELL+ ! ;
: PAR@   ( wid -- Pwid ) CELL+ CELL+ @ ;

\ -5 -- cfa
\ -1 -- flags
\  0 -- NFA
\  1 -- name
\  n -- LFA

CODE NAME> ( NFA -> CFA )
     MOV EAX, -5 [EAX]
     RET
END-CODE

CODE NAME>C ( NFA -> 'CFA )
     LEA EAX, -5 [EAX]
     RET
END-CODE

CODE NAME>F ( NFA -> FFA )
     LEA EAX, -1 [EAX]
     RET
END-CODE

CODE NAME>L ( NFA -> LFA )
     MOVZX EBX, BYTE [EAX]
     LEA EAX, [EBX] [EAX]
     LEA EAX, 1 [EAX]
     RET
END-CODE

CODE CDR ( NFA1 -> NFA2 )
     OR EAX, EAX
     JZ SHORT @@1
      MOVZX EBX, BYTE [EAX]
      MOV EAX, 1 [EBX] [EAX]
@@1: RET
END-CODE

: ID. ( NFA[E] -> )
  COUNT TYPE
;

: ?IMMEDIATE ( NFA -> F )
  NAME>F C@ &IMMEDIATE AND
;

: ?VOC ( NFA -> F )
  NAME>F C@ &VOC AND
;

: IMMEDIATE ( -- ) \ 94
\ ������� ��������� ����������� ������ ������������ ����������.
\ �������������� �������� ���������, ���� ��������� �����������
\ �� ����� �����.
  LAST @ NAME>F DUP C@ &IMMEDIATE OR SWAP C!
;

: VOC ( -- )
\ �������� ��������� ������������ ����� ��������� "�������".
  LAST @ NAME>F DUP C@ &VOC OR SWAP C!
;

\ ==============================================
\ ������� - ����� ����� �� ������ � ��� ����

USER WBW-NFA
USER WBW-OFFS

: WordByAddrWl ( addr wid -- nfa offs )
  -1 1 RSHIFT WBW-OFFS !
  WBW-NFA 0!
  @
  BEGIN
    DUP
  WHILE
    2DUP - DUP 0 > 
        IF WBW-OFFS @ OVER > 
           IF WBW-OFFS ! DUP WBW-NFA !
           ELSE DROP THEN
        ELSE DROP THEN
    CDR
  REPEAT 2DROP
  WBW-NFA @ WBW-OFFS @
;

USER WB-NFA
USER WB-OFFS

: WordByAddr  ( addr -- c-addr u )
  \ ����� �����, ���� �������� ����������� ������ �����
  (DP) @ OVER >
  IF 
     -1 1 RSHIFT WB-OFFS !
     WB-NFA 0!
     VOC-LIST @
     BEGIN
       DUP
     WHILE
       2DUP ( addr voc addr voc )
       CELL+ WordByAddrWl
             WB-OFFS @ OVER >
             IF WB-OFFS ! WB-NFA !
             ELSE 2DROP THEN
       @
     REPEAT 2DROP
     WB-NFA @ ?DUP IF COUNT ELSE S" <not found>" THEN
  ELSE DROP S" <not in the image>" THEN
;