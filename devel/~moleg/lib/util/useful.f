\ 2006-12-09 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� ����� ������������ � ������ ������� ����

REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
REQUIRE ADDR     devel\~moleg\lib\util\addr.f
REQUIRE COMPILE  devel\~mOleg\lib\util\compile.f
REQUIRE WHILENOT devel\~mOleg\lib\util\ifnot.f

FALSE WARNING !

\ -- ��������� ----------------------------------------------------------------

        1 CHARS CONSTANT char
        0x0D    CONSTANT cr_
        0x0A    CONSTANT lf_
        0x09    CONSTANT tab_

\ -- ���������� ---------------------------------------------------------------

\ ��� ������ ��������� � ������������ ������
\ ������ ������������ � ������ �����
: \. ( --> ) 0x0A PARSE CR TYPE ;

\ ���������� �� ����� ������ (��� ���������� �������������� ������ ����)
: \? ( --> ) [COMPILE] \ ; IMMEDIATE

\ ����������� ���������� �������� ������ �
\ � ������� �� ������� ����� ��� ���������� � ������� �������� �
\ ��������� �������� ������, � ���������� � ������������ �����
\ ��������� ��������� ������� ������ ����� � ����� �����.
\ ����� ������� ���������� ����� ����������� ������ � �����������.
: \EOF  ( --> )
        SOURCE-ID DUP IF ELSE TERMINATE THEN
        >R 2 SP@ -2 CELLS + 0 R> SetFilePointer DROP
        [COMPILE] \ ;

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

\ -- �������� ����������� -----------------------------------------------------

\ �������� �������� ������ �� ������� ����� �� ��������� ����������
: change ( n addr --> [addr] ) DUP @ -ROT ! ;

\ ��������� ������� ������� ��������� ����� ������� � �������
: bounds ( addr # --> up low ) OVER + SWAP ;

\ �������� ��� �������� �� ����� ������
: 3DROP ( a b c --> ) 2DROP DROP ;

\ ���������� ��� ������� �������� �� ����� ���������
: 3DUP ( a b c --> a b c a b c ) >R 2DUP R@ -ROT R> ;

\ ������� � ������� ����� ��������� ����� ����������
: nDROP ( [ .. ] n --> ) 1 + CELLS SP@ + SP! ;

\ ������� ������ ������� ��������
: 2NIP ( da db --> db ) 2SWAP 2DROP ;

\ �������� ����� � ������������ �� ����� ���������
: R+ ( r: a d: b --> r: a+b ) 2R> -ROT + >R >R ;

\ ����������� �������� �� �����������
: RANKING ( a b --> a b ) 2DUP MIN -ROT MAX ;

\ ��������� ����� base �� ��������� �������� n �
\ ������� ������������ ������������.
\ ������������ ������������ � ������� �������
: ROUND ( n base --> n ) TUCK 1 - + OVER / * ;


\ -- ���������� �������� ------------------------------------------------------

\ �������� �� ������ ���� ��� �����
: ?BIT  ( N --> mask ) 1  SWAP LSHIFT ;

\ �������� �� ������ ���� ��� ��������� �����
: N?BIT ( N --> mask ) ?BIT INVERT ;

\ ������� TRUE ���� ����������� ������� a < ��� = b, ����� FALSE
: >= ( a b --> flag ) < 0= ;

\ -- ������ -------------------------------------------------------------------

\ ����� ���������� >IN �����, �� ������ ���������� ����� asc #
: <back ( asc # --> ) DROP TIB - >IN ! ;

\ ���������� ���� ������ �� ������� ������
: SkipChar ( --> )  >IN @ char + >IN ! ;

\ ����� ��������� ������ �� �������� ������
: NextChar ( --> char flag ) EndOfChunk PeekChar SWAP SkipChar ;

\ ������� ����� � ������ ��� �� ��������������������� ����� �������� ������.
: REST ( --> asc # ) SOURCE >IN @ DUP NEGATE D+ 0 MAX ;

\ ����� ����� ��������� ������� �� �������� ������ �� ��� ���, ���� ��
\ �� �����������.
: NEXT-WORD ( --> asc # | asc 0 )
            BEGIN NextWord DUP WHILENOT
                  DROP REFILL DUP WHILE
                  2DROP
               REPEAT
            THEN ;

\ ������� ������ ������� ������
: EMPTY" ( --> asc # ) S" " ;

\ ��������� ������ �� ������� ������
: SeeForw ( --> asc # ) >IN @ NextWord ROT >IN ! ;

\ ������������� ������ � ������, ���������� ���� ������
: Char>Asc ( char --> asc # ) SYSTEM-PAD TUCK C! 0 OVER char + C! char ;

\ ��������� ������ asc # �� u �������� �� ������
: SKIPn ( asc # u --> asc+u #-u ) OVER MIN TUCK - >R + R> ;

\ �� �������� ������ �������� ��� �����
: ParseFileName ( --> asc # )
                PeekChar [CHAR] " =
                IF [CHAR] " SkipChar
                 ELSE BL
                THEN PARSE
                2DUP + 0 SWAP C! ;

\ ���������� SOURCE �� ������ ���������� �
: cmdline> ( --> )
           -1 TO SOURCE-ID
           GetCommandLineA ASCIIZ> SOURCE!
           ParseFileName 2DROP ;

\ -- ������ � ������� pad -----------------------------------------------------

\ ������������� ����� � ������
: >DIGIT ( N --> Char ) DUP 0x0A > IF 0x07 + THEN 0x30 + ;

\ �������� ������ � PAD
: BLANK ( --> ) BL HOLD ;

\ �������� ��������� ���-�� �������� � PAD
: BLANKS ( n --> ) 0 MAX BEGIN DUP WHILE BLANK 1 - REPEAT DROP ;

\ ������������� ������ ������� �������������� �
: <| ( --> ) SYSTEM-PAD HLD A! ;

\ �������� ������ � ����� PAD �
\ ������� �� HOLD � ���, ��� ������ ����������� � ����� ����������� ������
\ � �� � �� ������.
: KEEP ( char --> ) HLD A@ C! char HLD +! ;

\ ������� �������������� ������ �
: |> ( --> asc # ) 0 KEEP SYSTEM-PAD HLD A@ OVER - char - ;

\ �������� ������ � ����� PAD �
\ �������� ���������� HOLDS �� ����������� ����, ��� ������ �����������
\ � ����� ����������� ������, � �� � �� ������.
: KEEPS ( asc # --> ) HLD A@ OVER HLD +! SWAP CMOVE ;

\ -- ������������� ������������ ���� ������� ----------------------------------

\ ������������� �� HERE n ���� ������, ��������� �� ������ char
: AllotFill  ( n char --> ) HERE OVER ALLOT -ROT FILL ;

\ ������������� �� HERE n ���� ������, ��������� �� ������
: AllotErase ( n --> ) 0 AllotFill ;

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

TRUE WARNING !

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test
