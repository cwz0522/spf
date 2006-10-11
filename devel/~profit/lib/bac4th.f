REQUIRE >L ~profit/lib/lstack.f
REQUIRE { lib/ext/locals.f
REQUIRE (: ~yz/lib/inline.f

MODULE: bac4th
: ?PAIRS <> ABORT" unpaired" ;
: >RESOLVE2 ( dest -- ) HERE SWAP ! ;

12345 CONSTANT $TART
5432 CONSTANT 8ACK
4523 CONSTANT N0T
466736473 CONSTANT a99reg4te
411 CONSTANT 4ll
473 CONSTANT 4r3
07437 CONSTANT 07her


: (ADR) R> DUP CELL+ >R ;

: (NOT:)  R> RP@ >L  DUP @ >R  CELL+ >R ;
: (-NOT)  L> RP! ;

EXPORT

: ENTER EXECUTE ; ( \ ��� ���� �����, �� ��� �������?
: ENTER   >R ;        \ )


: ONFALSE IF RDROP THEN ;
: ONTRUE 0= IF RDROP THEN ;

: PRO R> R> >L ENTER LDROP ;
: CONT L> >R R@ ENTER R> >L ;

\ ��������� ��������
: RESTB  R>  OVER >R  ENTER   R> ;
: 2RESTB R>  -ROT 2DUP 2>R ROT  ENTER   2R> ;
: SWAPB  R> ENTER  SWAP ;
: BDROP  R>  SWAP >R  ENTER  R> ;
: B!   R> OVER DUP @  SWAP 2>R -ROT !  ENTER 2R> ! ;
: BC!   R> OVER DUP C@ SWAP 2>R -ROT C!  ENTER 2R> C! ;


: START ( -- org dest $TART )
?COMP
0 RLIT, >MARK
<MARK $TART
; IMMEDIATE

\ ��� DIVE ���� ��� ��������...

: EMERGE
?COMP
$TART ?PAIRS DROP
RET,
>RESOLVE2
; IMMEDIATE

\ ������ �������� ��� ������ ( BACK .. TRACKING ), ���, ����� ������,
\ �������� ����� ������ ������������������ ������ ����� ������� �� ���� ���������
: BACK  ?COMP  0 RLIT, >MARK POSTPONE R> POSTPONE EXECUTE  8ACK ;  IMMEDIATE
: TRACKING ?COMP 8ACK ?PAIRS  RET, >RESOLVE2 ;  IMMEDIATE

\ ���������
: NOT:  ?COMP POSTPONE (NOT:) 0 ,  >MARK N0T ; IMMEDIATE
: -NOT  ?COMP N0T ?PAIRS POSTPONE (-NOT)  >RESOLVE2 ; IMMEDIATE

\ ��������, �������������� ������/�������� � ���������� ��������
: PREDICATE  ?COMP [COMPILE] NOT:  (: FALSE ;) RLIT, ; IMMEDIATE
: SUCCEEDS   ?COMP TRUE LIT, [COMPILE] -NOT ; IMMEDIATE

\ ���������
: CUT:   R>   RP@ >L   BACK L> DROP TRACKING   >R ;
: -CUT   R>   L> RP!   >R ;
: -NOCUT R>   L> RP@ - >R
BACK R> RP@ + >L  TRACKING
>R ;

\ : ALL ?COMP POSTPONE (NOT:) 0 ,  >MARK 4ll  ; IMMEDIATE
\ : ARE ?COMP 4ll ?PAIRS POSTPONE (NOT:) 0 ,  >MARK 4r3 ; IMMEDIATE
\ : OTHER ?COMP 4r3 ?PAIRS POSTPONE (-NOT) SWAP >RESOLVE2 07her ; IMMEDIATE
\ : WISE ?COMP 07her ?PAIRS POSTPONE (-NOT) >RESOLVE2 ; IMMEDIATE

\ ���� �����������
: *>   ?COMP  204  0 RLIT, >MARK  203 ;  IMMEDIATE
: <*>  ?COMP  203 ?PAIRS  0 RLIT, >MARK RET,  205 ROT
       >RESOLVE2  0 RLIT,  >MARK 203 ;  IMMEDIATE
: <*   ?COMP  203 ?PAIRS  0 RLIT, >MARK RET,  205 ROT
       >RESOLVE2  RET,  BEGIN  DUP 204 = 0= WHILE
       205 ?PAIRS  >RESOLVE2 REPEAT  DROP ; IMMEDIATE

\ ������� ��� ������� ����������, ��� ���������:
\ ��������� �������� ����������
\ ������� �������������� (������������, ������������ ���������� �������� ��� ���������)
\ ������� ������, ����� �������� � ���� R> ENTER

\ �� ����� ���������� �� ����� ������ ������ ��������� ��������
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
LIT, succ COMPILE,
;

: +{ ?COMP 0 LIT, agg{ ; IMMEDIATE
: }+ ?COMP ['] +! ['] @ }agg ; IMMEDIATE

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

\EOF
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
: bt2 START ." back" EMERGE ." tracking" ;

: 1-20 PRO 21 BEGIN DUP CONT DROP 1- ?DUP 0= UNTIL RDROP ; \ ����� ����� �� 1-�� �� 20-�
\ : 1-20  21 BEGIN DUP R@ ENTER DROP 1- ?DUP 0= UNTIL RDROP ;
: //2 DUP 2 MOD ONFALSE ; \ ���������� ������ ������ �����
: 1-20. 1-20 //2  DUP . ;
: 1-20X 1-20 ." X" ;
: 1-20X1-20x 1-20 1-20 ." X" ;

: STACK  PRO  DEPTH 0  ?DO  DEPTH I - 1- PICK  CONT DROP LOOP ;  \ ����� ����
: STACK. STACK DUP . ;  \ �������� ����

: stack>10 PREDICATE STACK DUP 10 > ONTRUE DROP SUCCEEDS ;
\ ����� true ���� �� ����� ���� ����� ������ 10-�
\ DROP ����� ONTRUE ����� ��� �������� ��������� �������� �� ���������� STACK, ����� �� ��� ���� ��������?
\ ����� ���������� � ������ CUT: � PREDICATE ������ �� ������ ��������� � ���� ������ ����?

: stack-sum ( x1 x2 ... xn -- x1 x2 ... xn sum  )
+{ STACK DUP }+ ;
\ ����� �������� �� �����

: stack-or |{ STACK DUP }| ;

: sempty NOT: STACK -NOT ." ���� ����" ;

: alter PRO
*> S" first" <*> S" second" <*
CR TYPE ;

\ ������� ���� ����������� ������������ AMONG  ...  EACH  ...  ITERATE
: SUBSETS
    AMONG   *> 1 <*> 2 <*> 5 <*   \ ��������� �� ����� �� ������� 1,2,5
    EACH    *> <*> DROP <*      \ ����� ������� � ���������, ����� ��� ����
                            \ DROP ������� ��-� ��������� �� �����
    ITERATE
        CR STACK. ;        \ ����������� ���� � ����� ������

\ ������� ���� �����������, �� ������ Dynamic Code Generation
: el  R@ ENTER DROP ;
: .{} CR ." { " DEPTH 0 ?DO I PICK COUNT TYPE SPACE LOOP ." } " ;
: subsets C" first" el C" second" el C" third" el .{} ;

\EOF
: ALL ?COMP POSTPONE (NOT:) 0 ,  >MARK N0T ; IMMEDIATE
: (ARE) R> RP@ >L BACK LDROP L> RP! TRACKING  >R ;
: ARE ?COMP POSTPONE (ARE) ; IMMEDIATE
: WISE ?COMP N0T ?PAIRS POSTPONE (-NOT)  >RESOLVE2 ;  IMMEDIATE

: iter PRO *> 1 <*> 2 <*> 3 <* CONT DROP ;
: check ;
: r PREDICATE ALL iter ARE DUP 2 = ONFALSE WISE SUCCEEDS . ;