( ���������� � Windows - ����������� � ������� ������������� 
  ������� Windows � �������������� ������� [callback, wndproc � �.�.]
  Windows-��������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

VARIABLE WINAP
VARIABLE WINAPLINK

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
  >IN @
  HEADER
  >IN !
  ['] _WINAPI-CODE COMPILE,
  HERE WINAP !
  0 , \ address of winproc
  0 , \ address of library name
  0 , \ address of function name
\  0 , \ # of parameters
  HERE WINAPLINK @ , WINAPLINK ! ( ����� )
  HERE WINAP @ CELL+ CELL+ !
  HERE >R
  NextWord HERE SWAP DUP ALLOT MOVE 0 C, \ ��� �������
  HERE WINAP @ CELL+ !
  HERE >R
  NextWord HERE SWAP DUP ALLOT MOVE 0 C, \ ��� ����������
  R> LoadLibraryA DUP 0= IF -2009 THROW THEN \ ABORT" Library not found"
  R> SWAP GetProcAddress 0= IF -2010 THROW THEN \ ABORT" Procedure not found"
;

: EXTERN ( xt1 -- xt2 )
  HERE
  ['] FORTH-INSTANCE> COMPILE,
  SWAP COMPILE,
  ['] <FORTH-INSTANCE COMPILE,
  RET,
;
: WNDPROC: ( xt "name" -- )
  EXTERN
  HEADER
  ['] _WNDPROC-CODE COMPILE,
  ,
;
: TASK ( xt1 -- xt2 )
  EXTERN
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
