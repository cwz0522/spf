( ���������� ����-�����.
  ��-����������� ����� [������������...].
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

32 VALUE BL ( -- char ) \ 94
\ char - �������� ������� "������".


: SPACE ( -- ) \ 94
\ ������� �� ����� ���� ������.
  BL EMIT
;

: SPACES ( n -- ) \ 94
\ ���� n>0 - ������� �� ������� n ��������.
  DUP 1 < IF DROP EXIT THEN
  BEGIN
    DUP
  WHILE
    BL EMIT 1-
  REPEAT DROP
;

TARGET-POSIX [IF]
\ TODO
[ELSE]
  S" src/win/spf_win_con_io.f" INCLUDED
[THEN]
