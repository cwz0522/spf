( ��������� ���������� ���������� [������� �� ����, ���������
  �� ������������ �������, � �.�.] - ����� �������� � THROW.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  C������� 1999
)

   H-STDIN  VALUE  H-STDIN    \ ����� ����� - ������������ �����
   H-STDOUT VALUE  H-STDOUT   \ ����� ����� - ������������ ������
   H-STDERR VALUE  H-STDERR   \ ����� ����� - ������������ ������ ������
          0 VALUE  H-STDLOG


USER EXC-HANDLER  \ ���������� ���������� (������������� � �����������)
VECT <EXC-DUMP>

: (EXC) ( exc-info -- )
  0 FS@ @                 \ Windows ���������� ����� ����������
                          \ �� ��������� � ��� ����� ������� (������)
\  DUP 0 FS!               \ �������������� ����� �� ����������� �����
  DESTROY-HEAP            \ ������� ���, ��������� ��� ����� �����������
  CELL+ CELL+ CELL+ @ TlsIndex! \ ��������� �� USER-������ ����������� ������
                          \ ����� �c���������� ��� ��� � USER-data
\  CGI? @ IF H-STDOUT >R H-STDERR TO H-STDOUT THEN
  DUP <EXC-DUMP>          \ ���������������� ���������� (���� �� ���������)
\  CGI? @ IF R> TO H-STDOUT THEN \ � cgi ������ �������� ���� � h-stderr
  EXC-HANDLER 0!
  @ THROW                 \ ���������� ���������� � ������ �������� :)
;
' (EXC) WNDPROC: EXC

: DROP-EXC-HANDLER
  RDROP RDROP R> 0 FS! RDROP RDROP RDROP
;
: SET-EXC-HANDLER
  R>
  0 >R -1 >R TlsIndex@ >R 0 FS@ >R ['] EXC >R 0 FS@ >R
  RP@ 0 FS! RP@ EXC-HANDLER !
  ['] DROP-EXC-HANDLER >R  \ ������������� ����� ����� ��������.����������
  >R
;
' SET-EXC-HANDLER (TO) <SET-EXC-HANDLER>

: AT-PROCESS-FINISHING ( -- ) ... ;

: HALT ( ERRNUM -> ) \ ����� � ����� ������
  AT-PROCESS-FINISHING
  ExitProcess
;
