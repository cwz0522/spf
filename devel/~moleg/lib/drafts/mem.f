\ 02-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ������� - ��������

\ ��� ����� ������� �� ������ ��������, ����� �� ������ �� � ����������
\ ��������� ��� ��������� � ����� ������ �������������, � �� ��������!!!

REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
REQUIRE TILL     devel\~moleg\lib\util\for-next.f

\ ����������� ���� �� ������ �� ������ from � ������ �� ������ to
: (move) ( from to --> from to ) OVER C@ OVER C! ;

\ ����������� ��������� ���������� ���� # �� ������ � ���������
\ ������� from � ������ � ��������� ������� to ������� � ������� �������
: cmovel ( from to # --> ) FOR (move) 1 1 D+ TILL 2DROP ;

\ ����������� ��������� ���-�� ���� ������� �� ������� �������
: cmove> ( from to # --> ) 1 - DUP DUP FOR D+ (move) -1 -1 NEXT 2DROP 2DROP ;

\ ��������� ������� ������ ������� � ������ from ������ b # ���� ������
: fill ( b from # --> ) FOR 2DUP C! 1 + TILL 2DROP ;

\ �������� ��������� ���-�� ���� ������� � ������ from � ����
: erase ( from # --> ) 0 -ROT fill ;

\ �������� ��� ����� �� ������
: (comp) ( which with --> which with flag ) OVER C@ OVER C@ = ;

\ ��������� ���� ����� ���������� ����� �� ������������.
: same ( which with # --> flag )
       FOR (comp)
           IF 1 1 D+
            ELSE 2DROP RDROP FALSE
           EXIT THEN
       TILL 2DROP TRUE ;

\ �������� ��� ������ �� ������������
: like ( which # with # --> flag )
       ROT OVER =
       IF same
        ELSE DROP 2DROP FALSE
       THEN ;

\ �������� ��� asciiz ������ �� ���������
: equal ( asc1Z asc2Z --> flag )
        BEGIN DUP C@ WHILE
              (comp) WHILE
              1 1 D+
           REPEAT 2DROP FALSE EXIT
        THEN (comp) NIP NIP ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test

