\ �����:
\ seq{ ... }seq
\ �
\ arr{ ... }arr


\ seq{ ... }seq ��������� �� ����� xt -- ����� ������� ����, ������� ����������
\ �� �� �������� ��� � ��������� ����� �������� seq{ ... }seq
\ �� ����, ��������� ���������� ��������� ��� �� ����������, "������������"
\ � ������, �������� ���������������� ���������.

\ ��� ������, �� ����, ������ ��������� �������:

\ ��� ���������� ������� �������� ��������� ������ (n-�) ��� ��� ��������
\ ��� ��������� ��� �� ������ �� �����, ����� �������� ���������� � ������
\ ��� �������� � �����-������ ���������. ���������������� ��������, �� ����,
\ � ����� ����� ������������� ����������. ������ ����������� ���������, � 
\ ���� ������� ����.

\ ����� ��, ���� �������� �����-����� ������� �� � �������� �������������
\ ���������� ���� ��������� ����� ��������� ������������ �������. ������:
\ 1 iterator ( 1 ... x )
\ ���� ���� �� ����� ��� iterator ���������� �� ����� ������ ���� ��������
\ �� ����� ����� ���� ��� ����� ���� ������������� �������� ���������� 
\ ���������, � ������� ������� � ������� �� ��������� �� ����������
\ ������ ���������� iterator , �� �� �����.
\ � ������ �� ����������� ��������� ������� ������������� �������� �� �����
\ �� ����� ��� ��� ���������������� �������� ����� ���������� �� ����� ������
\ ���������� ���������� ��������.

\ ����� ����, ��� ����������� ����� ������� ����������� ���������� ��������
\ ��������� ����� ��������, �������� ���������� �� �������� � ���� ������-
\ ��������, ����� �� ����������� � �.�. (��. ����� union , cross )

\ ������� �������� ��� ��� ������������ ��������� �� �������� ������������
\ ����������� ������, ��� ��� ��������� ������ ���������������� ������ � ������.
\ ��� �������, ����� ������������ �� ��� ������������� ����, ����� ���������
\ ������ ��������� ����� ������� ���-�� ��������� � ���� ���������, �����
\ ����� �� ������ �������� ������� ����. ��� �������� arr{ ... }arr

\ arr{ ... }arr ��������� �� ����� ����� ������ ������� � ��� �����.
\ ������ ������������ �� ������� �������� ���������� �� ����� ����� 
\ ������� ������ ���������� ����� ��������. ��� ������ ���� ������
\ ���������.

\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE writeCell ~profit/lib/fetchWrite.f 
REQUIRE (: ~yz/lib/inline.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE BALLOCATE ~profit/lib/bac4th-mem.f
REQUIRE CREATE-VC ~profit/lib/compile2Heap.f

MODULE: bac4th-sequence

:NONAME PRO LOCAL t
@ t !
\ ['] RDROP t @ VC-COMPILE,  t @ VC-RET, ( \ ��� ���,
START{ t @ VC- POSTPONE RDROP RET, }EMERGE \ ��� ��� )
t @ XT-VC CONT
t @ DESTROY-VC
; CONSTANT (}seq) \ ��������� ������ }seq

: RET,-1ALLOT  0xC3 DP @ C! ; \ ��������� ��������� ��� ����, ����� �� ��� ���� �� ����
\ �������� "�������������" ��������� ��� ������� ���������� ��� (�����: ����������)

: __ CELL -- ;
: --ALIGN CELL /MOD SWAP IF 1+ THEN CELL * ;

0
1 -- rlit
__ handle  \ ���� ������������ ���������
1 -- ret
--ALIGN
__ counter \ ������� ���-�� �������� �����
CONSTANT arr-struct \ �������������� ���������

:NONAME
arr-struct ALLOCATE THROW >R
CREATE-VC
START{ DUP VC- RET,-1ALLOT }EMERGE
R@ handle ! R@ counter 0!
0x68 R@ rlit C!  0xC3 R@ ret C!
R> ; CONSTANT (arr{)

:NONAME
PRO LOCAL t @ t !


['] RDROP
t @ handle @ VC-COMPILE,
t @ handle @ VC-RET, \ ��������� ��������

t @ CONT \ ������ �����
t @ handle @ DESTROY-VC
t @ FREE THROW \ ������� � �������������� ���������
; CONSTANT (}seq) \ ��������� ������ }seq


