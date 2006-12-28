\ �������, ���� �� SPF
\ ��. http://forth.org.ru/~mlg/index.html#bacforth

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE >L ~profit/lib/lstack.f
REQUIRE { lib/ext/locals.f
REQUIRE (: ~yz/lib/inline.f

MODULE: bac4th
: ?PAIRS <> ABORT" unpaired" ;
: >RESOLVE2 ( dest -- ) HERE SWAP ! ;
: <RESOLVE ( org -- )	, ;


: CALL, ( ADDR -> ) \ �������������� ���������� ADDR CALL
  ?SET SetOP SetJP 0xE8 C,
  DUP IF DP @ CELL+ - THEN ,    DP @ TO LAST-HERE
;

12345 CONSTANT $TART
5432 CONSTANT 8ACK
4523 CONSTANT N0T
466736473 CONSTANT a99reg4te

: (ADR) R> DUP CELL+ >R ;

EXPORT

\ : ENTER POSTPONE EXECUTE ; IMMEDIATE ( \ ��� ���� �����, �� ��� �������?
: ENTER   >R ;                           \ )
\ �� ~profit/prog/forth-wizard/forth-wizard-depth-bac4th.f ������� ���.
\ �� ~profit/prog/forth-wizard/forth-wizard-width.f ��� maxOperations=10 � >R'�� -- 3:22, � EXECUTE -- 3:52

DEFINITIONS


: (NOT:)  R> RP@ >L  DUP @ >R CELL+ ENTER LDROP ;
: (-NOT)  L> RP! ;
: (-NOT2) R> L> RP! >R ;

EXPORT

: ONFALSE IF RDROP THEN ;
: ONTRUE 0= IF RDROP THEN ;

: PRO R> R> >L ENTER LDROP ;
: CONT L> >R R@ ENTER R> >L ;

\ ��������� ��������
: RESTB  ( n --> n  / n <--  ) R>  OVER >R  ENTER   R> ;
: 2RESTB ( d --> d  / d <--  ) R>  -ROT 2DUP 2>R ROT  ENTER   2R> ;
: BSWAP  ( a b <--> b a )      SWAP R> ENTER  SWAP ;
: SWAPB  ( a b <--> b a )      R> ENTER  SWAP ;
: BDROP  ( n <--> )            R>  SWAP >R  ENTER  R> ;
: DROPB  ( n --> n / <-- n )   R>  ENTER DROP ;
: 2DROPB ( n --> n / <-- n )   R>  ENTER 2DROP ;
: KEEP   ( addr --> / <-- )    R> SWAP DUP @  2>R ENTER 2R> SWAP ! ;
: B!     ( n addr --> / <-- )  R> OVER DUP @  2>R -ROT !  ENTER 2R> SWAP ! ;
: BC!    ( n addr --> / <-- )  R> OVER DUP C@ 2>R -ROT C!  ENTER 2R> SWAP C! ;


\ ������ �������� ��� ������ ( BACK .. TRACKING ), ���, ����� ������,
\ �������� ����� ������ ������������������ ������ ����� ������� �� ���� ���������
: BACK  ?COMP  0 CALL, >MARK 8ACK ;  IMMEDIATE
: TRACKING ?COMP  8ACK ?PAIRS  RET, >RESOLVE1 ;  IMMEDIATE
\ BACK ... TRACKING -- ��� ������ (: ... ;) >R , � ��������,
\ (: ... ;) -- ��� ������ BACK ... TRACKING R>

: START{ ( -- org dest $TART )
?COMP
0 RLIT, >MARK
<MARK $TART
; IMMEDIATE

: DIVE ?COMP
DUP $TART = IF OVER COMPILE, THEN
; IMMEDIATE


: }EMERGE
?COMP
$TART ?PAIRS DROP
RET,
>RESOLVE2
; IMMEDIATE

\ ������� ���������
: NOT:  ?COMP POSTPONE (NOT:) 0 ,  >MARK N0T ; IMMEDIATE
: -NOT  ?COMP N0T ?PAIRS POSTPONE (-NOT)  >RESOLVE2 ; IMMEDIATE

\ ��������, �������������� ������/�������� � ���������� ��������
: PREDICATE  ?COMP [COMPILE] NOT:  (: FALSE ;) RLIT, ; IMMEDIATE
: SUCCEEDS   ?COMP TRUE LIT, N0T ?PAIRS POSTPONE (-NOT2) >RESOLVE2 ; IMMEDIATE

\ ������� ��������, ���������� ����� ��� ��������� �������� ���������
: ALL [COMPILE] NOT: ; IMMEDIATE
: ARE [COMPILE] NOT: ; IMMEDIATE
\ ������-�� � mlg � �������� �������� ����������� OTHER ������ ��� (� ��������� ������� ������ ������� ������ ���� ��������):
\ : OTHER ?COMP  N0T ?PAIRS  >RESOLVE2 POSTPONE (-NOT) ; IMMEDIATE
\ �� ������ ���:
: OTHER [COMPILE] -NOT ;  IMMEDIATE
: WISE [COMPILE] -NOT ;  IMMEDIATE

\ ���������
: CUT:                           \ �������� ������ ����������� �����.
    R>  RP@ >L                   \ ���. ������� ����� �����.--> �� L-����
        BACK LDROP TRACKING      \ � ��� ������ - ������ ��� �������
    >R ;
: -CUT      R> L> RP! >R ;       \ ������ ����� �������� �� �������
: -NOCUT                         \ ������ �������, �� �� ����� ��������
    R>
      L> RP@ - >R                \ ��������� �������. ����� �������
      BACK R> RP@ + >L  TRACKING \ ������������ ��� ��� ������
    >R ;

\ ���� �����������
: *>   ?COMP  204  0 RLIT, >MARK  203 ;  IMMEDIATE
: <*>  ?COMP  203 ?PAIRS  0 RLIT, >MARK RET,  205 ROT
       >RESOLVE2  0 RLIT,  >MARK 203 ;  IMMEDIATE
: <*   ?COMP  203 ?PAIRS  0 RLIT, >MARK RET,  205 ROT
       >RESOLVE2  RET,  BEGIN  DUP 204 = 0= WHILE
       205 ?PAIRS  >RESOLVE2 REPEAT  DROP ; IMMEDIATE

\ ������� ��� ������� ���������, ��� ���������:
\ ��������� �������� ����������
\ ������� �������������� (������������, ������������ ���������� �������� ��� ���������)
\ ������� ������, ����� �������� � ���� R> ENTER

: agg{ ( -- ) ?COMP
POSTPONE (ADR) HERE 0 ,
POSTPONE !
0 RLIT, >MARK
a99reg4te ;

\ �� ����� ���������� �� ����� ������ ������ �������� ������� ���� ���-���������� � ���������� (��������, ����������������, �������� � �.�.)
: }agg { agg succ -- }
?COMP  a99reg4te ?PAIRS
OVER
LIT, agg COMPILE,
RET, >RESOLVE2
LIT, succ COMPILE, ;

: +{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }+ ?COMP ['] +! ['] @ }agg ; IMMEDIATE

: MAX{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }MAX ?COMP (: DUP @ ROT MAX SWAP !  ;) ['] @ }agg ; IMMEDIATE

: *{ ?COMP 1 LIT, agg{ ; IMMEDIATE
: }* ?COMP (: DUP @ ROT * SWAP !  ;) ['] @ }agg ; IMMEDIATE

: &{ ?COMP -1 LIT, agg{ ; IMMEDIATE
: }& ?COMP (: DUP @ ROT AND SWAP ! ;) ['] @ }agg ; IMMEDIATE

: |{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }| ?COMP (: DUP @ ROT OR SWAP ! ;) ['] @ }agg ; IMMEDIATE

\ ���� AMONG  ...  EACH  ...  ITERATE
\ ����������� ���:
\ (among) (among>) {addr} ... (each) ... (iterate) addr: ���_��_������
: (AMONG)
    R>                      \ ����� (AMONG>)
    BACK L> DROP TRACKING     \ ��� ������ ������ ��������� ������ ���������
    RP@ >L                  \ ��������� ������ ������ ���������
    DUP >R                  \ (AMONG>): ����� ����� ��� �������� ���������
    9 + >R ;                \ ������ (AMONG>) , ��������� ��������
\   ^-- ��-�-�! � ��� ������?.. ���� ������������� ����� CALL (AMONG>)

: (AMONG>)
    R>                      \ ����� ������ �� ��� �� ������
    L> RP@ - >R             \ ��������� ��������� ������ ������
    BACK R> RP@ + >L
         TRACKING           \ ������������ ��� ������
    @ >R ;                  \ �������� ���������� �� ��� �� ������

: (EACH)
    R>                      \ ����� ���� �����
    RP@ >L                  \ ����� ����� ����� ������ ���������
    BACK L> DROP            \ ��� ������ ������ ����� ����� ������
         L@ RP! TRACKING    \  � ���� ������ ���������
    >R ;                    \ �������� ���������� ���� �����

: (ITERATE)
    RDROP                   \ ������ ����� ����, ������������ �� ������
    L> L>                   \ ��������� �� ������ � ����� ������ ���������
    2DUP RP@ - >R RP@ - >R  \ ��������� ��������� ������ ���������
    BACK L> DROP            \ ������ ����� ��������� ������ ������ �
         R> RP@ + R> RP@ +  \ ������������ ������ ���������
             >L >L TRACKING \ ��� ������
    OVER -                  \ ����� ����� � ����� ������ ���������
    RP@ >L                  \ ����� ����� ������ ������ ���������
    RP@ OVER - RP!          \ ������� ����� �� ����� ���������
    RP@ SWAP MOVE           \ ����������� ������ ���������
;                           \ EXIT �������� ���������� ���������

: FINIS   RDROP L> >R BACK R> >L TRACKING L@ CELL- @ >R ;
: AMONG   ?COMP POSTPONE (AMONG) POSTPONE (AMONG>) 0 , >MARK 207 ; IMMEDIATE
: EACH    ?COMP 207 ?PAIRS POSTPONE (EACH) 208 ; IMMEDIATE
: ITERATE ?COMP 208 ?PAIRS POSTPONE (ITERATE) >RESOLVE2 ; IMMEDIATE

;MODULE

/TEST
\ REQUIRE SEE lib/ext/disasm.f
\ ���-�� ����� ��������� ���������� (��������� ��������, �� ���������� �����)...
VARIABLE a
VARIABLE b
: r
10 a B!
a @ 1+ b B!
CR ." r2.a=" a @ .
." r2.b=" b @ . ;

: r2
5 a B!
r
CR ." r.a=" a @ . ;

: locals
100 a !
r2
a @ CR ." a=" . ;

: bt ." back" BACK ." ing" TRACKING ." track" ;
: bt2 START{ ." back" }EMERGE ." tracking" ;

: INTSTO ( n <-->x ) PRO 0 DO I CONT DROP LOOP ; \ ���������� ����� �� 0 �� n-1
: 1-20 ( <-->x ) PRO 20 INTSTO CONT ; \ ����� ����� �� 1-�� �� 20-�
\ : 1-20  21 BEGIN DUP R@ ENTER DROP 1- ?DUP 0= UNTIL RDROP ;
: //2 PRO DUP 2 MOD ONFALSE CONT ; \ ���������� ������ ������ �����
: 1-20. 1-20 //2  DUP . ;
: 1-20X 1-20 ." X" ;
: 1-20X1-20x 1-20 1-20 ." X" ;

\ ������� ����������
: FACT  ( n -- x ) START{
DUP  2 < IF DROP 1 EXIT THEN
DUP  1- DIVE  * }EMERGE ;

: FACT ( n -- !n ) *{ INTSTO 1+ DUP }* ;

\ ������� ����� ���������
: FIB ( n -- f ) START{ DUP 3 < IF DROP 1 EXIT THEN DUP 1- DIVE SWAP 2 - DIVE + }EMERGE ;


: STACK  PRO  DEPTH 0  ?DO  DEPTH I - 1- PICK  CONT DROP LOOP ;  \ ����� ����
: STACK. STACK DUP . ;  \ �������� ����

\ ����� true ���� �� ����� *����* ����� ������ 10-�
: Estack>10 PREDICATE STACK DUP 10 > ONTRUE DROP SUCCEEDS ;
\ DROP ����� ONTRUE ����� ��� �������� ��������� �������� �� ���������� STACK, ����� �� ��� ���� ��������?
\ ����� ���������� � ������ CUT: � PREDICATE ������ �� ������ ��������� � ���� ������ ����?

\ ����� true ���� �� ����� *���* ����� ������ 10-�
: Astack>10 PREDICATE ALL STACK ARE DUP 10 > ONTRUE OTHER DROP WISE SUCCEEDS ;

: stack-sum ( x1 x2 ... xn -- x1 x2 ... xn sum  )
+{ STACK DUP }+ ;
\ ����� �������� �� �����

: stack-or |{ STACK DUP }| ;

: sempty NOT: STACK -NOT ." ���� ����" ;

: notF ( f -- ) NOT: DUP ONTRUE -NOT ." F" ; \ ���� f=false, �� ������� "F"
: notT ( f -- ) NOT: NOT: DUP ONTRUE -NOT -NOT ." T" ; \ ���� f=true, �� ������� "T"
: ps. ( f -- ) PREDICATE DUP ONTRUE SUCCEEDS . ; \ ������ ������� ���������� ��������
: pns. ( f -- ) PREDICATE NOT: DUP ONTRUE -NOT SUCCEEDS . ; \ ������� �������� ���������� ��������

: bool PRO *> TRUE <*> FALSE <* CONT DROP ;
: check bool *> CR DUP . ." notF=" notF <*> CR DUP . ." notT=" notT <*> CR DUP . ." ps.=" ps. <*> CR DUP . ." pns.=" pns. <* ;


: alter PRO
*> S" first" <*> S" second" <*
CR TYPE ;

: firstInAlter PRO CUT:
*> S" first" <*> S" second" <* -CUT
CR TYPE ;

\ ������� ���� ����������� ������������ AMONG  ...  EACH  ...  ITERATE
: SUBSETS
    AMONG   *> 1 <*> 2 <*> 5 <*   \ ��������� �� ����� �� ������� 1,2,5
    EACH    *> <*> DROP <*      \ ����� ������� � ���������, ����� ��� ����
                            \ DROP ������� ��-� ��������� �� �����
    ITERATE
        CR STACK. ;        \ ����������� ���� � ����� ������

\ ������� ���� �����������, �� ������ Dynamically Structured Codes
\ http://dec.bournemouth.ac.uk/forth/euro/ef99/gassanenko99b.pdf
: el  R@ ENTER DROP ;
: .{} CR ." { " DEPTH 0 ?DO I PICK COUNT TYPE SPACE LOOP ." } " ;
: subsets C" first" el C" second" el C" third" el .{} ;