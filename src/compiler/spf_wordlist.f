\ $Id$

( �������� �������� ������ � �������� WORDLIST.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999, ���� 2000
)

USER LAST     \ ��������� �� ���� ����� ��������� 
              \ ���������������� ��������� ������
              \ � ������� �� LATEST, ������� ����
              \ ����� ���������� ����� � CURRENT

1 CONSTANT &IMMEDIATE \ ��������� ��� ��������� ������ IMMEDIATE
2 CONSTANT &VOC

WORDLIST VALUE FORTH-WORDLIST  ( -- wid ) \ 94 SEARCH
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

: +SWORD ( addr u wid -> ) \ ���������� ��������� ������ � ������,
         \ �������� ������� addr u, � ������, ��������� wid.
         \ ��������� ������ ���� ����� � ����� �
         \ ���������� ������ �� ALLOT.
  HERE LAST !
  HERE 2SWAP S", SWAP DUP @ , !
;

: +WORD ( A1, A2 -> ) \ ���������� ��������� ������ � ������,
         \ �������� ������� �� ��������� A1, � ������, ���������
         \ ���������� A2. ��������� ������ ���� ����� � ����� �
         \ ���������� ������ �� ALLOT. � �������� ����� ��
         \ ������ A2 ���������� ����� ���� ����� ������, �
         \ ������� ���������� ����� � ���� ������.
         \ ������: C" SP-FORTH" CONTEXT @ +WORD
  SWAP COUNT ROT +SWORD
;

100000 VALUE WL_SIZE  \ ������ ������, ���������� ��� ���������� �������

LOAD-BUILD-NUMBER 1+ 
DUP SPF-KERNEL-VERSION 1000 * + VALUE VERSION  \ ������ � ����� ����� SPF � ���� 4XXYYY
    SAVE-BUILD-NUMBER

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

: WL_NEAR_NFA ( addr wid - addr nfa | addr 0 )
   CELL+ @
   BEGIN 2DUP U<
   WHILE CDR
   REPEAT
;

: NEAR_NFA ( addr - nfa addr | 0 addr )
   0 SWAP 
   VOC-LIST
   BEGIN  @ DUP
   WHILE  DUP >R  WL_NEAR_NFA SWAP >R UMAX R>  R>
   REPEAT DROP
;

: WordByAddr  ( addr -- c-addr u )
\ ����� �����, ���� �������� ����������� ������ �����
   DUP         (DP) @ U> IF DROP S" <not in the image>" EXIT THEN
   NEAR_NFA DROP  DUP 0= IF DROP S" <not found>"        EXIT THEN
   COUNT
;
