( ������ ������ ���� ������� - WORDS.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

USER >OUT
USER W-CNT

: NLIST ( A -> )
  @
  >OUT 0! CR W-CNT 0!
  BEGIN
    DUP 0<> KEY? 0= AND
  WHILE
    W-CNT 1+!
    DUP C@ >OUT @ + 71 >
    IF CR >OUT 0! THEN
    DUP ID.
    DUP C@ >OUT +!
    8 >OUT @ 8 MOD - DUP >OUT +! SPACES
    CDR
  REPEAT DROP KEY? IF KEY DROP THEN
  CR CR ." Words: " W-CNT @ U. CR
;

: WORDS ( -- ) \ 94 TOOLS
\ ������ ���� ����������� � ������ ������ ���� ������� ������. ������ ������� 
\ �� ����������.
\ WORDS ����� ���� ���������� � �������������� ���� ���������� �������������� 
\ �����. ��������������, �� ����� ��������� ������������ �������, 
\ ���������������� #>.
  CONTEXT @ NLIST
;

