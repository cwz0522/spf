\ 02-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ॠ������ 横��� FOR NEXT ��� ���
\ c ������������ �ᯮ�짮����� �� �६� �ᯮ������ (�.� �� STATE = 0)

REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
REQUIRE COMPILE  devel\~moleg\lib\util\compile.f
REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
REQUIRE controls devel\~moleg\lib\util\run.f

\ ����� ��।������ 横�� � ���稪��
: FOR ( n --> )
      STATE @ IFNOT init: THEN 3 controls +!
      <MARK COMPILE >R  ; IMMEDIATE

\ �᫨ ���稪 横�� �� ࠢ�� ��� ��३� � �窥, �⬥祭��� ᫮��� FOR
\ ����, �த������ �믮������ �ணࠬ�� � ᫮�� �� NEXT
: NEXT ( --> )
       ?COMP -3 controls +!
       COMPILE R> 1 LIT, COMPILE - COMPILE DUP N?BRANCH, COMPILE DROP
       controls @ IFNOT [COMPILE] ;stop THEN ; IMMEDIATE

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ 3 FOR R@ NEXT 1 <> THROW 2 <> THROW 3 <> THROW
   S" passed" TYPE
}test
