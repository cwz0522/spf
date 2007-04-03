\ 16-02-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������������� �������� ��������� ��� �������������.

\ ��������� ����� ������� ������ �� ���������
: DU* ( d u --> d ) TUCK * >R UM* R> + ;

\ ������������� ������ � ����� �
: >CIPHER ( c --> u|-1 )
          DUP [CHAR] 0 [CHAR] : WITHIN IF 48 - EXIT THEN
          DUP [CHAR] A [CHAR] [ WITHIN IF 55 - EXIT THEN
          DUP [CHAR] a [CHAR] { WITHIN IF 87 - EXIT THEN
          DROP -1 ;

\ ���������� ������������� ������ char � �����,
\ � ������� ����������, ������������ base �
: DIGIT ( char base --> u TRUE | FALSE )
        SWAP >CIPHER TUCK U>
        IF TRUE ELSE DROP FALSE THEN ;

\ �������� ����� x � ����� d*base �
: CIPHER ( d x --> d )
         U>D 2SWAP BASE @ DU* D+ ;

\ ��������� ���������� ������������� ����� �� ���������� ( �������� ) �
\ �������������� ������� �� ����� ������ ��� �� ������� ����������������
\ �������. ���� #2 ����� ���� �������������� �������.
: >NUMBER ( ud1 asc1 #1 --> ud2 asc2 #2 )
          BEGIN DUP WHILE               \ ���� �� ����� ������
            OVER C@ BASE @ DIGIT WHILE  \ �� ������ ��������������� �����
            -ROT SKIP1 2>R CIPHER 2R>   \ �������� �����
           REPEAT
          THEN ;
