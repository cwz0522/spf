( ���������� ��� ����������� ����������������� ������ �� pipe.
  [1:1 ����������� �� socketline2.f]
  Copyright 1996-2008 A.Cherezov ac@eserv.ru
)

REQUIRE { lib/ext/locals.f

10000 VALUE LINE_BUFF_SIZE         \ ������ ������

0                                  \ ��������� "�������� �����"
4 -- sl_pipe                       \ �������� pipe
4 -- sl_point                      \ �������� � ������ ������� ������� ������
4 -- sl_last                       \ ����� � ������ ������� ������� �������
CONSTANT /sl


\ PipeLine �������������� ����� ��� ����������� ������ ��������� ������
\ � ���������� ����� ���� ���������

: PipeLine ( pipe -- addr-S )
  { \ addr }
  LINE_BUFF_SIZE /sl + ALLOCATE THROW -> addr
  addr sl_pipe !
  addr sl_point 0!
  addr /sl + addr sl_last !
  addr
;

\ PipeGetPending �������� �� ������ ��, ��� ��� ��������,
\ �� ����� ���������� � ������

: PipeGetPending ( addr-S -- addr1 u1 )
  { addr }
  addr sl_last @
  addr /sl + addr sl_point @ + OVER - 0 MAX
;

\ PipeReadFromPending �������� �� ���������� � ������ ������
\ �� ����� u1 ����
\ ��������� ����������, �.�. ��� ������ "���������" �� ������.

: PipeReadFromPending ( u1 addr-S -- addr1 u2 ) \ u2 <= u1
  { u1 addr }
  addr PipeGetPending NIP u1 > 0=
  IF addr PipeGetPending
     addr sl_point 0!
     addr /sl + addr sl_last !
  ELSE
     addr PipeGetPending u1 MIN
     addr sl_last @ OVER + addr sl_last !
  THEN
;

\ PipeContRead
\

: PipeContRead1 ( addr-S -- )
  { addr \ a u }
  addr PipeGetPending
  OVER C@ 10 ( LF ) = OVER 0 > AND IF 1- SWAP 1+ SWAP THEN -> u -> a
  a addr /sl + u MOVE
  addr /sl + addr sl_last !

  addr /sl + u +
  LINE_BUFF_SIZE u -
  DUP 0 > 
  IF
    addr sl_pipe @ READ-FILE
    DUP 109 = IF DROP -1002 THEN
    THROW
    u + addr sl_point !
  ELSE 2DROP THEN
;
: PipeContRead2 ( addr-S -- ior )
  { addr \ a u }
  addr PipeGetPending -> u -> a
  a addr /sl + u MOVE
  addr /sl + addr sl_last !

  addr /sl + u +
  LINE_BUFF_SIZE u -
  addr sl_pipe @ READ-FILE
  DUP 109 = IF DROP -1002 THEN
\  DUP 10060 = IF a u DUMP CCR THEN
  DUP IF NIP EXIT THEN SWAP ( 0 n )
  u + addr sl_point !
;
: PipeContRead PipeContRead2 THROW ;

\ PipeReadLine ������ ������, ������������ LF ��� CRLF
\ ��� ������������ � ������������ ������ �� ����������.
\ ���� ������ �������� ������� ������, �� ����������� ��
\ ������, �� ������ ������� �� ������� �����. ������� �����
\ ���������� ���������� �������� ���� �������.
\ ���� ����������� �� ������, � � ������ ��� ���� ����
\ ������, �� ������������ �������� ������ �� ������
\ (�������� �����������).
: PipeReadLine ( addr -- addr1 u1 )
  { addr \ pa1 pu1 acr }
  BEGIN
    addr PipeGetPending -> pu1 -> pa1
    pa1 pu1 LT 1+ 1 SEARCH
    IF
        DROP -> acr
        acr 1+ addr sl_last !
        pa1 acr OVER - 
        BEGIN
          2DUP + 1- C@ 13 = 
        WHILE 1- 0 MAX REPEAT
        EXIT
    THEN  2DROP
    pu1 LINE_BUFF_SIZE =
    IF
       addr sl_point 0!
       addr /sl + addr sl_last !
       pa1 pu1 EXIT
    THEN
    addr PipeContRead2
    DUP -1002 = IF pu1 IF DROP
       addr sl_point 0!
       addr /sl + addr sl_last !
       pa1 pu1 EXIT
    THEN THEN THROW
  AGAIN
;
