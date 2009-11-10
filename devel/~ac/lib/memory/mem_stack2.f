( "��������" ���������� �������.
  ���������������� ����� ALLOCATE, FREE � HEAP-COPY ��� �������
  ���������� [����� ��] ������ ���������� � ���� ������.

  �������������:

  MARK_MEM 
  ������ � �����
  FREE_MEM

  MARK_MEM ������������� "�������" � ����. 
  FREE_MEM ������� ��� ��������������� ���������� ����� ������ 
  �� ��������� �� ������� MARK_MEM. ��������� FREE_MEM ���������
  �� ������� ����������� MARK_MEM, � �.�. ���� ������� �� ����,
  �� FREE_MEM ����������� ��� ������, ���������� ������� � �������
  ����������� ���������� ��� � ������� ������������� MEM_STACK_PTR
  [��� ������ ������, ��������]

  ��� MEM_DEBUG ON ��������� ����������� ������������� ������.

  ������� �������������:

  : ������������
    ������ � �����
  ;
  ...
  ['] ������������ DROP_MEM


  ������ ������ MARK_MEM - FREE_MEM ����� ���������� ������� ����,
  ���������� ������� ������ �� ����� ������������� �����������.
  ��� ����������� ����������� ��� ����������� � ������������� �����������
  ���� �����, ������� ���� ������ �� ����� ������������.

  DISABLE_MEM_LAYOFF
  �������� ������������ ������ ������
  DISABLE_MEM_LAYOFF

  ������� �������������:

  : ��������������������������
    ������ � ������������ �������
  ;
  ...
  ['] �������������������������� SAVE_MEM

)

USER _NO_STACK_MEM

\ ��� ������� ��� ����� ������
: _MEM_MARKER ( -- u ) _NO_STACK_MEM @ IF 558 ELSE 557 THEN ;

WARNING @ WARNING 0!
: ALLOCATE ( u -- a-addr ior ) \ 94 MEMORY
\ ������������ u ���� ������������ ������������ ������. ��������� ������������ 
\ ������ �� ���������� ���� ���������. �������������� ���������� ����������� 
\ ������� ������ ������������.
\ ���� ������������� �������, a-addr - ����������� ����� ������ �������������� 
\ ������� � ior ����.
\ ���� �������� �� ������, a-addr �� ������������ ���������� ����� � ior - 
\ ��������� �� ���������� ��� �����-������.

\ SPF: ALLOCATE �������� ���� ������ ������ ����� �������� ������
\ ��� "��������� �����" (��������, �������� ������ ���������� �������)
\ �� ��������� ����������� ������� ���� ���������, ��������� ALLOCATE

  CELL+ 8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapAlloc
\  DUP IF 557 OVER ! CELL+ 0 ELSE -310 THEN
  DUP IF _MEM_MARKER OVER ! CELL+ 0 ELSE -310 THEN
;

: FREE ( a-addr -- ior ) \ 94 MEMORY
\ ������� ����������� ������� ������������ ������, ������������ a-addr, ������� 
\ ��� ����������� �������������. a-addr ������ ������������ ������� 
\ ������������ ������, ������� ����� ���� �������� �� ALLOCATE ��� RESIZE.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, ior ����. ���� �������� �� ������, ior - ��������� �� 
\ ���������� ��� �����-������.
  CELL- DUP @ DUP 557 <> SWAP 558 <> AND IF ." �������� ���" DROP 302 EXIT THEN
  DUP 0!
  0 THREAD-HEAP @ HeapFree ERR
;
: RESIZE ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
\ �������� ������������� ������������ ������������ ������, ������������� � 
\ ������ a-addr1, ����� ��������������� �� ALLOCATE ��� RESIZE, �� u ����.
\ u ����� ���� ������ ��� ������, ��� ������� ������ �������.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, a-addr2 - ����������� ����� ������ u ���� 
\ �������������� ������ � ior ����. a-addr2 �����, �� �� ������, ���� ��� �� 
\ �����, ��� � a-addr1. ���� ��� �����������, ��������, ������������ � ������� 
\ a-addr1, ���������� � a-addr2 � ���������� ������������ �� �������� ���� 
\ ���� ��������. ���� ��� ���������, ��������, ������������ � �������, 
\ ����������� �� ������������ �� u ��� ��������������� �������. ���� a-addr2 �� 
\ ��� ��, ��� � a-addr1, ������� ������ �� a-addr1 ������������ ������� 
\ �������� �������� FREE.
\ ���� �������� �� ������, a-addr2 ����� a-addr1, ������� ������ a-addr1 �� 
\ ����������, � ior - ��������� �� ���������� ��� �����-������.
\  CELL+ SWAP CELL- DUP @ 557 <> IF ." �������� ���" DROP 303 EXIT THEN
  CELL+ SWAP CELL- DUP @ DUP 557 <> SWAP 558 <> AND IF ." �������� ���" DROP 303 EXIT THEN
  DUP 0!
  8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapReAlloc
\  DUP IF 557 OVER ! CELL+ 0 ELSE -320 THEN
  DUP IF _MEM_MARKER OVER ! CELL+ 0 ELSE -320 THEN
;

USER MEM_STACK_PTR
USER MEM_STACK_SIZE
VARIABLE MEM_DEBUG

: STACK_MEM ( addr -- )
  3 CELLS ALLOCATE THROW >R
  ( addr ) R@ CELL+ !
  MEM_STACK_PTR @ R@ !
  R> MEM_STACK_PTR !
;
: ALLOCATE ( size -- addr ior )
  DUP MEM_STACK_SIZE +!
  DUP >R
  ALLOCATE DUP IF RDROP EXIT THEN
  OVER STACK_MEM
  R> MEM_STACK_PTR @ CELL+ CELL+ !
  MEM_DEBUG @
  IF
   ." <m"  OVER .
   ." (" R@ WordByAddr TYPE ." ):"
  THEN
;
: MS_FREE 
  MEM_DEBUG @
  IF
   ." :(" R@ WordByAddr TYPE ." )"
   SPACE DUP . ." M!>" CR
  THEN
  FREE
;

: FREE ( addr -- ior )
  MEM_DEBUG @
  IF
   ." :(" R@ WordByAddr TYPE ." <-" R> R@ WordByAddr TYPE >R ." )"
   SPACE DUP . ." m>" CR
  THEN
\  DUP CELL- @ 558 = IF FREE EXIT THEN \ ���� ���������� UNSTACK'��
  >R
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ R@ =
    IF R> FREE >R
       DUP @ CELL+ CELL+ @ MEM_STACK_SIZE @ SWAP - MEM_STACK_SIZE !
       DUP @ DUP >R @ SWAP ! \ ��������� �� ������ ������� ����.��������
       R> FREE THROW
       R> EXIT
    THEN
    @
  REPEAT DROP RDROP
  301 \ �������, ������� ������ ����������, �� ��� �������
;
: RESIZE ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
  MEM_DEBUG @
  IF
   ." :RS(" R@ WordByAddr TYPE ." )"
   SPACE OVER . ." m>" CR
  THEN
  >R >R
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ R@ =
    IF R>
       OVER @ CELL+ CELL+ @ \ ������ ������
         R@ SWAP - MEM_STACK_SIZE +!
       R@ RESIZE
       ROT @ >R
       OVER R@ CELL+ !          \ ����� �����
       R> CELL+ CELL+ R> SWAP ! \ ����� ������
       EXIT
    THEN
    @
  REPEAT DROP R> RDROP
  301 \ �������, ������ �������� ������ ��������, �� ��� �������
;
: UNSTACK ( addr -- ior ) \ ������ ������� addr ��-��� �������� MEM_STACK
\ � ������� ���������� ������� ������� ��� ���������, �� �� ��������� ��� �������� �������
  MEM_DEBUG @
  IF
   ." :u(" R@ WordByAddr TYPE ." <-" R> R@ WordByAddr TYPE >R ." )u"
   SPACE DUP . ." m>" CR
  THEN
  >R
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ R@ =
    (	�� ������ ���� �� ���������, ������ ������ �������
    IF \ R> FREE >R \ ����������� addr �� �����, ������ ��������� �� ������
       558 R> CELL- ! 0 >R

       DUP @ DUP >R @ SWAP ! \ ��������� �� ������ ������� ����.��������
       R> MS_FREE THROW
       R> EXIT
    THEN
    )
    IF 558 R> CELL- ! 0 EXIT THEN	\ ��������� ��� ����������
    @
  REPEAT DROP RDROP
  304 \ �������, ������� ������ ���������, �� ��� �������
;
: HEAP-COPY ( addr u -- addr1 ) \ ���������� ������, �.�. ����� ��������������
\ ����������� ������ � ��� � ������� � ����� � ����
  DUP 0< IF 8 THROW THEN
  DUP 1+ ALLOCATE THROW DUP >R
  SWAP DUP >R MOVE
  0 R> R@ + C! R>
;
: MARK_MEM ( -- )
  73 STACK_MEM
;
( ���������� ���� - � ������ ������� ����������� ��������� �����
: FREE_MEM 
  MEM_STACK_PTR @
  BEGIN
    DUP
  WHILE
    DUP CELL+ @ 73 = \ �������� �������?
    IF DUP @ MEM_STACK_PTR ! MS_FREE THROW EXIT THEN
    \ �� �������� - ����������� ������� � ����������
    DUP CELL+ @ MS_FREE THROW
    DUP @ SWAP MS_FREE THROW
  REPEAT \ ���������� ���� ������, �� �� ����� �������!
  MEM_STACK_PTR !
;
)
: FREE_MEM ( -- )
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ DUP 73 =		\ �������� �������?
    IF
      DROP DUP @ DUP >R @ SWAP !	\ ��������� �� ������ ������� ����.��������
      R> MS_FREE THROW			\ ���������� ����������� ����
      EXIT				\ � ���������
    THEN
    DUP CELL- @ 557 =			\ ���� ���� ���������?
    IF
      MS_FREE THROW			\ �� - �������
      DUP DUP @ DUP >R @ SWAP !		\ ��������� �� ������ ������� ����.��������
      R> MS_FREE THROW			\ ���������� ����������� ����
    ELSE
      DROP @				\ ��� - ������ ������� � ���������� �����
    THEN
  REPEAT \ ���������� ���� ������, �� �� ����� �������!
  @ MEM_STACK_PTR !
;
: FREE_MEM_EXCEPT ( addr -- ) \ ���������� �� ����� ��������, ����������� ��������� �����
  >R MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ DUP 73 =		\ �������� �������?
    IF
      DROP DUP @ DUP >R @ SWAP !	\ ��������� �� ������ ������� ����.��������
      R> MS_FREE THROW			\ ���������� ����������� ����
      RDROP
      EXIT				\ � ���������
    THEN
    DUP CELL- @ 557 =			\ ���� ���� ���������?
    IF
      OVER @ DUP CELL+ @ SWAP CELL+ CELL+ @ ( 2DUP TYPE CR) OVER + R@ ROT ROT WITHIN
      IF DROP @
      ELSE
      MS_FREE THROW			\ �� - �������
      DUP DUP @ DUP >R @ SWAP !		\ ��������� �� ������ ������� ����.��������
      R> MS_FREE THROW			\ ���������� ����������� ����
      THEN
    ELSE
      DROP @				\ ��� - ������ ������� � ���������� �����
    THEN
  REPEAT \ ���������� ���� ������, �� �� ����� �������!
  @ MEM_STACK_PTR !
  RDROP
;
: DUMP_MEM ( -- )
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @
        DUP CELL+ ." a=" @ .
            CELL+ CELL+ @ ." s=" . CR
    @
  REPEAT
  DROP
." DUMP_MEM_OK" CR
;

\ TRUE MEM_DEBUG !
WARNING !

\ ���������� ����������� �� �������� ������� ������
: ENABLE_MEM_LAYOFF _NO_STACK_MEM 0! ;
: DISABLE_MEM_LAYOFF TRUE _NO_STACK_MEM ! ;

\ �����-������ ��� ����� ����������� ������������ ������� ��������
\ DROP_MEM - ��������� ��������� xt � ����������� �������� ������� ������ � ��������� �� ��� ���������� ������������ ������
: DROP_MEM ( xt -- )
  MARK_MEM				\ ��������� ������
  _NO_STACK_MEM DUP @ >R 0!		\ ��������� �������� ������
  CATCH					\ ��������� � ���������� ������
  R> _NO_STACK_MEM !			\ ������� ��������� �����
  FREE_MEM				\ ��������� ���������� ������
  THROW					\ � ������� ������
;

\ SAVE_MEM - ��������� ��������� xt � �������� �������� ������� ������
: SAVE_MEM ( xt -- )
  TRUE _NO_STACK_MEM DUP @ >R !		\ ��������� �������� ������
  CATCH					\ ��������� � ���������� ������
  R> _NO_STACK_MEM !			\ ������� ��������� �����
  THROW					\ � ������� ������
;

\EOF
1000 ALLOCATE THROW
MEM_STACK_PTR @ .
MARK_MEM MEM_STACK_PTR @ .
1000 ALLOCATE THROW DROP
1000 ALLOCATE THROW DROP
1000 ALLOCATE THROW  2000 RESIZE THROW
1000 ALLOCATE THROW DROP
1000 ALLOCATE THROW DROP
DUMP_MEM
MEM_STACK_PTR @ .
DUP 1000 + FREE_MEM_EXCEPT

DUMP_MEM
MEM_STACK_PTR @ .
1000 ALLOCATE THROW FREE THROW
MEM_STACK_PTR @ .
FREE THROW
MEM_STACK_PTR @ .
FREE THROW
MEM_STACK_PTR @ .
DUMP_MEM
