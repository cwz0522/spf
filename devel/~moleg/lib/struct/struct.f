\ 05-06-2004 ~mOleg  ��������, ��, �㭪樨

\ ���������������������������������������������������������������������������

\ ������� �� ������ ��� ��� ����
: ?BIT  ( N --> mask ) 1  SWAP LSHIFT ;

\ ������� �� ������ ��� ��� �������� ����
: N?BIT ( N --> mask ) ?BIT INVERT ;

16 CONSTANT #VOCS

\ ���������������������������������������������������������������������������

\ ����뢠�� �� ���㦭�� � ᫮����-ᢠ��� HIDDEN
MODULE: HIDDEN

   HERE RET, HERE SWAP - CONSTANT ret#

   \ ���� �������騩 EXIT �� ��।������
   : remove-ret 0 ret# - ALLOT ;

   \ ��६����� �࠭�� �।��饥 STATE
   0 VALUE prev-state

   \ �ᯮ������ � ���� ᡮ� ��⮢�� ��᪨
   \ �᫨ � ०��� �ᯮ������, � ��᪠ ���� ��⠢����� �� �⥪�
   \ � ०��� �������樨 ��࠭���� � ��।������ � ���� 32-��� ���ࠫ�.
   : (verb) ( mask --> ? )
            prev-state DUP STATE !
            IF ] LIT,
               0 TO prev-state
             ELSE
            THEN PREVIOUS ;

