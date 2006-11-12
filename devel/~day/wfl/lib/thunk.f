( ��� ���������� ������ ������ �������� ��������� windows �������� Hype.

* Thunk ��� �������� ������������-�������� - ����������.
* Thunk ��� ����������� ��� �������� Windows ��������� ����������� Hype2.
* Thunk ��� ���������� ��� ������� �������� ����������� � ������������ ������
* ������� ���������� ����� ��������������� ���� thunk.
* ������ wnd proc windows ����� ���������� ���������� thunk'�

������� ���������� ��� �������� Windows ��������� wnd proc:

Windows -> thunk -> hype object instance

�������� thunk:

1.  ������� ���� ����� � ����������� ��������� wndproc �� ���� �����
2.  ����� � ������� ���� �����
3.  ��������� ���� � Windows


thunk �� ����� ���� �����������, ������ ��� �� ������ ��������� ���������
���� thunk. )


USER DynP

: DHERE DynP @ ;
: DALLOT DynP +! ;

: CompileBranch ( addr-call code -- )
     DHERE SWAP
     OVER C!
     1+ TUCK CELL+ -
     SWAP !
     5 DALLOT
;

: CompileCall ( addr-call addr -- )
     0xE8 CompileBranch 
;

: CompileJmp ( addr-call addr -- )
     0xE9 CompileBranch
;

: CompileRet 
     0xC3 DHERE C! 
     1 DALLOT
;


\ ����������� DUP, mov eax, ##
: CompileLiteral ( n )
    0x89FC6D8D DHERE ! 4 DALLOT
    0x45 DHERE W! 2 DALLOT
    0xB8 DHERE C! 1 DALLOT
    DHERE ! CELL DALLOT
;

: LIT+ 
    11 +
;

: CALL+ 5 + ;

\ ����� �� ��������� ������ ��� ��� ����� � wndproc ���
 \ � ����� ����� ������������ ������� ����� ���� ��������� � �����������
  \ ��������� Windows ����� � ������������ ������������ ��� ������ ��� ������
   \ ����������


CLASS CWinBaseClass

\ Always the first field
  CELL PROPERTY threadUserData

;CLASS

WINAPI: HeapValidate     KERNEL32.DLL

: SendFromThunk ( lpar wpar msg hwnd obj n )
\ We can't fetch threadUserData without TlsIndex set, so lets apply a small hack
     OVER CELL+ @ ( threadUserData@ hack! ) TlsIndex!

     <SET-EXC-HANDLER>

     S0 @ >R
     SP@  + CELL+ S0 !

     ^ message

     R> S0 !
;

: ObjExtern ( xt1 n obj -- xt2 )
     DHERE
     SWAP CompileLiteral \ obj
     SWAP CompileLiteral  \ n
     SWAP CompileCall
     CompileRet
;


\ If HEAP_CREATE_ENABLE_EXECUTE is not specified and an application 
 \ attempts to run code from a protected page, the application receives 
  \ an exception

VARIABLE WFL-THUNK-HEAP

: INIT-WFL
  \ create executable heap for thunks
  0 4096 0x00040000 ( HEAP_CREATE_ENABLE_EXECUTE)
  HeapCreate WFL-THUNK-HEAP !
  InitCommonControls
;

..: AT-PROCESS-STARTING INIT-WFL ;..
INIT-WFL

: AllocExec ( n -- a-addr ior )
    CELL+ 0 WFL-THUNK-HEAP @ HeapAlloc
    DUP IF R@ OVER ! CELL+ 0 ELSE -300 THEN
;

: FreeExec ( a-addr -- ior )
    CELL- 0 WFL-THUNK-HEAP @ HeapFree ERR
;

WINAPI: FlushInstructionCache KERNEL32.DLL

: DynamicObjectWndProc ( obj -- xt-addr start-addr )
     64 AllocExec THROW DUP DynP ! >R
     ['] SendFromThunk SWAP
     4 CELLS
     CELL+ ( obj parameter )
     SWAP ObjExtern ( xt2 )
     DHERE SWAP
     ['] _WNDPROC-CODE CompileCall
     DHERE ! CELL DALLOT
     R>

     DUP 64 SWAP
     GetCurrentProcess FlushInstructionCache -WIN-THROW
;
