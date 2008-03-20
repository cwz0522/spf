\ 2008-03-20 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ ��������� ������� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE SWITCH:  devel\~moleg\lib\util\switch.f
 S" devel\~mOleg\lib\util\bytes.f" INCLUDED

\ ���������� �������� ����� ������������ �����
: 1x7F ( u --> u ) 1 RSHIFT 0x7F AND 1 ;
\ .. ������������ �����
: 2x3FFF ( u --> u ) 2 RSHIFT 0x3FFF AND 2 ;
\ .. ������������ �����
: 3x1FFFFF ( u --> u ) 3 RSHIFT 0x1FFFFF AND 3 ;
\ .. ��������������� �����
: 4xFFFFFFF ( u--> u ) 4 RSHIFT 0xFFFFFFF AND 4 ;

\ ������� �������� u, �������� �� ������ Addr � ����� ���� ������
: SCNT@ ( addr --> u # )
        @ DUP 7 AND
        SWITCH: NOOP
                1x7F 2x3FFF  1x7F 3x1FFFFF  1x7F 2x3FFF  1x7F 4xFFFFFFF
        ;SWITCH ;

\ ��������� �������� u � ������ �� ������ addr,
\ ������� ���-�� ����, ���������� ��� �������� �����
: SCNT! ( u addr --> # )
        OVER 0x1FFFFF U> IF SWAP 4 LSHIFT 7 OR SWAP ! 4 EXIT THEN
        OVER 0x3FFF > IF SWAP 3 LSHIFT 3 OR SWAP ! 3 EXIT THEN
        OVER 0x7F > IF SWAP 2 LSHIFT 1 OR SWAP W! 2 EXIT THEN
        SWAP 1 LSHIFT SWAP B! 1 ;

\ ������� ����� ������ � ����� ���� (������)
: COUNT ( addr --> addr u ) DUP SCNT@ ROT + SWAP ;

\ ������������� ����� �� ������� ���������
: SCNT, ( u --> ) HERE SCNT! ALLOT ;

\ ������������� ������ �� ��������� �� ������� ���������
: S", ( asc # --> ) DUP SCNT, S, ;

\ �������� ����� � ������ ������, ������� � ���� �� SLITERAL
: (SLITERAL) ( --> asc # )
             R> COUNT 2DUP + 1 + >R ;

\ �������������� ����������� ������, �������� asc # � ������� �����������
: SLIT, ( asc # --> ) COMPILE (SLITERAL) S", 0 B, ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ CREATE zzz 0 ,
      0x7F zzz SCNT! 1 <> THROW  zzz SCNT@ 1 <> THROW 0x7F <> THROW
      0x3FFF zzz SCNT! 2 <> THROW  zzz SCNT@ 2 <> THROW 0x3FFF <> THROW
      0x1FFFFF zzz SCNT! 3 <> THROW  zzz SCNT@ 3 <> THROW 0x1FFFFF <> THROW
      0xFFFFFFF zzz SCNT! 4 <> THROW  zzz SCNT@ 4 <> THROW 0xFFFFFFF <> THROW
      zzz DUP COUNT 0xFFFFFFF <> THROW CELL - <> THROW
  S" passed" TYPE
}test

\EOF
������ ���������� ����� ���������� ������������� ������� ������ ������ �����
255 ��������, ��� ����, ��� ������, ���������� ����� ������ �������� ���������
���������, �� ������� �� �������� �� ������ ����� �������.
������� ��, ����� ������� ������� ����� ������ � 4 �����... �� ������� �����
�������� �������...
� ������ ����������� ����� �������� ������ ����� ���������� 1,2,3,4 ����� - �
����������� �� ����� ������: 127\16383\2097151\268435455.
���������� ����� ������ 2^28-1 = 268435455.