:NONAME PRO LOCAL t LOCAL array LOCAL runner
@ t !

START{ t @ handle @ VC- POSTPONE RDROP RET, }EMERGE

t @ counter @ \ ������ �� ����� ����� ������
CELLS ALLOCATE THROW DUP array ! \ ���� ��� ��� ������� ������
runner ! \ ������ ������� �� ������ �������

START{
t @ handle @ XT-VC ENTER \ ��������� ������� ��������
DUP runner @ ! CELL runner +! \ ��������� �� ������ ������ �� ��������� � ������
}EMERGE

t @ handle @ DESTROY-VC \ �������� ����� ���������� � �������� ��� ������ � ������ ������ �� �����
array @  t @ counter @ CELLS ( addr u )

t @ FREE THROW \ ������� � �������������� ���������
( addr u ) CONT \ ������ �����
array @ FREE THROW \ ����������� ��������������� ������
;
CONSTANT (}arr) \ ��������� ������ }arr

EXPORT

: seq{ ( -- ) ?COMP (arr{) COMPILE, agg{ ; IMMEDIATE

: }seq ( n -- xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
DUP LIT,
R@ENTER, POSTPONE DROP
RET,-1ALLOT ;) (}seq) }agg ; IMMEDIATE

: }seq2 ( n -- xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
2DUP DLIT,
R@ENTER, POSTPONE 2DROP
RET,-1ALLOT ;) (}seq) }agg ; IMMEDIATE

: }seq3 ( n -- xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
ROT DUP LIT, -ROT 2DUP DLIT,
R@ENTER, POSTPONE 2DROP POSTPONE DROP
RET,-1ALLOT ;) (}seq) }agg ; IMMEDIATE

: }seq4 ( n -- xt ) ?COMP (: @
DUP counter 1+!
handle @ VC-
2OVER DLIT, 2DUP DLIT,
R@ENTER, POSTPONE 2DROP POSTPONE 2DROP
RET,-1ALLOT ;) (}seq) }agg ; IMMEDIATE

: {seq} ( -- xt ) ?COMP (: ;) {agg} ; IMMEDIATE

