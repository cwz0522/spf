\ 24-05-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ � ������� � ������������� ������

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE >DIGIT    devel\~moleg\lib\spf_print\pad.f
 REQUIRE UD/       devel\~moleg\lib\math\math.f

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

\ ������������� ������ � ������������� ����� ����� ���������� �����
: >FRACT ( asc # --> p TRUE | FALSE )
         0 >R  SWAP char - TUCK +
         BEGIN 2DUP <> WHILE
               DUP C@ BASE @ DIGIT WHILE
               R> SWAP BASE @ UD/ DROP >R
             char -
           REPEAT 2DROP RDROP FALSE EXIT
         THEN 2DROP R> TRUE ;

\ ������������� ������ ���� " 123,345" � ����� � ������������� ������
: pNUMBER ( asc # --> n p TRUE | FALSE )
          0 0 2SWAP >NUMBER
          DUP IF OVER C@ comma =
                 IF SKIP1 >FRACT
                    IF NIP SWAP TRUE EXIT THEN
                 THEN
              THEN
          2DROP 2DROP FALSE ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ S" 12,345" pNUMBER 0= THROW
         1481763717 12 D= 0= THROW
  S" passed" TYPE
}test
