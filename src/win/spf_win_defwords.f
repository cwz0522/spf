( ���������� � Windows - ����������� � ������� ������������� 
  ������� Windows � �������������� ������� [callback, wndproc � �.�.]
  Windows-��������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

VARIABLE WINAP
VARIABLE WINAPLINK
0  VALUE NEW-WINAPI?

: WINAPI: ( "������������" "�������������" -- )
  ( ������������ ��� ������� WIN32-��������.
    ���������� ����������� ����� ����� ��� "������������".
    ���� address of winproc ����� ��������� � ������ �������
    ���������� ���������� ��������� ������.
    ��� ������ ���������� "���������" ��������� ���������
    ���������� �� ���� ������ � �������, �������� ����������
    � ��-������ ���� ���������. ��������� ���������� �������
    ����� ������� �� ����.
  )

  NEW-WINAPI?
  IF DROP HEADER
  ELSE
     >IN @
     HEADER
     >IN !
  THEN
  ['] _WINAPI-CODE COMPILE,
  HERE WINAP !
  0 , \ address of winproc
  0 , \ address of library name
  0 , \ address of function name
\  0 , \ # of parameters
  IS-TEMP-WL 0=
  IF
    HERE WINAPLINK @ , WINAPLINK ! ( ����� )
  THEN
  HERE WINAP @ CELL+ CELL+ !
  HERE >R
  NextWord HERE SWAP DUP ALLOT MOVE 0 C, \ ��� �������
  HERE WINAP @ CELL+ !
  HERE >R
  NextWord HERE SWAP DUP ALLOT MOVE 0 C, \ ��� ����������
  R> LoadLibraryA DUP 0= IF -2009 THROW THEN \ ABORT" Library not found"
  R> SWAP GetProcAddress 0= IF -2010 THROW THEN \ ABORT" Procedure not found"
;

: EXTERN ( xt1 n -- xt2 )
  HERE
  SWAP LIT,
  ['] FORTH-INSTANCE> COMPILE,
  SWAP COMPILE,
  ['] <FORTH-INSTANCE COMPILE,
  RET,
;

: CALLBACK: ( xt n "name" -- )
\ ����� n � ������!
  EXTERN
  HEADER
  ['] _WNDPROC-CODE COMPILE,
  ,
;

: WNDPROC: ( xt "name" -- )
  4 CELLS CALLBACK:
;

: TASK ( xt1 -- xt2 )
  CELL EXTERN
  HERE SWAP
  ['] _WNDPROC-CODE COMPILE,
  ,
;
: TASK: ( xt "name" -- )
  TASK CONSTANT
;
VARIABLE ERASED-CNT

: ERASE-IMPORTS
  \ ��������� ������� ������������� ��������
  WINAPLINK
  BEGIN
    @ DUP
  WHILE
    DUP 3 CELLS - 0!
  REPEAT DROP
;