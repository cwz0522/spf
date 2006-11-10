USER CURFILE

: is_path_delimiter ( c -- flag )
  DUP [CHAR] \ = SWAP [CHAR] / = OR
;

: CUT-PATH ( a u -- a u1 )
\ �� ������ "path\name" �������� ������ "path\"
  CHARS OVER +
  BEGIN 2DUP <> WHILE DUP C@ is_path_delimiter 0= WHILE CHAR- REPEAT CHAR+ THEN
  \ DUP 0!  \ ~ruv (to anfilat): �� ������ ��� �������� �������� �����!
  OVER - >CHARS
;

: ModuleName ( -- addr u )
  1024 SYSTEM-PAD 0 GetModuleFileNameA
  SYSTEM-PAD SWAP
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
\ �������� addr u � ������_����_����������+devel\
  2>R
  ModuleDirName 2DUP +
  S" devel\" ROT SWAP CHARS MOVE
  6 + 2DUP +
  2R> DUP >R ROT SWAP CHAR+ CHARS MOVE 
  R> +
;
: SOURCE-NAME ( -- a u )
  CURFILE @ DUP IF ASCIIZ> ELSE 0 THEN
;
