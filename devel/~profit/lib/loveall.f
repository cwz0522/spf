\ colorlessForth ��� �����. ���� -- Chuck Moore � Terry Loveall.
\ ���������� �� �������-����������
S" lib\ext\patch.f" INCLUDED

: [ ;
: ] ' COMPILE, ;
: n LIT, ;
 
:NONAME CREATE DOES> EXECUTE ;   ' : REPLACE-WORD
:NONAME RET, ;                   ' ; REPLACE-WORD

\EOF
\ examples
: square  ] DUP  ] *  ;
: 2x2  2 n  ] square  ] . ;