\ ���������������������������������������������������������������������������
   \ �஬����筮� ���� ��� �࠭���� ����� ᫮��
   CREATE RealName 255 ALLOT

   \ ��࠭��� ��� ᫮�� �� �६����� �࠭����
   : save ( Asc # --> ) RealName SWAP 2DUP + 0! CMOVE ;

   \ �ᯮ������ � F; � ��।���� ��������� ᫮��, ᮡ࠭���� �� F:
   : Using STATE @ IF COMPILE, ELSE EXECUTE THEN PREVIOUS ;

   \ ��࠭��� ���, ᮧ���� ����ﭭ�� ��।������
   : (F:) ( ASC # --> ) save :NONAME ;

\ ���������������������������������������������������������������������������

   \ ᮧ���� �⥪ ��� ��࠭���� ⥪�饣� ᫮����
   CREATE (CURR)  #VOCS ALLOT              (CURR) 0!

   \ ᤥ���� 㪠����� ᫮���� ⥪�騬, ���� ��࠭��� �� �⥪� (CURR)
   : this ( wid --> )
          GET-CURRENT
          (CURR) DUP 1+!
                 DUP @ CELLS + !
          SET-CURRENT ;

   \ ᤥ���� ⥪�騬 ᫮��६, ᫮���� � ���設� (CURR), � ���� �।��騩
   \ ⥪�騩 ���㫨 �� ����. �⥪ (CURR) �� ��८����蠥���, ���孥�
   \ ���祭�� ����� �������. ���॥ �ᥣ� �� �㤥� FORTH.
   : last ( --> )
          (CURR) DUP @ CELLS + @
                     SET-CURRENT
          (CURR) 1 OVER @ 1- MAX SWAP ! ;

\ ���������������������������������������������������������������������������

   \ �� ��६����� ��।���� ����������� � ��� ��������
   VARIABLE chain   chain 0!

   \ ��।����, ������ �� ᫮����
   : ?chain ( --> flag ) chain DUP @ SWAP 0! ;

   \ ������� wid ��᫥����� ��।�������� ᫮����
   : last-voc  ( --> wid ) VOC-LIST @ CELL+ ;

   \ ᤥ���� 㪠����� ᫮���� ���⥪���
   : with      ( wid --> ) ALSO CONTEXT ! ;

   \ ᤥ���� ��᫥���� ��।������ ᫮���� ⥪�騬
   : enter     ( -- ) last-voc DUP with this ;

   \ ��� � �।��騩 ⥪�騩 ᫮����
   : leave     ( -- ) PREVIOUS last ;

   \ ᮧ���� ᫮����, ���� � ����, ᤥ���� ⥪�騬
   : container ( --> ) VOCABULARY enter ;

   \ ��।����� ࠧ��� �������� � ��⮬ ⮣�, �� ��� ����� ��� ����
   \ ��� ��稭����� � ����⥫쭮�� ���������
   : ?Size ( disp disp --> size ) 2DUP MAX -ROT MIN - ;

\ ���������������������������������������������������������������������������

  \ ��� �� ���� � ������ ᫮���� ��⥬�
  ALSO FORTH DEFINITIONS

   \ ᮧ���� ᫮��, ���뢠�饥 ��।������.
   \ ⥪�� �� ������ ������ � ����ﭭ�� ��।������, ��
   \ ���஥ �㤥� ��뫠���� ᫮�� � ������ name.
   : F: ( | name --> ) NextWord (F:) ;

   \ ����뢠�� ��।������, ���⮥ �� F:
   \ ᮧ���� ᫮����� ����� � ������ name, 㪠����� ��᫥ F:
   \ �������� �������� � ᫮��� �� ��������� ᫮����� �
   \ ��⮬���᪨� ��室�� �� ��������� ᫮��३.
   : ;F ( addr --> )
        [COMPILE] ;
        RealName ASCIIZ> SHEADER IMMEDIATE
        LIT, POSTPONE Using RET, ; IMMEDIATE

   \ ᮮ�頥� � �����᪮� ���������� � ��� ��������
   \ �᫨ �� �ᯮ�짮���� �� ᫮��, � �ਤ���� ��᫥������ ���⥪�� �
   \  ���४�஢��� ����室��� ������⢮� PREVIOUS
   : Sub ( --> ) -1 chain ! ;

   \ ᮧ���� ᫮���� � ������ name, ᤥ���� ��� ���⥪��� � ⥪�騬
   : Unit: ( | name --> )
           container ?chain ,
           IMMEDIATE
           DOES> DUP CELL+ @ IF ELSE ALSO THEN
                     @ CONTEXT ! ;

   \ ��� �� ⥪�饣� �, ����⠭����� ���ﭨ� CONTEXT, CURRENT
   : EndUnit ( --> ) leave ;

\ ���������������������������������������������������������������������������

   \ ᮧ���� ��������� ��������
   : Struct: ( disp | name --> disp disp )
             DUP
             container ?chain , \ �����������
             IMMEDIATE
             DOES> DUP CELL+ @ IF ELSE ALSO THEN
                   @ CONTEXT ! ;

   \ ᮧ����� ����⠭��
   : const  ( n --> ) F: SWAP LIT, [COMPILE] ;F ;

   \ �����頥� �� ⮫쪮 ᬥ饭�� �⭮�⥫쭮 ��砫� �����,
   \ �� � ࠧ��� �⮩ �����
   : field  ( disp # --> base )
            2DUP + >R
            ( disp --> base # )
            F: -ROT SWAP LIT, POSTPONE + LIT, [COMPILE] ;F
            R> ;

   \ ��� ��।������ ���� �ந����쭮� ������
   : record ( disp # --> end )
            OVER +
            SWAP F: SWAP LIT, POSTPONE + [COMPILE] ;F ;

   \ ��� ��।������ ����� 䨪�஢����� �����
   : Zero[] 0 record ;  \ ��� ��।������ union-�� ⠪ �㤥� ���
   : Byte[] 1 record ;
   : Word[] 2 record ;
   : Cell[] CELL record ;

   \ ��१�ࢨ஢��� ���� �� ����� ��� ��।�������� ���祭��
   \ !!! ��������, �� ����⥫�� ���� �������਩ �� ���� ��ப�
   : noname\ ( disp # --> end ) + [COMPILE] \ ;

   \ ������� ���ᠭ�� ��������, ᮧ���� ��� \size, ��।����饥
   \ ࠧ��� ��������
   : EndStruct ( displ dispu --> )
               \ ᮧ���� ��� /size, �࠭�饥 ࠧ��� ��������
               ?Size S" /size" (F:) SWAP LIT, [COMPILE] ;F
               leave ;

\ ���������������������������������������������������������������������������

   \ ࠡ�� � ��⮢묨 ���ﬨ.
   : Funct: ( OR_mask | Name --> OR_mask )
            >R container ?chain , R@ , IMMEDIATE R>

            DOES> DUP CELL+ @ IF ELSE ALSO THEN
                  DUP @ CONTEXT !
                  8 + @

                  STATE @ IF TRUE TO prev-state [COMPILE] [ THEN  ;

   \ ���ᠭ�� ��⮢�� ��᮪
   :  Mask ( m m --> m ) :        LIT, POSTPONE OR  [COMPILE] ;  ;
   : -Mask ( m m --> m ) : INVERT LIT, POSTPONE AND [COMPILE] ;  ;
   : Bit   ( m n --> m ) : ?BIT   LIT, POSTPONE OR  [COMPILE] ;  ;
   : -Bit  ( m n --> m ) : N?BIT  LIT, POSTPONE AND [COMPILE] ;  ;
   \ ����᫥���
   : Enum  ( shift mask --> )
           : LIT, POSTPONE AND
             LIT, POSTPONE LSHIFT
             POSTPONE OR
           [COMPILE] ;  ;

   \ �� ᫮�� 㪠�뢠�� �� �, �� �।���� ��᪠ ��� ᫮�� ����뢠��
   \ ᡮ�� ��᪨. �. �ਬ�� � ����. ����� �ᯮ�짮���� � ��� ��।�������
   \ ᮧ����� �१ : -- ;

   : Verb: ( --> ) remove-ret POSTPONE (verb) RET, ;


   \ �������� ���ᠭ�� ��⮢�� ��᪨.
   : EndFunct ( OR_mask --> )
              DROP
              leave ;

\ ���������������������������������������������������������������������������

  PREVIOUS
;MODULE

\EOF

\ �ਬ�� ᮧ����� ��⮢�� ��᮪, ࠡ��� � ��⮢묨 ���ﬨ:
HEX
 F00 Funct: proba{
          3 Mask aaa
          4 Mask bbb
          9 -Bit ccc
          2 3 Enum ddd

         : } ; Verb:
  EndFunct

: first   proba{ aaa } . ;
: second  proba{ bbb } . ;
: thrid   proba{ aaa bbb } . ;
: fourth  proba{ ccc } . ;
: fifth   proba{ 5 ddd } . ;

\EOF

\ ��⮢�� ᥪ��

 Unit: proba                  CR    ORDER
     F: hello ." hello" ;F

     Sub Unit: check          CR    ORDER

     F: hello ." bye!" ;F
     EndUnit                  CR    ORDER
 EndUnit                      CR    ORDER

\EOF
������ �㦭� �� ���� ����� ᫮�� �� 㪠������� ᫮����, � ���⠢���
� १���� �ᯮ������ ᫮�� ᤥ���� 㪠����� ᫮���� ���⥪���
������ �� ��ਠ�⮢ ����� ����: [compile] unit � ⥫� ��।������. ��������,
�� �� �� ���訩 ��室, ��� ᠬ� ���⮩. ����筮 ����� �ਤ㬠��
�����-� ᫮��, ��� � ��� ���ண� ��� �ᥭ, � ��� ��� � 楫� �� �祭� 8)


�⠪, ������ ����� ����������� �ࠢ���� ᫮���ﬨ ��� ��譨� ��㤭��⥩.
� ������, �� ᮧ����� ᫮���� ��� �㦤� ������ ��� ⥪�騬 � ���⥪���,
��� �� �������� ࠭��: ALSO vocName DEFINITIONS, � � ����: PREVIOUS
DEFINITIONS. �஬� ⮣� ᫮��� �⠭������ IMMEDIATE, � ���� � ०���
�������樨 ᫮�� �� ᫮���� ����� ���� ������.

����� �⫨�� �� MODULE: �������� � ���. ��-�����, �� ��� ����� ����� 㤮���
�ᯮ�짮���� ������⢥��� �������� ᫮���:

        Unit: Azimuth
          Sub Unit: Go
              F: Left  ... ;F
              F: Right ... ;F
          EndUnit
        EndUnit

� ⮣��:

        Azimuth Go Left
        Altitude Go Up
���� ��� ����� �ࠢ���� ������ ⠪�� ᨭ⠪��, � ��
        Azimuth::Go::Left
⠪ ��� � ᨫ� ���� ��᫥���� ���ਭ�������, ��� ���� ᫮��.
�� � ����॥ ��������, ⠪ ��� ����॥ �������� ᫮�� �� ᫮����,
祬 ᫮�� �� 楯�窥 notfound.

---
ࠡ�� � ��⮢묨 ���ﬨ �룫廊� ���� ⠪ ��, ��� � � ������ࠬ�,
�� ����� ������� �⫨�� �易��� � ⥬, �� � ����� ���� �����
�����६���� ��⠭���������� � ���뢠���� ��᪮�쪮 ���. ��-�� �⮩
�ᮡ������ ��᫥ 㯮������� ����� ��⮢��� ���� (᫮����, ��� ���
���ᠭ�) �� �⥪ �몫��뢠���� ���� ��᪠ ���� (�� ᬥ饭��) � ��������
���室�� � ०�� �ᯮ������, �� �� ���, ���� �� ������ ᫮��, ����祭���
�ਧ����� Verb:, ���஥ �� ��� ���� �� �⮫쪮 �ਧ�����, ᪮�쪮
ᯮᮡ�� ������� ᡮ�� ��᪨ ��⠢��� १���� � ⥫� ��।������.
���� ��᪮�쪮 ����� ���ᠭ�� ��⮢�� �����:
     - n Bit ��⠭����� 㪠����� ��� � ��᪥
     - n -Bit ����� 㪠����� ��� � ��᪥
     - x Mask ��⠭����� 㪠����� ����
     - x -Mask ����� 㪠����� ����    (��᪠ �������� � ��אַ� ����)
     - s m Enum �� �ᯮ�짮����� �����䨪���, ᮧ������� �� Enum
       ����祭��� �� �⥪� �᫮ �㤥� ��१��� �� m ��᪥ � ᤢ���� s
       ࠧ �����, १���� ᤢ��� �㤥� �� OR ᫮��� � ������� ��᪮�.
�� �᭮��� ����樨 ��� ࠡ��� � ��᪠��. ��� ��㣨� �� ����室�����
����� ��������. �� ���� 㪠������� ����� �����筮, �⮡� ॠ��������
��⥬� ������� ���⮣� ������(� ��������� 䨪�஢����� ������).

