\ yGREK
\ 08.May.2005

\ �������� ���� ~micro/lib/const.f
\ ����᫥��� ��६����� � ����
\ floats a b c d e ;

\ �ਬ�� � ����

: CheckNextWord ( -- ? )
  BEGIN
   >IN @ 
   NextWord
   DUP 0=
  WHILE
   2DROP
   DROP
   REFILL 0= ABORT" Need semicolon as the delimiter!"
  REPEAT
  S" ;" COMPARE IF >IN ! TRUE ELSE DROP FALSE THEN
;

: (enum)
  DOES> @ ( xt ) >R
  BEGIN
   CheckNextWord
  WHILE
   R@ EXECUTE
  REPEAT
  RDROP
;

: ENUM
  CREATE ,
  (enum)
  IMMEDIATE
;

 
\EOF
\ �ਬ��
REQUIRE F. lib/include/float2.f

:NONAME 1e FVALUE ; ENUM floats                          
:NONAME 23 CONSTANT ; ENUM consts
:NONAME CREATE DOES> DROP S" Hello,world" TYPE CR ; ENUM hellos
:NONAME DUP CONSTANT 1 + ; ENUM 1+consts

\ �ਬ�� ��������� ���樠����஢����� ��६�����
consts a1
a2 a3 
    a4 
;
hellos h1 h2 h3 ; 

\ �ਬ�� ���樠�������� ��६�����
floats f1 f2 f3 ;

10 1+consts c1 c2 c3 ; DROP

\ check

a1 a2 + a4 - . .( = ) a3 . CR 
h1 h2 h3
f1 G. CR 
f2 G. CR
f3 G. CR
c1 . c2 . c3 .
