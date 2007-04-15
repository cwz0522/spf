\ $Id$
\
\ ���������� dot ��������
\
\ ��� �������������� ���������� dot ��������� � ��������
\ ����������� GraphViz http://www.graphviz.org/

MODULE: DOT-MODULE

0 VALUE H-DOTOUT

EXPORT

: DOT-TYPE ( a u -- ) H-DOTOUT WRITE-FILE THROW ;
: DOT-CR ( -- )  S" " H-DOTOUT WRITE-LINE THROW ;
: DOT-EMIT ( c -- ) SP@ 1 H-DOTOUT WRITE-FILE THROW DROP ;

\ ������������
: SAFE-DOT-TYPE ( a u -- )
   2DUP S" :" SEARCH NIP NIP 
   IF 
     [CHAR] " DOT-EMIT 
     DOT-TYPE 
     [CHAR] " DOT-EMIT 
   ELSE 
     DOT-TYPE 
   THEN ;

: DOT-FILLCOLOR ( color u -- )
   DOT-CR S" node [fillcolor=" DOT-TYPE DOT-TYPE S" ];" DOT-TYPE ;
    
\ ����� �� ������� � ������ a u � ������� � ������ a2 u2
: DOT-LINK ( a u a2 u2 -- )
   DOT-CR
   2SWAP
   SAFE-DOT-TYPE
   S"  -> " DOT-TYPE
   SAFE-DOT-TYPE
   S" ;" DOT-TYPE ;

\ ������ dot ���������. ��������� � ���� a u
: dot{ ( a u -- )
   R/W CREATE-FILE THROW TO H-DOTOUT
   S" digraph {" DOT-TYPE ;

\ ��������� dot ���������
: }dot 
    DOT-CR
    S" }" DOT-TYPE 
    H-DOTOUT CLOSE-FILE THROW ;

;MODULE
