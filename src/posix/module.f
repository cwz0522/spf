\ $Id$
\

0 VALUE ARGC \ ���������� ���������� ��������� ������
0 VALUE ARGV \ ������ ����������

: is_path_delimiter ( c -- flag )
  [CHAR] / =
;

: ModuleName ( -- addr u )
  ARGV @ ASCIIZ> SYSTEM-PAD SWAP
  DUP >R CMOVE SYSTEM-PAD R>
;
