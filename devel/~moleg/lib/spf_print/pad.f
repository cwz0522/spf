\ 04-06-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������������� ����� ��� ������� ������ � ������� PAD

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE ADDR     devel\~moleg\lib\util\addr.f
 REQUIRE R+       devel\~moleg\lib\util\stackadd.f

?DEFINED char  1 CHARS CONSTANT char

        0x0D    CONSTANT cr_
        0x0A    CONSTANT lf_
        0x09    CONSTANT tab_
        CHAR .  CONSTANT point
        CHAR ,  CONSTANT comma

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

       8 VALUE places   \ ���������� ������������ �������� ����� �������

\ �������� ��������� �����
: $ ( n --> n*base ) BASE @ UM* >DIGIT KEEP ;

\ ������������� �����
: $S ( n --> )
     places HLD @ OVER CHARS - HLD !
     HLD @ >R
      >R BEGIN R@ WHILE $ -1 R+ REPEAT RDROP DROP
     R> HLD ! ;

\ ������������� ����� � ������������� ������.
: (N.P) ( p n --> asc # )
        DUP >R DABS SWAP 1 + <# $S comma HOLD 0 #S R> SIGN #> ;

\ ����������� ����� � ������������� ������
: N.P ( n p --> ) (N.P) TYPE SPACE ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ �������� ���������������.

  S" passed" TYPE
}test
