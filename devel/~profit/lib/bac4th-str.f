\ ������ �� ��������, ������� ������������� ����������� � ����, 
\ � ������������� (��� ������) � �� ���������
\ bac4th strings AKA "���������� �����". ��� ��������� ����� ~mlg �� ����������� ����� � �� ��������
\ ��. http://fforum.winglion.ru/viewtopic.php?t=167

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE compiledCode ~profit/lib/bac4th-closures.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE LOCAL ~profit/lib/static.f

MODULE: bac4th-str

: ?PAIRS <> ABORT" unpaired" ;
: >RESOLVE2 ( dest -- ) HERE SWAP ! ;


: >STR ( a u -- s ) "" DUP >R STR+ R> ;

0 VALUE previousAddress

: concat-sum ( addr u var -- ) @ STR+ ;
: concat-suc ( var <--> s ) @  R> ENTER  STRFREE ;

EXPORT

: copy ( a u i l <--> s1  ) \ l=-1 ?
PRO { a u i l \ e t -- }
a u + TO e
a i + e MIN TO t
t l + e MIN
t - t SWAP
>STR CONT STRFREE ;

\ ���������� ������� ������������ �� ��������� � ������
: byChar ( c <--> xt )  PRO S" LITERAL =" compiledCode CONT ;

\ ������� ��������� ������� �� ������� ������
\ : byRows ( <--> xt ) PRO S" 2* 23 - ABS 3 ="  compiledCode CONT ;
\ : byRows ( -- xt ) (: 2* 23 - ABS 3 = ;) ;
:NONAME 2* 23 - ABS 3 = ; \ 13 ��� 10
CONSTANT byRows

: find ( a u f <--> a1 )
\ ������� � ������ a u ��� �������, �� ������� ������� f ���� TRUE � ���������� ������ ��� ������� �������
\ ������� f ( � -- 0|-1 ) �������� �� ����� �������� ������� � ������� ���������� ��������
PRO { a u f -- }
a u + a ?DO I C@ f EXECUTE IF I CONT DROP THEN LOOP ;

: split-patch ( a u f <--> addr u  )
\ ��������� ������ a u ���������, �� ������� ������� f ���� TRUE � ���������� 
\ ����� ��� ������� *�������* � ������ a u
PRO { a u f -- }
a TO previousAddress
a u + a u f
START{
find
DUP previousAddress - previousAddress SWAP CONT 2DROP
DUP 1+ TO previousAddress }EMERGE
previousAddress - previousAddress SWAP CONT 2DROP \ ���������� � ��������� �������, �� ����������� �� char
;

: split ( a u f <--> s1  )
\ ��������� ������ a u ���������, �� ������� ������� f ���� TRUE � ���������� ����� ��� 
\ ������ ������������������ ����� ����� ��������� � �������������� ���������� � ������� ������
PRO split-patch 2DUP >STR CONT STRFREE ;

: last-patch ( a u f <--> addr u ) PRO LOCAL a LOCAL len
START{ split-patch DUP len ! OVER a ! }EMERGE a @ len @ CONT 2DROP ;

: last ( a u f <--> s1  )
PRO last-patch 2DUP >STR CONT STRFREE ;

: notEmpty ( s <--> s ) PRO DUP STR@ NIP ONTRUE CONT ; \ ��������������� ������ ������

\ ����������� ... concat{ ���������-����� ( addr u ) }concat ( s <-> s ) ...
: concat{  ?COMP POSTPONE "" agg{ ; IMMEDIATE
: }concat  ?COMP ['] concat-sum ['] concat-suc }agg ; IMMEDIATE

: load-file ( addr u <--> addr1 u1 ) \ ��������� ����
PRO FILE CONT DROP FREE THROW ;

: iterateStrings ( addr u <--> s ) PRO \ ������� ���� �� ������� �����
load-file 2DUP byRows ( ������� �������� �� ������� ������)
split notEmpty CONT ;

;MODULE

/TEST
: e S" forth" 3 2 copy DUP STR@ TYPE ; CR e

: r S" mary has sheep" [CHAR] a byChar find DUP C@ EMIT ;
\ ������� ��� ������� 'a'
\ CR r

: r2 S"  mary  has a  sheep" BL byChar split notEmpty ."  [" DUP STR@ TYPE ." ]" ;
\ ����� �� �����. ������ ����� -- �� ������� �� ������� ������, �� �������� � ���� 
\ � ������������� ��� ������ ����� �� ���� ���������
\ �����: [mary] [has] [a] [sheep]
 CR r2

: r3 S" antigua labrador abracadabra"  BL byChar split DUP STR@ [CHAR] a byChar split notEmpty ."  [" DUP STR@ TYPE ." ]" ;
\ ����� �� ����� � �� ������� ����� ������ 'a' � ������.
\ �����: [ntigu] [l] [br] [dor] [br] [c] [d] [br]
CR r3

: r4 S" antigua labrador abracadabra"  BL byChar CUT: split -CUT ."  [" DUP STR@ TYPE ." ]" ;
\ ������ ������ ��������������� ������������������
\ �����: [antigua]
\ ��������, � ���� ������� �� ����� ������� �����, �� ������ ��� � ��� ��� �� ��������� �� ������
\ ��� ��� CUT ������� ������������ ������ ������� ������ split �� ����� ���������
\ CR r4

: r7 concat{ *> concat{ *> S" 2" <*> S" *2" <* }concat DUP STR@ <*> S" =4" <*> S" ?" <* }concat DUP STR@ TYPE ;
CR r7

\ �����: 2*2=4?

: r8 concat{ S"     mary  has  a  sheep" BL byChar split notEmpty DUP STR@ }concat ."  [" DUP STR@ TYPE ." ]" ;
\ ������� ��� ������� � ������
\ �����: [maryhasasheep]
 CR r8

\ : r9 S" a1=123==456" [CHAR] = byChar divide DUP ."  [" STR@ TYPE ." ]" ;
\ ��������� ������ �� ��� �����
\ �����: [a1] [123==456]
\ � ����� CUT ��������� �����
\ CR r9

: printFile  S" C:\lang\spf\devel\~profit\lib\bac4th-str.f" iterateStrings DUP STR@ CR TYPE ;
\ ����� ����� �� ������