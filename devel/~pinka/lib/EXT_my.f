\ 18.09.2000 Ruvim

\ - my addons:

\ ���������� �����.  ������� - � �����.
: .S ( -- )
    SP@ S0 @
    ." Stack: "
    BEGIN  2DUP <>  WHILE
        1 CELLS -  DUP @ .
    REPEAT 2DROP  ." |"
;

: S,    ( a u -- )
\ �������������� �������� ������ � ������� � ���� ������ � ���� �������� ������
  DUP C,  ( a u )
  HERE OVER  ALLOT
  SWAP CMOVE
;

\ ��������������, ����� ������� CREATED  ( ��� ���� ����� :)

: _+WORD ( A1 u1  A2 -> ) \ ���������� ��������� ������ � ������,
         \ �������� �������  A1 u1, � ������, ���������
         \ ���������� A2. ��������� ������ ���� ����� � ����� �
         \ ���������� ������ �� ALLOT. � �������� ����� ��
         \ ������ A2 ���������� ����� ���� ����� ������, �
         \ ������� ���������� ����� � ���� ������.
         \ ������: C" SP-FORTH" CONTEXT @ +WORD
\ was:
\  HERE LAST ! ( a1 a2 )
\  HERE ROT    ( a2 here a1 )
\  ",          ( a2 here )
\  SWAP DUP @  ( here a2 a )
\  , !

\ now: 

  HERE LAST !        ( a1 u1  a2 )
  HERE 2SWAP         ( a2 here a1 u1 )
  S,                 ( a2 here )
  SWAP DUP @ ,  !
;

: _HEADER1 ( a u -- )
  2>R
  HERE 0 , ( cfa )
  0 C,     ( flags )
  2R>

\  WARNING @
\  IF 2DUP SFIND
\     IF DROP 2DUP TYPE ."  isn't unique" ( ."  ��� ���������.") CR ELSE 2DROP THEN
\  THEN

  CURRENT @ _+WORD
  ALIGN
  HERE SWAP ! ( ��������� cfa )
;

: CREATED ( a u  -- )
  _HEADER1
  HERE DOES>A ! ( ��� DOES )
  ['] _CREATE-CODE COMPILE,
;



