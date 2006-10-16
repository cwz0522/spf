\ ������ �� ��������, ������� ������������� ����������� � ����, 
\ � ������������� (��� ������) � �� ���������
\ bac4th strings AKA "���������� �����". ��� ��������� ����� ~mlg �� ����������� ����� � �� ��������
\ ��. http://fforum.winglion.ru/viewtopic.php?t=167

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE STR@ ~ac/lib/str4.f

MODULE: bac4th-str

: ?PAIRS <> ABORT" unpaired" ;
: >RESOLVE2 ( dest -- ) HERE SWAP ! ;


: >STR ( a u -- s ) "" DUP >R STR+ R> ;

0 VALUE previousAddress


VECT compare \ ������� ��������� ��� find ����� ���� ����� � ������� ���� ( a b -- f )
\ ' EXECUTE TO compare
\ ����� ���� �����������? � ����� ��� �������� c ���� ����� ��������� �� ������, � 
\ ����� ������� ��������� �� ������ ( a -- f ) ...

: concat-sum ( addr u var -- ) @ STR+ ;
: concat-suc ( var <--> s ) @  R> ENTER  STRFREE ;

:NONAME ( a -- f ) DUP 10 = SWAP 13 = OR ; CONSTANT isSpaceBeforeWord
:NONAME ( a -- f ) DUP 10 = SWAP 13 = OR ; CONSTANT isCRLF

EXPORT

: copy ( a u i l <--> s1  ) \ l=-1 ?
PRO { a u i l \ e t -- }
a u + TO e
a i + e MIN TO t
t l + e MIN
t - t SWAP
>STR CONT STRFREE ;

: char-compare ['] = TO compare ;
: func-compare ['] EXECUTE TO compare ;
\ �� ���� ������� ��� ������ �������� ����� split (������!)
char-compare


: find ( a u c <--> a1 )
\ ������� � ������ a u ��� ������� c � ���������� ������ ��� ������� �������
PRO { a u c -- } CR
a u + a ?DO I C@ c compare IF I CONT DROP THEN LOOP ;

: divide ( a u c <--> s1 )
\ ��������� ������ a u ������ �������� c � ���������� ��� ������ �� ��������
\ ����� �������� � ����� � �������������� ���������� � ������� ������
PRO { a u c -- }
a u c CUT: find -CUT
DUP a - a SWAP >STR CONT STRFREE
1+ a u + OVER - >STR CONT STRFREE ;

: split ( a u c <--> s1  )
\ ��������� ������ a u ��������� c � ���������� ����� ��� ������ ������������������
\ ����� ����� ��������� � �������������� ���������� � ������� ������
PRO { a u c -- }
a TO previousAddress
a u + a u c
START
find
DUP previousAddress - previousAddress SWAP >STR CONT STRFREE
DUP 1+ TO previousAddress EMERGE
previousAddress - previousAddress SWAP >STR CONT STRFREE \ ���������� � ��������� ����� �� ����������� �� char
;

: notEmpty ( s <--> s ) PRO DUP STR@ NIP ONTRUE CONT ; \ ��������������� ������ ������

\ ����������� ... concat{ ���������-����� ( addr u ) }concat ( s <-> s ) ...
: concat{  ?COMP POSTPONE "" agg{ ; IMMEDIATE
: }concat  ?COMP ['] concat-sum ['] concat-suc }agg ; IMMEDIATE

: load-file ( addr u <--> addr1 u1 ) \ ��������� ����
PRO FILE CONT DROP FREE THROW ;

: iterateStrings ( addr u <--> s ) PRO \ ������� ���� �� ������� �����
load-file 2DUP func-compare isCRLF ( ������� �������� �� ������� ������)
split notEmpty CONT ;

;MODULE

/TEST
: r
S" sss" [CHAR] a divide DUP STR@ TYPE ; r

: e S" mary434" 1 1000 copy DUP STR@ TYPE ; CR e

: r S" mary has sheep" [CHAR] a find DUP C@ EMIT ;
\ ������� ��� ������� 'a'
\ CR r

: r2 S"  mary  has a  sheep" BL split notEmpty ."  [" DUP STR@ TYPE ." ]" ;
\ ����� �� �����. ������ ����� -- �� ������� �� ������� ������, �� �������� � ���� 
\ � ������������� ��� ������ ����� �� ���� ���������
\ �����: [mary] [has] [a] [sheep]
 CR r2

: r3 S" antigua labrador abracadabra"  BL split DUP STR@ [CHAR] a split notEmpty ."  [" DUP STR@ TYPE ." ]" ;
\ ����� �� ����� � �� ������� ����� ������ 'a' � ������.
\ �����: [ntigu] [l] [br] [dor] [br] [c] [d] [br]
CR r3

: r4 CUT: S" antigua labrador abracadabra"  BL split -CUT ."  [" DUP STR@ TYPE ." ]" ;
\ ������ ������ ��������������� ������������������
\ �����: [antigua]
\ ��������, � ���� ������� �� ����� ������� �����
CR r4

: r7 concat{ *> concat{ *> S" 2" <*> S" *2" <* }concat DUP STR@ <*> S" =4" <*> S" ?" <* }concat DUP STR@ TYPE ;
CR r7

\ �����: 2*2=4?

: r8 concat{ S"     mary  has  a  sheep  " BL split notEmpty DUP STR@ }concat ."  [" DUP STR@ TYPE ." ]" ;
\ ������� ��� ������� � ������
\ �����: [maryhasasheep]
 CR r8

: r9 S" a1=123==456" [CHAR] = divide DUP ."  [" STR@ TYPE ." ]" ;
\ ��������� ������ �� ��� �����
\ �����: [a1] [123==456]
CR r9

: printFile  S" C:\lang\spf\devel\~profit\lib\bac4th-str.f" iterateStrings DUP STR@ CR TYPE ;