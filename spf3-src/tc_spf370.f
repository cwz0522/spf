( ������� ���������� ��� ���������� SP-Forth v3.7x
  Copyright [C] 1992-2000 A.Cherezov ac@forth.org
)


HEX IMAGE-BASE 1034 + CONSTANT AddrOfLoadLibrary      \ ������ �������� � spf-stub.exe
    IMAGE-BASE 1038 + CONSTANT AddrOfGetProcAddress
DECIMAL

: LOAD-VERSION ( -- n )
  S" VERSION.SPF" ['] INCLUDED CATCH IF 2DROP 375000 THEN
;
: SAVE-VERSION ( n -- )
  H-STDOUT >R
  S" VERSION.SPF" R/W CREATE-FILE THROW TO H-STDOUT
  . CR
  H-STDOUT CLOSE-FILE THROW
  R> TO H-STDOUT
;
VOCABULARY TC-WL
VARIABLE SAVED-CURRENT

: [T] GET-CURRENT SAVED-CURRENT ! ALSO TC-WL DEFINITIONS ;
: [I] PREVIOUS    SAVED-CURRENT @ SET-CURRENT ;

0 VALUE CREATE-CODE
0 VALUE CONSTANT-CODE
0 VALUE TOVALUE-CODE
0 VALUE VECT-CODE
0 VALUE NOOP-CODE
0 VALUE ---CODE
0 VALUE SLITERAL-CODE
0 VALUE CLITERAL-CODE
0 VALUE USER-CODE
0 VALUE (.")-CODE
0 VALUE USER-VALUE-CODE
0 VALUE TOUSER-VALUE-CODE

0 VALUE WINAPI-CODE
0 VALUE WNDPROC-CODE
0 VALUE TC-FORTH-INSTANCE>
0 VALUE TC-<FORTH-INSTANCE
0 VALUE TC-RDROP

VARIABLE TC-WINAP
VARIABLE TC-WINAPLINK
VARIABLE TC-USER-OFFS 16 TC-USER-OFFS ! \ 16 ���� ���������������

: TC-USER-ALLOT ( n -- )
  TC-USER-OFFS +!
;
: TC-USER-HERE ( -- n )
  TC-USER-OFFS @
;
HEX
: TC-CALL, ( addr -- )
  \ ��� ������������� ����� ����� � ��-����� 3.x
  0E8 C,              \ �������� ������� CALL
  HERE CELL+ - ,
;
DECIMAL

VOCABULARY TC     \ �����, ���������� � ������ ������������� ��� ��
VOCABULARY TC-IMM \ immediate-����� ��� ������ ���������� ��� ��,
                  \ �������� � ��������� �������, �.�. �� ������
                  \ �������������� ������� �� TC-WL
ALSO TC DEFINITIONS PREVIOUS

: CODE [T] CODE CONTEXT @ [I] CONTEXT ! ;

: CREATE ( "<spaces>name" -- ) \ 94
  [T] HEADER [I]
  CREATE-CODE COMPILE,
;
: VARIABLE ( "<spaces>name" -- ) \ 94
  [T] HEADER [I]
  CREATE-CODE COMPILE,
  0 ,
;
: ->VARIABLE ( x "<spaces>name" -- ) \ 94
  [T] HEADER [I]
  CREATE-CODE COMPILE,
  ,
;
: USER ( "<spaces>name" -- ) \ ��������� ���������� ������
  [T] HEADER [I]
  USER-CODE COMPILE,
  TC-USER-HERE ,
  4 TC-USER-ALLOT
;
: USER-CREATE ( "<spaces>name" -- )
  [T] HEADER [I]
  USER-CODE COMPILE,
  TC-USER-HERE ,
;
: CONSTANT ( x "<spaces>name" -- ) \ 94
  [T] HEADER [I]
  CONSTANT-CODE COMPILE, ,
;
: VALUE ( x "<spaces>name" -- ) \ 94 CORE EXT
  [T] HEADER [I]
  CONSTANT-CODE COMPILE, ,
  TOVALUE-CODE COMPILE,
;
: USER-VALUE ( "<spaces>name" -- ) \ 94 CORE EXT
  [T] HEADER [I]
  USER-VALUE-CODE COMPILE,
  TC-USER-HERE ,
  4 TC-USER-ALLOT
  TOUSER-VALUE-CODE COMPILE,
;
: VECT ( -> )
  [T] HEADER [I]
  VECT-CODE COMPILE, NOOP-CODE ,
  TOVALUE-CODE COMPILE,
;
: ->VECT ( x -> )
  [T] HEADER [I]
  VECT-CODE COMPILE, ,
  TOVALUE-CODE COMPILE,
;

: --
  [T] HEADER [I]
  ---CODE COMPILE,
  OVER , +
;


: WINAPI: ( "������������" "�������������" -- )
  >IN @
  [T] HEADER [I]
  >IN !
  WINAPI-CODE COMPILE,
  HERE TC-WINAP !
  0 , \ address of winproc
  0 , \ address of library name
  0 , \ address of function name
\  0 , \ # of parameters
  HERE TC-WINAPLINK @ , TC-WINAPLINK ! ( ����� )
  HERE TC-WINAP @ CELL+ CELL+ !
  HERE >R
  BL WORD COUNT HERE SWAP DUP ALLOT MOVE 0 C, \ ��� �������
  HERE TC-WINAP @ CELL+ !
  HERE >R
  BL WORD COUNT HERE SWAP DUP ALLOT MOVE 0 C, \ ��� ����������
  R> LoadLibraryA DUP 0= ABORT" Library not found"
  R> SWAP GetProcAddress 0= ABORT" Procedure not found"
;
: WNDPROC: ( xt "name" -- )
  HERE
  TC-FORTH-INSTANCE> COMPILE,
  SWAP COMPILE,
  TC-<FORTH-INSTANCE COMPILE,
  RET,
  [T] HEADER [I]
  WNDPROC-CODE COMPILE,
  ,
;
: ' ALSO TC-WL ' PREVIOUS ;
: (TO) ALSO TC-WL POSTPONE TO PREVIOUS ;

: TC-LATEST->
  ALSO TC-WL CONTEXT @ @ ' EXECUTE ! PREVIOUS
;

: IMMEDIATE [T] IMMEDIATE [I] ;

: :  [T] : ALSO TC-IMM ;

(
 �� ����� ���������� "�������������" ����������� � �� ������� ������
 ������������ ����� ����� �����:

  TC-IMM    \ imm-����� ����������, ������� ������ ��������������
  TC-WL     \ ����������� ������� ������ ����, �� �� � CURRENT
  TC        \ ������� ������������ ���� �� - ":", CREATE, CONSTANT, etc
  FORTH     \ �������� ������� ���������������� ����-�������
)

ALSO TC-IMM DEFINITIONS PREVIOUS

: ."
  CLITERAL-CODE COMPILE,
  [CHAR] " PARSE DUP C,
  HERE SWAP DUP ALLOT MOVE 0 C,
  (.")-CODE COMPILE,
; IMMEDIATE

: SLITERAL  \ 94 STRING
  STATE @ IF
             SLITERAL-CODE COMPILE,
             DUP C,
             HERE SWAP DUP ALLOT MOVE 0 C,
          ELSE
             2DUP + 0 SWAP C!
          THEN
; IMMEDIATE

: S"   \ 94+FILE
  [CHAR] " PARSE [ ALSO TC-IMM ] [COMPILE] SLITERAL [ PREVIOUS ]
; IMMEDIATE

: C"   \ 94 CORE EXT
  [CHAR] " WORD DUP COUNT NIP 1+
  DUP ALLOCATE THROW DUP >R SWAP CMOVE R>   \ WORD ����� ������ � HERE :(
  STATE @
  IF DUP [COMPILE] CLITERAL FREE THROW THEN
; IMMEDIATE

: ;  PREVIOUS [I] POSTPONE ; ; IMMEDIATE

: ['] ALSO TC-WL POSTPONE ['] PREVIOUS ; IMMEDIATE

: TO ALSO TC-WL POSTPONE TO PREVIOUS ; IMMEDIATE
: POSTPONE ALSO TC-WL POSTPONE POSTPONE PREVIOUS ; IMMEDIATE

: [COMPILE]  \ 94 CORE EXT
  ALSO TC-WL ' PREVIOUS
  COMPILE,
; IMMEDIATE

\ ���� ������ ����� ���� �� FORTH

: \ POSTPONE \ ; IMMEDIATE
: ( POSTPONE ( ; IMMEDIATE
: [ POSTPONE [ ; IMMEDIATE
: EXIT RET, ; IMMEDIATE
: [CHAR] POSTPONE [CHAR] ; IMMEDIATE

: IF POSTPONE IF ; IMMEDIATE
: ELSE POSTPONE ELSE ; IMMEDIATE
: THEN POSTPONE THEN ; IMMEDIATE
: BEGIN POSTPONE BEGIN ; IMMEDIATE
: WHILE POSTPONE WHILE ; IMMEDIATE
: REPEAT POSTPONE REPEAT ; IMMEDIATE
: AGAIN POSTPONE AGAIN ; IMMEDIATE
: UNTIL POSTPONE UNTIL ; IMMEDIATE
: RECURSE POSTPONE RECURSE ; IMMEDIATE

: DO POSTPONE DO ; IMMEDIATE
: ?DO POSTPONE ?DO ; IMMEDIATE
: LOOP POSTPONE LOOP ; IMMEDIATE
: +LOOP POSTPONE +LOOP ; IMMEDIATE
: I POSTPONE I ; IMMEDIATE
: J POSTPONE J ; IMMEDIATE
: UNLOOP  \ 94
  3 0 DO TC-RDROP COMPILE, LOOP
; IMMEDIATE

: LEAVE POSTPONE LEAVE ; IMMEDIATE

HEX
HERE 10000 + 10000 / 10000 * 2000 + DP !    \ ������������
DECIMAL

\ *** �������! ***
ONLY FORTH DEFINITIONS ALSO TC
