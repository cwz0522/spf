\ 2006-12-09 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� ����� ������������ � ������ ������� ����

 REQUIRE COMPILE  devel\~mOleg\lib\util\compile.f
 REQUIRE SeeForw  devel\~mOleg\lib\util\parser.f

\ -- ��������� ----------------------------------------------------------------

?DEFINED char  1 CHARS CONSTANT char

\ -- ���������� ---------------------------------------------------------------

\ ��� ������ ��������� � ������������ ������
\ ������ ������������ � ������ �����
: \. ( --> ) 0x0A PARSE CR TYPE ;

\ ���������� �� ����� ������ (��� ���������� �������������� ������ ����)
: \? ( --> ) [COMPILE] \ ; IMMEDIATE

FALSE WARNING !

\ ����������� ���������� �������� ������ �
\ � ������� �� ������� ����� ��� ���������� � ������� �������� �
\ ��������� �������� ������, � ���������� � ������������ �����
\ ��������� ��������� ������� ������ ����� � ����� �����.
\ ����� ������� ���������� ����� ����������� ������ � �����������.
: \EOF  ( --> )
        SOURCE-ID DUP IF ELSE TERMINATE THEN
        >R 2 SP@ -2 CELLS + 0 R> SetFilePointer DROP
        [COMPILE] \ ;

TRUE WARNING !

\  -- ������� ------------------------------------------------------------------

\ �������� � ��������� ������ ����� ������� �������
: SEAL ( --> ) CONTEXT @ ONLY CONTEXT ! ;

\ �������� ������� ����������� ������� ���������
: WITH ( vid --> ) >R GET-ORDER NIP R> SWAP SET-ORDER ;

\ ������� ������� ������� � ������� ���������, ��������� �� ���
\ ������� �������.
: RECENT ( --> )
         GET-ORDER 1 -
           DUP IF NIP OVER SET-CURRENT SET-ORDER
                ELSE DROP
               THEN ;

\ ��������� vid ������� � ������� ��������� � CURRENT
: THIS ( --> ) CONTEXT @ SET-CURRENT PREVIOUS ;

\ �������� ������� ��� ������� �� ������� ���������
: UNDER ( --> ) GET-ORDER DUP 1 - IF >R SWAP R> THEN SET-ORDER ;


\ -- ������������� ������������ ���� ������� ----------------------------------

\ ������������� �� HERE n ���� ������, ��������� �� ������ char
: AllotFill  ( char n --> ) HERE OVER ALLOT -ROT FILL ;

\ ������������� �� HERE n ���� ������, ��������� �� ������
: AllotErase ( n --> ) 0 SWAP AllotFill ;

\ -----------------------------------------------------------------------------

\ ��������� �������� funct � ������� �� �������� namea .. namen,
\ ������������� �� ����� ������, ��������: ToAll VARIABLE aaa bbb ccc
: ToAll ( / funct namea ... namen --> )
        ' >R BEGIN SeeForw WHILE DROP
                   R@ EXECUTE
             REPEAT DROP RDROP ;

\ ������� ���� TRUE , ���� ������� ������� ESC
\ ��� ������� ����� ������ ������� ������ �������� ������� ���������
\ ���� ������ �������� �� ESC ������� - ������� FALSE ����� TRUE
: ?PAUSE ( --> flag )
         KEY? IF KEY 0x1B =
                 IF TRUE EXIT
                  ELSE KEY 0x1B =
                    IF TRUE EXIT THEN
                 THEN
              THEN FALSE ;

\ ��������� ����� �� ��� ���, ���� �� ����� ������ ����� �������
\ ������ �������������: : test ." ." ; PROCESS test
: PROCESS ( / name --> )
          ' >R BEGIN ?PAUSE WHILENOT
                     R@ EXECUTE
               REPEAT
            RDROP ;

\ ��������� ��������� ����� ��� ������ �� �����������
: GoAfter ( --> ) ' [COMPILE] LITERAL COMPILE >R ; IMMEDIATE

\ �� �� ��� � : ������ ��� �������� �� ������� ����� ������
\ � ���� ������ �� ���������. ������:  S" name" S: ��� ����� ;
?DEFINED S: : S: ( asc # --> ) SHEADER ] HIDE ;

\ ������� ������ ������ �� ��������� ����������
?DEFINED SERROR : SERROR ( asc # --> ) ER-U ! ER-A ! -2 THROW ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test
