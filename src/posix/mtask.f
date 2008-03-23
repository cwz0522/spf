\ $Id$
\ 
\ ������ � ��������
\ �. �������, 20.05.2007

: START ( x task -- tid )
  \ ��������� ����� task (��������� � ������� TASK:) � ���������� x
  \ ���������� tid - ����� ������, ��� 0 � ������ �������
  0 >R RP@ 0 2SWAP SWAP 4 <( )) pthread_create
  IF RDROP 0 ELSE R> THEN
;
: SUSPEND ( tid -- )
  \ ������� �����
  \ ���������� ������ ��� ������!
  1 <( 19 ( SIGSTOP) )) pthread_kill DROP
;
: RESUME ( tid -- )
  \ ��������� �����
  \ ���������� ������ ��� ������!
  1 <( 18 ( SIGCONT) )) pthread_kill DROP
;
: STOP ( tid -- )
  \ ���������� ����� (�������)
  1 <( )) pthread_cancel DROP
;
: PAUSE ( ms -- )
  \ ������������� ����� �� ms ����������� (1000=1���)
  \ ���������� ����� �������
  1000 /MOD SWAP 1000000 * >R >R
  (( RP@ 0 )) nanosleep DROP RDROP RDROP
;

: TERMINATE ( -- )
  \ ���������� ������� ����� (�������)
  (( -1 )) pthread_exit DROP
;
