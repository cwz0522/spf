( 
    ������ ����� ��������� �� ����������� ������ ������ � SPF4
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ��������� � SPF4 ���� ������ � ���� ��������� ������������� �
  ����� �������� ������������ ����� ��������� ������������ �������,
  �� ���������� ��������� ����� ����� ��������� ������������� ������ 
  ������. 
    ��������� �������� ���� ��������� �� ����� ������ 
  ���������� ������ ����������� ������ ��. 
    � ����� ������������� ���������� ����� ������ � ������ ������������ 
  �����, ���������� �������� � ContextRecord �� ����� ���������� 
  "0xC0000005L ACCESS_VIOLATION".

     � SPF4 ���� ����� ����� ���:
  xxxxFFFF-StackReserved   --- ����. ������� ����� ����������������� ��.
                           } ���� ��������� [���-�� ����� RP@]
  xxxxFFFF-r-ST_RES        --- R0 @ = [*]
                           } ���� ������ [���-�� ����� SP@]
  xxxxFFFF-r               --- S0 @ =
                           } ���� �������� ��� callback
  xxxxFFFF                 --- ��� �����

    ����� ��������� stack-guard.f ���� ����� ����� ���:
  xxxxFFFF-StackReserved   --- ����. ������� ����� ����������������� ��.
                           } ���� ��������� [���-�� ����� RP@]
  xxxxFFFF-r-ST_RES        --- R0 @ =
                           } �������������� ������� ��-�� ������������ �� PAGE-SIZE
  xxxxFFFF-r-ST_RES+unused --- ���������� "SP-PROTECTED" �������� ����� �������,
                               ������� �������� �� 4��.  
                           } ������� ���������� � ������� VirtualProtect/PAGE_READONLY
                             [READONLY � ����� ����������, ���� ��������
                             ���� �������� �� ����������� � ������������ 
                             �������� ������ -3.]
  xxxxFFFF-r-ST_RES+unused+PAGE_SIZE --- ����. ������� ����� ������.
                           } ���� ������ [���-�� ����� SP@]
  xxxxFFFF-r               --- S0 @ =
                           } ���� �������� ��� callback
  xxxxFFFF                 --- ��� �����

    [*] � ���������� ������ ������ '-' ������ �� '_', 
        ���� �� ���������� � ����������.

  ��������� ������ [mailto:ss@forth.org.ru]
  2006.02.15
  PS: ������, � ������ �� ���������� ����� �����? 

    �������
    ~~~~~~~
  2006.02.16 
  ~~~~~~~~~~
    ���������� ��� Win98. ������-�� ������������ PAGE_NOACCESS.
  ����� ���������������� PAGE_READONLY.
    �������������: ��������� ��� Win98 ���� PAGE_GUARD, �� ���� �� 
  ������������� PAGE_NOACCESS � ��� ��������� � "SP-PROTECTED"
  ������ ��� ����� ����������� ����. [1,2]
    �������������, ����� ��������� � ���������� �������� � ������ 
  ����� ���������� PAGE_READWRITE. ;( ���� ���������� ���������� 
  PAGE_GUARD+PAGE_READWRITE �� �����, �� WindowsXP ���� ���� ����������.
  [� PAGE_GUARD+PAGE_READONLY ����� "0xC0000005L ACCESS_VIOLATION"]
    ���� ��������� ��� ��������� �� C � ����������� ��� Win98 � WinXP:
  http://forth.org.ru/~ss/stack-guard-test.zip
  http://bookmania.com.ru/stack-guard-test.zip
    
    ����������
    ~~~~~~~~~~
  [1] MSDN "Thread Stack Size" 
      http://msdn.microsoft.com/library/en-us/dllproc/base/thread_stack_size.asp
  [2] ��� ������ ��� PAGE_GUARD, EXCEPTION_GUARD_PAGE  � ����.
      ��������, "��� ��������� ����?" http://www.rsdn.ru/article/baseserv/stack.xml#EBPA
)

WINAPI: VirtualProtect  KERNEL32.DLL 
\ BOOL VirtualProtect(
\   LPVOID lpAddress,       // region of committed pages
\   SIZE_T dwSize,          // size of the region
\   DWORD flNewProtect,     // desired access protection
\   PDWORD lpflOldProtect   // old protection
\ );

0x1000 CONSTANT PAGE-SIZE
1 CONSTANT PAGE_NOACCESS
2 CONSTANT PAGE_READONLY
0x100 CONSTANT PAGE_GUARD

: VIRTUAL-PROTECT-PAGE ( addr new-prot -- old-prot 0|err )
  2>R 
  0 SP@ R> PAGE-SIZE R> VirtualProtect 
  0= IF DROP GetLastError  ELSE 0 THEN 
