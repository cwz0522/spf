\ $Id$
\

0 VALUE ARGC \ ���������� ���������� ��������� ������
0 VALUE ARGV \ ������ ����������

USER CURFILE

: is_path_delimiter ( c -- flag )
  [CHAR] / =
;

: CUT-PATH ( a u -- a u1 )
\ �� ������ "path/name" �������� ������ "path/".
\ �������� ������ �������� ���������� (r/o).
  CHARS OVER +
  BEGIN 2DUP <> WHILE CHAR- DUP C@ is_path_delimiter UNTIL CHAR+ THEN
  OVER - >CHARS
;

: ModuleName ( -- addr u )
  ARGV @ ASCIIZ> SYSTEM-PAD SWAP
  DUP >R CMOVE SYSTEM-PAD R>
;

: ModuleDirName ( -- addr u )
  ModuleName CUT-PATH
;

: +ModuleDirName ( addr u -- addr2 u2 )
  2>R
  ModuleDirName 2DUP +
  2R> DUP >R ROT SWAP CHAR+ CHARS MOVE 
  R> +
;

: +LibraryDirName ( addr u -- addr2 u2 )
\ �������� addr u � ������_����_����������+devel/
  2>R
  ModuleDirName 2DUP +
  S" devel/" ROT SWAP CHARS MOVE
  6 + 2DUP +
  2R> DUP >R ROT SWAP CHAR+ CHARS MOVE 
  R> +
;
: SOURCE-NAME ( -- a u )
  CURFILE @ DUP IF ASCIIZ> ELSE 0 THEN
;
