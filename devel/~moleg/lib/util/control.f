\ 19-04-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ����������: ��������� � �����

REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
REQUIRE ON-ERROR devel\~moleg\lib\util\on-error.f

        \ ���������� ��� �������� �������� ����������� � ����������� ����
        USER controls ( --> addr )

        \ ������ ���������� ������ ��� ������ ���� ���� ���������
        0x4000 CONSTANT #compbuf ( --> const )

        \ ����� ���������� ������
        USER-VALUE CompBuf ( --> addr )

        \ ���������� ��� ���������� �������� ������ DP �� CURRENT
        USER save-dp ( --> addr )

\ ������������ ��������� ����������
: rest ( --> )
       save-dp A@ DP !
       0 controls !
       [COMPILE] [ ;

\ ������ ���������� �� ��������� �����
: init: ( --> )
        0 controls A!
        HERE save-dp A!
        CompBuf IFNOT #compbuf ALLOCATE THROW TO CompBuf THEN
    ['] rest ON-ERROR
        CompBuf DP A!
        ] ;

\ ��������� ���������� �� ��������� �����, ��������� ��� ����������
\ ������������ ��������� ��������� ����������
: ;stop ( --> )
        RET,
    EXIT-ERROR rest
        CompBuf EXECUTE ;

\ ���� ���
\ ��� ����� � ����������� ���������� controls ������������� �� 1
\ ��� ������ �� ����������� - ����������� �� 1
: : 1 controls ! : ;
: ; controls @ 1 = IFNOT -22 THROW THEN  0 controls ! [COMPILE] ; ; IMMEDIATE

\ ---------------------------------------------------------------------------

\ ������ ���������. ��� �� ������ IF ����������� � ������, ���� flag <> 0
: IF ( flag --> )
     STATE @ IFNOT init: THEN
     2 controls +!
     HERE ?BRANCH, >MARK 1 ; IMMEDIATE

\ �������������� ���������. ��� �� else ����������� � ������, ����
\ �������� ��� �� ��������: IF ��� IFNOT ����������.
: ELSE ( --> ) ?COMP HERE BRANCH, >RESOLVE  >MARK 2  ; IMMEDIATE

\ ��������� ������ �����. �� ��� �� ������ BEGIN ���������� ����������
\ � ������ ���������� �����
: BEGIN ( --> )
        STATE @ IFNOT init: THEN
        2 controls +!
        <MARK 3 ; IMMEDIATE

\ ������� ��� ������� �� ����� BEGIN. �������� ����� ���� ������������ �����.
: AGAIN ( --> )
        ?COMP -2 controls +!
        3 = IFNOT -2006 THROW THEN  BRANCH,
        controls @ IFNOT ;stop THEN ; IMMEDIATE

\ ������� �� ����� ����� BEGIN ���� flag <> 0 (���� � ������������)
: UNTIL ( flag --> )
        ?COMP -2 controls +!
        3 = IFNOT -2004 THROW THEN ?BRANCH,
        controls @ IFNOT ;stop THEN ; IMMEDIATE

\ �������� ����� �� �����, ���� flag = 0
\ ������������ ����� BEGIN � REPEAT, ����������� ������ � ����� �����
: WHILE ( flag --> )
        ?COMP 2 controls +!
        HERE ?BRANCH, >MARK 1 2SWAP ; IMMEDIATE

\ �������� ����� �� �����, ���� flag <> 0. ������������ ���������� WHILE
: WHILENOT ( flag --> )
           ?COMP 2 controls +!
           HERE N?BRANCH, >MARK 1 ; IMMEDIATE

\ ����������� ������� �� BEGIN. ������������ ������ � BEGIN � WHILE
: REPEAT ( --> )
         ?COMP -4 controls +!
         3 = IFNOT -2005 THROW THEN BRANCH, >RESOLVE
         controls @ IFNOT ;stop THEN ; IMMEDIATE

\ ������ ���������. ������������� ���.
: ifnot ( flag --> )
        STATE @ IFNOT init: THEN
        2 controls +!
        HERE N?BRANCH, >MARK 1 ;

\ ����� ���������. �� ����� �� THEN ��������� ���������� ����� ����������
\ ����� �� �����������, �� ���� ���� ����� IF IFNOT ��� ELSE
: THEN ( --> )
       ?COMP -2 controls +!
       >RESOLVE
       controls @ IFNOT ;stop THEN ; IMMEDIATE

\ ������ ���������. ��� �� ������ IFNOT ����������� � ������, ���� flag = 0
: IFNOT ifnot ; IMMEDIATE

\EOF -- �������� ������ -----------------------------------------------------

S" ������ ���� true = " TYPE  1 IF ." true " ELSE ." false " THEN CR
S" ������ ���� false = " TYPE 0 IF ." true " ELSE ." false " THEN CR
: testa IF ." true " ELSE ." false " THEN CR ;
S" ������ ���� true = " TYPE  1 testa
S" ������ ���� false = " TYPE 0 testa
S" ��������� ��� �� 10 �� 0 = " TYPE 10 BEGIN DUP . DUP WHILE 1 - REPEAT DROP CR
S" ��������� ��� �� 10 �� 1 = " TYPE 10 BEGIN DUP . 1 - DUP 0= UNTIL DROP CR
S" ��������� ��� �� 9 �� 6 = "  TYPE 10 BEGIN 1 - DUP WHILE DUP 5 <> WHILE DUP . REPEAT THEN DROP CR
S" ��������� ��� �� 10 �� 6 = " TYPE 10 BEGIN DUP . 1 - DUP WHILE DUP 5 = UNTIL ELSE THEN DROP CR
