\ 21-02-2007 ~mOleg 
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �����������, ������� �� ������� � ���

REQUIRE ?: devel\~moleg\lib\util\ifcolon.f

\ ������ �������� �� �������� ������ �� ����������.
?: atod ( addr --> disp )  HERE CELL+ - ;

\ ��������� �� ����
: N?BRANCH, ( ? )
            ?SET
            0x85 TO J_COD
            ???BR-OPT
            SetJP  SetOP
            J_COD    \  JX ��� 0x0F
            0x0F     \  ����� �� JX
            C, C,
            DUP IF atod THEN , DP @ TO LAST-HERE ;

\ ����������, ���� 0 ����� ������� �� ELSE
: IFNOT ( flag --> ) ?COMP 0 N?BRANCH, >MARK 1 ; IMMEDIATE

\ ���������� ����, ���� 0
: WHILENOT ( flag --> ) ?COMP 0 N?BRANCH, >MARK 1 2SWAP ; IMMEDIATE

\EOF

: sample ( flag --> ) IFNOT ." zero flag" ELSE ." non zero flag" THEN ;
FALSE DUP . sample CR
TRUE DUP . sample CR

: proba ( flag --> ) BEGIN DUP . DUP WHILENOT 1 - REPEAT . ;
0 proba CR
10 proba CR