;

USER-VALUE SP-PROTECTED    \ ����� ���������� �������� ����� � ������� ������
USER-VALUE SP-OLD-PROTECT  \ �������� ���� ������

: xTHROW ?DUP IF >R 0 @ THEN ; \ ������� THROW �� �����������
                               \ ���������� ������ PAGE_READONLY - PAGE_GUARD
                               \ � ����� ������� THROW 
                               \ � �������, ������� THROW � AT-THREAD-FINISHING

: PROTECT-RETURN-STACK
  R0 @ PAGE-SIZE + PAGE-SIZE / PAGE-SIZE * DUP TO SP-PROTECTED
  ." Protecting at "  DUP HEX . DECIMAL CR
  ." Unused stack space: " SP-PROTECTED R0 @ - . ." bytes" CR
  PAGE_READONLY VIRTUAL-PROTECT-PAGE xTHROW TO SP-OLD-PROTECT \ . . OK
  ." Old protection: " SP-OLD-PROTECT . CR
;

: EXC-DUMP-20060215 ( exc-info -- ) 
  \ ����� ���������� ��������� � ������ ������������ �����.
  IN-EXCEPTION @ IF DROP EXIT THEN
  TRUE IN-EXCEPTION !
  \ ������ ContextRecord->Ebp
  3 PICK 180 + @ SP-PROTECTED PAGE-SIZE + = IF -3 OVER ! ( ������������ �����) THEN
  3 PICK 180 + @ S0 @ > IF -4 OVER ! ( ���������� �����) THEN
  \ ������ ContextRecord->Esp
  3 PICK 196 + @ R0 @ > IF -6 OVER ! ( ���������� ����� ���������!) THEN
  \ 3 PICK 196 + @ S0 @ 0x100000 < IF -5 OVER ! ( ������������ ����� ���������) THEN
  FALSE IN-EXCEPTION !
  [ ' <EXC-DUMP> BEHAVIOR BRANCH, ]
;
' EXC-DUMP-20060215 TO <EXC-DUMP>
 
..: AT-THREAD-STARTING SP-PROTECTED 0= IF PROTECT-RETURN-STACK THEN ;..
..: AT-PROCESS-STARTING PROTECT-RETURN-STACK ;..
..: AT-THREAD-FINISHING
    SP-PROTECTED SP-OLD-PROTECT VIRTUAL-PROTECT-PAGE xTHROW DROP ;.. 
\ ST-RES �������� ����� �� ����� ����-����� � ������
\ ��� ���� CALLBACK:
0x7000 ST-RES ! \ ������ (PAGE-SIZE*3) ������.
                \ ������ 0x8000 ������ (��. StackCommitSize � spf-stub.f, [1])

\ � ���� ������������� �� �������� ����� ����� ������� SAVE
\ S" spf4_guarded.exe" SAVE
\ � ����������:
\  spf4_guarded.exe : tt 10000 0 DO I LOOP ; tt
\                                            ^  -3 ������������ �����

\EOF

: sp-pre-overflow
  HEX 
  0x5F00 CELL /  0 DO I LOOP 
  SP@ .
  0x5F00 CELL /  0 DO DROP LOOP 
;
: sp-overflow
  HEX 
  0x7000 CELL /  0 DO I LOOP 
  SP@ .
  0x7000 CELL /  0 DO DROP LOOP 
;

:NONAME
  10 PAUSE
  100000 MIN
  DUP RALLOT DROP RFREE 
  S0 @ R0 @ - . CR
  ." S0-R0=" S0 @ R0 @ - . CR
  HEX
  ." SP@=" SP@ . CR
  ." S0=" S0 @ . CR
  ." RP@="  RP@ . CR
  ." R0="  R0 @ . CR
  DECIMAL
  sp-pre-overflow
  \ sp-overflow 
  \ SP-PROTECTED DUP HEX .  @ .
  1 PAUSE
  ." task done." OK
  0 
; 
TASK: test
.( S0-R0=) S0 @ R0 @ - . .( ST-RES=) ST-RES @ . CR
123 test START 150 PAUSE CloseHandle DROP CR OK \ QUIT
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
123 test START 0 PAUSE CloseHandle DROP CR OK 
123 test START 1 PAUSE CloseHandle DROP CR OK 
: stress-test
  60 2 * 150 *  0 DO  
    I 10 + test START CloseHandle DROP
    I 150 UMOD 0= IF 
      500 PAUSE 
      ." ===========================================" CR
    THEN
  LOOP
;
stress-test
1000 PAUSE
OK
BYE
\EOF

: sp-overflow1
  ST-RES @ CELL / 10 + 0 DO I LOOP 
;
: test
  sp-overflow1
  ." good!"
;
test
DEPTH .
