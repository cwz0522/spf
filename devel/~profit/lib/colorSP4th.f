\ colorlessForth ��� 梥�. ���� -- Chuck Moore � Terry Loveall.
\ ����� �������樨 㡨ࠥ���. ������� ⮫쪮 ��������.
\ �� ������ � "᫮���" (�筥� ������ ��ப��), ��।������ ��᫥���� �㪢��
\ ��. ⠪�� ~profit\lib\loveall.f


\ ��।������:  1d; typeNumber,    <--- CREATE ��।������ 1 LIT, COMPILE .
\ ��।������2: 2d; typeNumber,    <--- CREATE ��।������ 2 LIT, COMPILE .
\ ��।������3: 3d; typeNumber.    <--- CREATE ��।������ 3 LIT, COMPILE . RET,

REQUIRE lastChar ~profit/lib/strings.f
REQUIRE number ~profit/lib/number.f
REQUIRE charTable ~profit/lib/chartable-eng.f

charTable colors
: evalWordWithColor ( addr u -- ) lastChar colors processChar ;
: NOTFOUND evalWordWithColor ;

colors
all: CR curChar EMIT ABORT"  ��� ⠪��� 梥�!" ;

: wordCode SFIND 0= IF TYPE ABORT"  ᫮�� �� �������!" THEN ;

char: ' wordCode ;
char: , wordCode COMPILE, ;
char: : CREATED DOES> EXECUTE ;
char: . wordCode BRANCH, ;
char: d DECIMAL number ;
char: h HEX number ;
char: ; lastChar colors processChar  LIT, ;
char: | lastChar colors processChar  , ;

: typeNumber . ;
: . RET, ;

\EOF
: interpretWithColor BEGIN \ ������஢��� �室��� ��⮪ � ������� �९������
NextWord DUP         WHILE 
2DUP CR TYPE evalWordWithColor
?STACK               REPEAT 2DROP ;

' interpretWithColor &INTERPRET !