: {#} ( xt -- u ) counter @ ;

: seq>arr ( xt --> addr u ) PRO LOCAL arr LOCAL runner
DUP {#} BALLOCATE DUP arr ! runner !
START{ ENTER DUP runner writeCell }EMERGE
arr @ runner @ OVER - CONT ;

;MODULE

/TEST
: INTSTO PRO 0 DO I CONT DROP LOOP ;
: INTSFROMTO PRO SWAP 1+ SWAP DO I CONT DROP LOOP ;

: list-xt-generated seq{ 5 INTSTO }seq ( xt ) DUP {#} ." length: " . CR ." execute:" ENTER DUP . ;
$> list-xt-generated

: intermediate seq{ 5 INTSTO CR {seq} START{ ENTER DUP . }EMERGE }seq ( xt ) ENTER ;
$> intermediate

: a PRO \ ������ �����
1 CONT DROP
2 CONT DROP
4 CONT DROP
5 CONT DROP
3 CONT DROP ;

: b PRO \ ��� ���� ������ �����
7 CONT DROP
4 CONT DROP 
6 CONT DROP ;

: number= ( a b -- a b f ) 2DUP = ;

: union PRO *> a <*> b <* CONT ; \ ����������� (������ -- ������������)
: cross PRO a b number= ONTRUE CONT ; \ �����������
: subtr PRO a S| NOT: b number= ONTRUE -NOT CONT ; \ ���������? (����� ��� ���������)

: 4ops
START{ CR ." a="   a     DUP . }EMERGE
START{ CR ." b="   b     DUP . }EMERGE
START{ CR ." a+b=" union DUP . }EMERGE
START{ CR ." axb=" cross DUP . }EMERGE
START{ CR ." a-b=" subtr DUP . }EMERGE ;
CR $> 4ops

 \ �����������, �� ������ ����� �������� ���������, ������ ����� ��������� ���� ���������� 
: union ( a b -- a+b ) PRO LOCAL b b ! LOCAL a a !
 *> a @ ENTER
<*> b @ ENTER
<*  CONT ;

: cross ( a b f -- axb ) PRO LOCAL f f ! LOCAL b b ! LOCAL a a !
a @ ENTER b @ ENTER f @ ENTER ONTRUE CONT ;
\ �������� ��������� ���� �������� ������� � �������� ����, ������ �� ������ 
\ ����� ��� ���� �����������: f ( ... -- 0|-1 )
: cross-number ( a b -- axb ) PRO ['] number=  cross CONT ;

: not-in ( a b f --> \ <-- ) PRO LOCAL f f ! LOCAL b b !
S| NOT: b @ ENTER f @ ENTER ONTRUE -NOT CONT ;

: subtr ( a b f -- a-b ) PRO LOCAL f f ! LOCAL b b !
ENTER b @ f @ not-in CONT ;

: subtr-number PRO ['] number= subtr CONT ;

: head ( a -- ... ) CUT: ENTER -CUT ;
: tail ( a -- ... a' ) CUT: ENTER R@ -CUT ;

: seq4ops LOCAL 0..4 LOCAL 2..5

seq{ 4 INTSTO }seq 0..4 ! \ �� 0 �� 4-�
seq{ 5 2 INTSFROMTO }seq 2..5 ! \ "�� ���� �� ����" (�)

CR ." [0..4]=" START{ 0..4 @ ENTER DUP . }EMERGE
CR ." [2..5]=" START{ 2..5 @ ENTER DUP . }EMERGE

CR ." head[0..4]=" 0..4 @ head . \ ������� ������ ����, ������ ��������
CR ." tail[0..4]=" 0..4 @ tail START{ ENTER DUP . }EMERGE

START{
seq{ 0..4 @  2..5 @ union }seq
CR ." [0..4]+[2..5]="
ENTER DUP . }EMERGE

START{
seq{ 0..4 @  2..5 @ cross-number }seq
CR ." [0..4]x[2..5]="
ENTER DUP . }EMERGE

START{ seq{ 0..4 @  2..5 @ subtr-number }seq
CR ." [0..4]-[2..5]=" ENTER DUP . }EMERGE

START{ seq{
seq{ 0..4 @  2..5 @ cross-number }seq
seq{ 0..4 @  2..5 @ subtr-number }seq
union }seq
CR ." [0..4]x[2..5] + [0..4]-[2..5]=" ENTER DUP . }EMERGE ;
$> seq4ops

REQUIRE split-patch ~profit/lib/bac4th-str.f
REQUIRE COMPARE-U ~ac/lib/string/compare-u.f

: str= ( d1 d2 -- d1 d2 f ) 2OVER 2OVER COMPARE-U 0= ;
: cross-str PRO ['] str= cross CONT ;

: commonWord
seq{ S" kiwi apple lemon orange"
BL byChar split-patch }seq2 ( list-xt1 )
seq{ S" peach cherry lemon kiwi feyhoa"
BL byChar split-patch }seq2 ( list-xt1 list-xt2 )
cross-str 2DUP TYPE SPACE ;

CR $> commonWord
\ ������ �����: kiwi lemon
: dump-arr seq{ a }seq seq>arr DUMP ;
CR $> dump-arr

REQUIRE iterateBy ~profit/lib/bac4th-iterators.f

: TAKE-TWO PRO *> <*> BSWAP <* CONT ;

: arr2 seq{
BL byChar split-patch \ ����� �� �����-�������
( addr u )
0 .
TAKE-TWO          \ "��������" �������, �� ����: �������� }arr ��� ����� �� �����
1 .
}seq 2 .
seq>arr ( addr u )   \ ������ � ��� ������ ������� ��������
3 .
EXIT
2 CELLS iterateBy \ ������ �� ���� ������, ������ �� ��� ������ �����
DUP 2@ CR TYPE ;

CR $> S" ac day mlg pinka profit" arr2
\ MemReport
\EOF
: uniqueSeq seq{
BL byChar split-patch \ ����� �� �����-�������
{seq} ['] str= not-in
}seq2 ENTER 2DUP CR TYPE ;

$> S" kiwi apple lemon kiwi apple orange" uniqueSeq