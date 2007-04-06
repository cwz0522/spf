\ colorlessForth ��� �����. ���� -- Chuck Moore � Terry Loveall.
\ ����� ���������� ���������. ������� ������ �������������.
\ ��� ������ �� "������" (������ ������ �������), ������������
\ ��������� ������:

\ : -- �����������
\ , -- ���������� ( COMPILE, )
\ . -- ���������� ������������ �������� ( BRANCH, ), ��������� �����������
\ ; -- ���������� ��������� �������� ( LIT, )
\ ' -- ��������� ������ ��� ����� �����, � �������� ����� �������� xt
\ | -- ������ � �������� ����� ( | )
\ d -- �����������
\ h -- �����������

\ �������� �������� �� ����������� ���������� ������:
\ DUP'; --> [ ' DUP ] LITERAL
\ 43d;  --> [ DECIMAL 43 ] LITERAL
\ DUP'| --> ' DUP ,
\ 43d|  --> DECIMAL 43 ,

\ ����� ���� �������� ��� � "������" . , ; | ���� �� ������� �����
\ ������� ���� ��������� (���� ����) ����� �� �����.

\ ����� ������� ����� ���� �������� ���� ��������� �������������
\ ��������� �����������:
\ DUP. --> DUP, .

\ ��. ����� ~profit\lib\loveall.f

\ square: DUP, *.
\ 2x2: 2d; square, typeNumber.
\ 2x2

\ ������������� ������� �������� ��������� ��������� �����
\ ���������������, ���� ������ ����� ���, �� �������� ������,
\ ������� ��������� ����� �� ��������� ����� ����� � �������
\ ��� ������ � ��������� ���������� ��� ������ �����-"�����"
\ � �� ��� ��� ����� �� �������-��������� ������ ����� 
\ ���-������ �������.

\ ����� ��� ��������� ���������� ����������� "���������" �������.
\ ��������, ��������� ����� "SWAP," ����� ������ �������� �� ����������
\ SWAP (����������� �����-������). ��� ���� ���� ����� "SWAP" �������
\ ���������.

\ TODO:
\ 1. ������� ������������� � cascaded.f
\ 2. ��������, ����� � ���������� all: ������� "����������" ����� �� nf-ext 
\ (�� ������ ����� ��������� ��������� ������ ���� addr u FALSE, ��� ��������
\ ��������� ������������ nf-ext)
\ 3. ������ ������ �� �������� (���� " �������, �� ��� ���� � �������������
\ ��������?)
\ 4. ������� �������� typeNumber


\ �����������:  1d; typeNumber,    <--- CREATE ����������� 1 LIT, COMPILE .
\ �����������2: 2d; typeNumber,    <--- CREATE ����������� 2 LIT, COMPILE .
\ �����������3: 3d; typeNumber, .    <--- CREATE ����������� 3 LIT, COMPILE . RET,
\ �����������3: 3d; typeNumber.    <--- CREATE ����������� 3 LIT, ' . BRANCH,

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE NOT ~profit/lib/logic.f
REQUIRE (: ~yz/lib/inline.f
REQUIRE lastChar ~profit/lib/strings.f
REQUIRE number ~profit/lib/number.f
REQUIRE charTable ~profit/lib/chartable-eng.f
REQUIRE enqueueNOTFOUND ~pinka/samples/2006/core/trans/nf-ext.f
REQUIRE KEEP ~profit/lib/bac4th.f
\ REQUIRE cascaded ~profit/lib/colorForth/cascaded.f

MODULE: colorSPF

: wordCode SFIND NOT IF 2DROP -321 THROW  THEN ;

charTable colors

colors
all: -321 THROW ;
char: ' wordCode ;
char: , wordCode COMPILE, ;
\ char: : CREATED DOES> EXECUTE ;
char: : SHEADER ;
char: . wordCode BRANCH, ;
char: d BASE KEEP  DECIMAL number ;
char: h BASE KEEP  HEX number ;

\ ����� ������� ����� �������������
char: ; lastChar colors processChar  LIT, ;
char: | lastChar colors processChar  , ;

(
ALSO cascaded
\ ����� ��������� ����������� ���������� ��������� ���������
\ �� ���������

NEW: CSPFWords
\ ������� ����� ������� ��� ���� CSPF
PREVIOUS )

EXPORT

: startColorSPF
(: ( addr u -- addr u false | i*x true ) lastChar colors processChar TRUE ;) enqueueNOTFOUND
\ [COMPILE] ]
\ ALSO CSPFWords DEFINITIONS
;

;MODULE

/TEST
REQUIRE SEE lib/ext/disasm.f

startColorSPF

typeNumber: .. \ ���.. ���� ��������.
.: RET,.
;: LIT,.
|: ,.
,: COMPILE,.

if,:   TRUE, STATE, B!, IF.
then,: TRUE, STATE, B!, THEN.

\ ."' .": TRUE, STATE, B!, , .

fact: ( x -- fx ) ?DUP, 0=, if, 1d; . then, DUP, 1-, fact, *.

$> SEE fact
$> 4 fact typeNumber