( ���������������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)
: START ( x task -- tid )
  \ ��������� ����� task (��������� � ������� TASK:) � ���������� x
  \ ���������� tid - ����� ������, ��� 0 � ������ �������
  0 >R RP@
  0 2SWAP 0 0 CreateThread
  RDROP
;
: SUSPEND ( tid -- )
  \ ������� �����
  SuspendThread DROP
;
: RESUME ( tid -- )
  \ ��������� �����
  ResumeThread DROP
;
: STOP ( tid -- )
  \ ���������� ����� (�������)
  -1 SWAP TerminateThread DROP
;
: PAUSE ( ms -- )
  \ ������������� ����� �� ms ����������� (1000=1���)
  \ ���������� ����� �������
  Sleep DROP
;