( ��������� ���������� ���������� [������� �� ����, ���������
  �� ������������ �������, � �.�.] - ����� �������� � THROW.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  C������� 1999
)


USER EXC-HANDLER  \ ���������� ���������� (������������� � �����������)
VECT <EXC-DUMP>

USER ExceptionRecord

: (EXC) ( DispatcherContext ContextRecord EstablisherFrame ExceptionRecord -- flag )
  (ENTER) \ ����� ��� ����� ������
  0 FS@ @ \ ����� ������ ������ ��������� ���������� ��� ����� �������� �������
  DUP 0 FS! \ ��������������� ��� ����� ���������� ������ exceptions � �������
  CELL+ CELL+ @ TlsIndex! \ ��������� �� USER-������ ����������� ������

\  2DROP 2DROP
\  0 (LEAVE)               \ ��� ���� ����� �������� ��������� ����

  DUP <EXC-DUMP>
  @ THROW                 \ ���������� ���������� � ������ �������� :)
;

: DROP-EXC-HANDLER
  R> 0 FS! RDROP RDROP
\  EXC-HANDLER 0!
;
: SET-EXC-HANDLER
  R> R>
  TlsIndex@ >R
  ['] (EXC) >R
  0 FS@ >R
  RP@ 0 FS!
  RP@ EXC-HANDLER !
  ['] DROP-EXC-HANDLER >R \ ������������� ����� ����� ��������.����������
  >R >R
;
' SET-EXC-HANDLER (TO) <SET-EXC-HANDLER>

: HALT ( ERRNUM -> ) \ ����� � ����� ������
  ExitProcess
;
