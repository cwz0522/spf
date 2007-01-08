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
REQUIRE (: ~yz/lib/inline.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE CREATE-VC ~profit/lib/compile2Heap.f

MODULE: bac4th-sequence

:NONAME PRO LOCAL t
@ t !
\ ['] RDROP t @ VC-COMPILE,  t @ VC-RET, ( \ ��� ���,
START{ t @ VC- POSTPONE RDROP RET, }EMERGE \ ��� ��� )
t @ XT-VC CONT
t @ DESTROY-VC
;
CONSTANT (}seq) \ ��������� ������ }seq

EXPORT

: seq{ ( -- ) ?COMP POSTPONE CREATE-VC agg{ ; IMMEDIATE

: }seq ( n -- xt ) ?COMP (: @ VC-
DUP LIT,
R@ENTER, POSTPONE DROP ;) (}seq) }agg ; IMMEDIATE

: }seq2 ( n -- xt ) ?COMP (: @ VC-
2DUP DLIT,
R@ENTER, POSTPONE 2DROP ;) (}seq) }agg ; IMMEDIATE

: }seq3 ( n -- xt ) ?COMP (: @ VC-
ROT DUP LIT, -ROT 2DUP DLIT,
R@ENTER, POSTPONE 2DROP POSTPONE DROP ;) (}seq) }agg ; IMMEDIATE

: }seq4 ( n -- xt ) ?COMP (: @ VC-
2OVER DLIT, 2DUP DLIT,
R@ENTER, POSTPONE 2DROP POSTPONE 2DROP ;) (}seq) }agg ; IMMEDIATE

DEFINITIONS

: __ CELL -- ;

0
__ handle  \ ���� ������������ ���������
__ counter \ ������� ���-�� �������� �����
CONSTANT arr-struct \ �������������� ���������


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

: arr{ ( -- ) ?COMP
(: arr-struct ALLOCATE THROW >R CREATE-VC R@ handle ! R@ counter 0! R> ;) \ ������������� ���. ���������
\ INLINE, ( \ ��� ���, �� ���� ����������� INLINE, ��� ������������ POSTPONE
COMPILE,  \ ��� ���, ��� ����� ������, � �� ����������� � MemReport (???) )
agg{ ; IMMEDIATE

: }arr ( n -- xt ) ?COMP (: @ DUP counter 1+!
handle @ VC-
DUP LIT,
R@ENTER, POSTPONE DROP ;) (}arr) }agg ; IMMEDIATE

;MODULE


\EOF
: INTSTO PRO 0 DO I CONT DROP LOOP ;
: INTSFROMTO PRO SWAP 1+ SWAP DO I CONT DROP LOOP ;

REQUIRE SEE lib/ext/disasm.f
: r seq{ 10 INTSTO }seq ( xt ) ." generated code:" DUP REST CR ." execute:" ENTER DUP . ;


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

: union PRO *> a <*> b <* CONT ; \ ����������� (������ -- ������������)
: cross PRO a b 2DUP = ONTRUE CONT ; \ �����������
: subtr PRO a S| NOT: b 2DUP = ONTRUE -NOT CONT ; \ ���������? (����� ��� ���������)

: 4ops
START{ CR ." a="   a     DUP . }EMERGE
START{ CR ." b="   b     DUP . }EMERGE
START{ CR ." a+b=" union DUP . }EMERGE
START{ CR ." axb=" cross DUP . }EMERGE
START{ CR ." a-b=" subtr DUP . }EMERGE ;
4ops CR

 \ �����������, �� ������ ����� �������� ���������, ������ ����� ��������� ���� ���������� 
: union ( a b -- a+b ) PRO LOCAL b b ! LOCAL a a !
 *> a @ ENTER
<*> b @ ENTER
<*  CONT ;

: cross ( a b f -- axb ) PRO LOCAL f f ! LOCAL b b ! LOCAL a a !
a @ ENTER b @ ENTER f @ ENTER ONTRUE CONT ;
\ �������� ��������� ���� �������� ������� � �������� ����, ������ �� ������ 
\ ����� ��� ���� �����������: f ( ... -- 0|-1 )
: cross-number ( a b -- axb ) PRO (: 2DUP = ;) cross CONT ;

: subtr ( a b f -- a-b ) PRO LOCAL f f ! LOCAL b b ! LOCAL a a !
a @ ENTER
S| NOT: b @ ENTER f @ ENTER ONTRUE -NOT CONT ;
: subtr-number PRO (: 2DUP = ;) subtr CONT ;

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
seq4ops


REQUIRE split-patch ~profit/lib/bac4th-str.f
REQUIRE COMPARE-U ~ac/lib/string/compare-u.f

: cross-str PRO (: 2OVER 2OVER COMPARE-U 0= ;) cross CONT ;

: commonWord
seq{ S" kiwi apple lemon orange"
BL byChar split-patch }seq2 ( list-xt1 )
seq{ S" peach cherry lemon kiwi feyhoa"
BL byChar split-patch }seq2 ( list-xt1 list-xt2 )
cross-str 2DUP TYPE SPACE ;

CR commonWord
\ ������ �����: kiwi lemon 

: arr1 arr{ a }arr DUMP ;
arr1

REQUIRE iterateBy ~profit/lib/bac4th-iterators.f

: arr2 arr{
S" ac day mlg pinka profit" BL byChar split-patch \ ����� �� �����-�������
( addr u )
*> <*> BSWAP <*   \ "��������" �������, �� ����: �������� }arr ��� ����� �� �����
}arr ( addr u )   \ ������ � ��� ������ ������� ��������
2 CELLS iterateBy \ ������ �� ���� ������, ������ �� ��� ������ �����
DUP 2@ CR TYPE ;
arr2
\ MemReport