( ���������� ������� � ������� Windows Portable Executable.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  ������� - �������� 1999
)

( HERE �� ������ ������ ����������)
DECIMAL
DUP        VALUE ORG-ADDR      \ ����� ���������� ����
DUP        VALUE IMAGE-BEGIN   \ ����� �������� ����
512 1024 * VALUE IMAGE-SIZE    \ ������� ����� ������������� ��� 
                               \ �������� ������ ����
DUP 8 1024 * - CONSTANT IMAGE-BASE \ ����� �������� ������ ������

FALSE VALUE ?GUI
FALSE VALUE ?CONSOLE

VARIABLE RESOURCES-RVA
VARIABLE RESOURCES-SIZE

HEX

: SAVE ( c-addr u -- ) \ �������� S" My Forth Program.exe" SAVE
  ( ���������� ������������ ����-������� � EXE-����� ������� PE - Win32 )
  ERASED-CNT 0!
  R/W CREATE-FILE THROW >R
  ModuleName R/O OPEN-FILE-SHARED THROW >R
  HERE 400 R@ READ-FILE THROW 400 < THROW
  R> CLOSE-FILE THROW
  ?GUI IF 2 ELSE 3 THEN HERE 0DC + C!
  2000    HERE A8 +  ! ( EntryPointRVA )
  IMAGE-BEGIN 2000 -  HERE B4 +  ! ( ImageBase )
  IMAGE-SIZE 2000 +
          HERE D0 +  ! ( ImageSize )
  IMAGE-SIZE
          HERE 1A8 + ! ( VirtualSize )
  HERE IMAGE-BEGIN -  1FF + 200 / 200 *
          HERE 1B0 + ! ( PhisicalSize )

  RESOURCES-RVA @ HERE 108 + !
  RESOURCES-SIZE @ HERE 10C + !

  HERE 400 R@ WRITE-FILE THROW ( ��������� � ������� ������� )
  HERE 200 ERASE
  IMAGE-BEGIN HERE OVER - 1FF + 200 / 200 * R@ WRITE-FILE THROW
  R> CLOSE-FILE THROW
;
DECIMAL

: OPTIONS ( -> ) \ ���������������� ��������� ������
  TIB #TIB @ HEAP-COPY >R #TIB @ >R
  SOURCE-ID >R >IN @ >R
  GetCommandLineA ASCIIZ>
  TIB SWAP C/L MIN DUP #TIB ! QCMOVE >IN 0!
  TIB C@ [CHAR] " = IF [CHAR] " ELSE BL THEN
  WORD DROP \ ��� ���������
  <PRE> ['] INTERPRET CATCH ?DUP IF ERROR THEN
  R> >IN ! R> TO SOURCE-ID R> DUP #TIB !
  R@ TIB ROT QCMOVE R> FREE THROW
;