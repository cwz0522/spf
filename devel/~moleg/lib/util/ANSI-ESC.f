\ 25-06-2005    ࠡ�� � ���᮫�� �१ ANSY �ନ���

 \ ⠪ �룫廊� ANSI ESCAPE ��᫥����⥫쭮���
 CREATE esc 2 C, 0x1B C, CHAR [ C,

\ � ��, �� [CHAR] n HOLD
: hld" [COMPILE] [CHAR] POSTPONE HOLD ; IMMEDIATE

\ � ��, �� 0x1B HOLD [CHAR] [ HOLD
: ESC  [ esc COUNT ] 2LITERAL HOLDS ;

: PRINT COUNT TYPE ;

\ S" ��� �⮪, ᮤ�ঠ�� "
: S~ [CHAR] ~ PARSE [COMPILE] SLITERAL ; IMMEDIATE

: ESC: S~ CREATE NextWord S", DOES> esc PRINT~ EVALUATE ; IMMEDIATE

\ ���������������������������������������������������������������������������

\ escape ��᫥����⥫쭮�� ��� ��ࠬ��஢
: esc-0 ESC: PRINT ;

esc-0 page 2J   \ ������ ��, ����� � 0,0
esc-0 !csr s    \ ��������� ��������� �����
esc-0 @csr u    \ ����⠭����� ��࠭����� ��������� �����
esc-0 clrl K    \ ������ �� ����� �� ���� ��ப�

\ ���������������������������������������������������������������������������
\ escape ��᫥����⥫쭮�� � ����� ��ࠬ��஬ � '=' ��᫥ esc
: esc-k ESC: <# COUNT HOLDS 0 # # # hld" = #> TYPE ;

esc-k mode h    \ �롮� ०��� ࠡ��� ���᮫�
esc-k resm I    \ ��� ०��� ࠡ��� ���᮫�

\ � microsoft ������� ⠪�� ०���
0 CONSTANT 40*25bw
1 CONSTANT 40*25clr
2 CONSTANT 80*25bw
3 CONSTANT 80*25clr
4 CONSTANT 320*200clr
5 CONSTANT 320*200bw
6 CONSTANT 640*200bw

\ escape ��᫥����⥫쭮�� � ����� ��ࠬ��஬
: esc-1 ESC: <# COUNT HOLDS 0 # # # #> TYPE ;

esc-1 cuu A     \ ����� ����� �� # ��ப
esc-1 cud B     \ ����� ���� �� # ��ப
esc-1 cuf C     \ ����� ��ࠢ� �� # �������
esc-1 cub D     \ ����� ����� �� # �������

\ ���������������������������������������������������������������������������

\ ��᫥����⥫쭮�� � ���� ��ࠬ��ࠬ�
: esc-2 ESC: <# COUNT HOLDS 0 # # # hld" ; NIP # # # #> TYPE ;

esc-2 XY! H

\ ���������������������������������������������������������������������������

\ ��᫥����⥫쭮�� � ����� 䨪�஢���� ��ࠬ��஬
: esc-x ( n | name p --> )
        CREATE NextWord <# HOLDS 0 # # # ESC #> S",
        DOES> PRINT ;

7 esc-x invscr m
0 esc-x atroff m
1 esc-x boldon m
5 esc-x blink  m
8 esc-x concea m

0 CONSTANT black
1 CONSTANT red
2 CONSTANT green
3 CONSTANT yellow
4 CONSTANT blue
5 CONSTANT magenta
6 CONSTANT cyan
7 CONSTANT white

esc-1 setprm m

\ ��⠭����� 梥�
: color 30 + setprm 40 + setprm ;

\ ���������������������������������������������������������������������������

\ ����� ���न��� �����
esc-0 xy? 6n

\ �८�ࠧ����� �᫮
: >num ( asc # --> n  )
       0 0 2SWAP >NUMBER 2DROP DROP ;

\ ���� �� ��᫥����⥫쭮��� ᨬ����� �� addr ESCAPE ��᫥����⥫쭮����
: ?esc[ ( addr --> flag ) W@ esc 1+ W@ = ;

\ �஢���� ����稥 �ࢨ� ANSY
: check-ANSI xy? REFILL
             IF CharAddr ?esc[ #TIB >IN !
              ELSE FALSE
             THEN ;

\ ������� ��������� �����
: XY@ xy? REFILL DROP 2 >IN +!
      [CHAR] ; PARSE >num
      [CHAR] R PARSE >num ;

\ ������� ࠧ���� ������ �⮡ࠦ����
: [XY] !csr 99 cuf 99 cud XY@ @csr ;

\ ���������������������������������������������������������������������������


