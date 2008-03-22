\ 2008-03-21 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ �࠭���� ��ப � ���稪�� ��६����� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE SWITCH:  devel\~moleg\lib\util\switch.f
 S" devel\~mOleg\lib\util\bytes.f" INCLUDED

\ ��⮤� �����祭�� �᫠
: 1byte ( n --> u # ) 1 RSHIFT 0x7F AND 1 ;
: 2byte ( n --> u # ) 2 RSHIFT 0x3FFF AND 2 ;
: 4byte ( n --> u # ) 2 RSHIFT 4 ;

\ ������� 㯠�������� �᫮ u �� ����� �� ����� addr
\ ������ ������⢮ ���� � �᫥
: X@ ( addr --> u # )
     @ DUP 3 AND SWITCH: NOOP 1byte 2byte 1byte 4byte ;SWITCH ;

\ ��࠭��� 㯠�������� �᫮ u � ������ �� ����� addr
\ ������ ������⢮ ���� � �᫥
: X! ( u addr --> # )
     >R 0x80 OVER U> IF 1 LSHIFT R> B! 1 EXIT THEN
        0x4000 OVER U> IF 2 LSHIFT 1 OR R> W! 2 EXIT THEN
        2 LSHIFT 3 OR R> ! 4 ;

\ ������ ���� ��砫� � ����� ���� (��ப�)
: COUNT ( addr --> addr u ) DUP X@ ROT + SWAP ;

\ �������஢��� �᫮ �� ���設� ����䠩��
: X, ( u --> ) HERE X! ALLOT ;

\ �������஢��� ��ப� � ���稪�� �� ���設� ����䠩��
: S", ( asc # --> ) DUP X, S, ;

\ �뫮���� ���� � ��砫� ��ப�, ����饩 � ���� �� SLITERAL
: (SLITERAL) ( r: addr --> asc # ) R> COUNT 2DUP + 1 + >R ;

\ ��������஢��� ���ࠫ��� ��ப�, �������� asc # � ⥪�饥 ��।������
: SLIT, ( asc # --> ) COMPILE (SLITERAL) S", 0 B, ;

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ CREATE zzz 0 ,
      0x7F zzz X! 1 <> THROW  zzz X@ 1 <> THROW 0x7F <> THROW
      0x3FFF zzz X! 2 <> THROW  zzz X@ 2 <> THROW 0x3FFF <> THROW
      0x1FFFFF zzz X! 4 <> THROW  zzz X@ 4 <> THROW 0x1FFFFF <> THROW
      0xFFFFFFF zzz X! 4 <> THROW  zzz X@ 4 <> THROW 0xFFFFFFF <> THROW
      zzz DUP COUNT 0xFFFFFFF <> THROW CELL - <> THROW
  S" passed" TYPE
}test
