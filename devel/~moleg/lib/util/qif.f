\ 18-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �ࠢ����� �࠭��樥� �室���� ��⮪�. [IF] [ELSE] [THEN]

 REQUIRE CS>         devel\~moleg\lib\util\csp.f
 REQUIRE sFindIn     devel\~moleg\lib\newfind\search.f
 REQUIRE ROOT        devel\~moleg\lib\util\root.f

 ?DEFINED IS  ALIAS TO IS

ALSO ROOT DEFINITIONS

        \ ᫥���騥 ᫮�� ���� � ROOT, � ⠪ ��� ROOT �ᥣ�� ��室����
        \ � ���⥪��, �ᥣ�� ����� ����㯭묨
        VECT [IF]   IMMEDIATE  ( flag --> )
        VECT [ELSE] IMMEDIATE  ( --> )
        VECT [THEN] IMMEDIATE  ( --> )

\ ����ୠ⨢� [IF] , �ࠡ��뢠�� �� flag = 0
: [IFNOT] ( flag --> ) 0 = [COMPILE] [IF] ; IMMEDIATE

RECENT

\ �᪠�� ᫮�� � ᫮��� ROOT, �᫨ �������, ������ ��� wid
\ ��������� ᫮�� ������ ���� immediate
: qfnd ( --> wid | 0 )
       SP@ >R
       NEXT-WORD [ ALSO ROOT CONTEXT @ PREVIOUS ] LITERAL 1 sFindIn
       imm_word = IFNOT R> SP! FALSE ELSE RDROP THEN ;

\ �ய����� �� ᫮�� �� �室��� ��⮪� ������ �� 㪠������� a
: skipto' ( 'a / .... a --> ' ) >R BEGIN qfnd R@ = UNTIL R> ;

\ �ய����� �� ᫮�� �� �室��� ��⮪�
\ ������ �� ������ �� ���� 㪠������ 'a 'b
: skipto'' ( 'a 'b / .... a|b --> ' )
           2>R BEGIN 2R@ qfnd TUCK = WHILENOT \ ?a
                                   = WHILENOT \ ?b
                 REPEAT RDROP R> EXIT
               THEN 2DROP R> RDROP ;

\ �㭪��, �믮������ ����⢨� [IF]
: [if) ( flag / ... [ELSE] | [THEN] --> )
        DUP >CS ['] [IF] >CS
        IF ELSE ['] [ELSE] ['] [THEN] skipto'' EXECUTE THEN ;

\ �㭪��, �믮������ ����⢨� [ELSE]
: [else) CS@ ['] [IF] =
          IF 1 CSPick IF ['] [THEN] skipto' EXECUTE THEN
           ELSE -1 THROW
          THEN ;

\ �㭪��, �믮������ ����⢨� [THEN]
: [then) CS@ ['] [IF] = IF CSDrop CSDrop ELSE -1 THROW THEN ;

\ ���樠������ ᫮� [IF] [ELSE] [THEN]
 ' [if)   IS [IF]
 ' [then) IS [THEN]
 ' [else) IS [ELSE]

 ?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ 0 [IFNOT] 82704958 [ELSE] 36547236 [THEN] 82704958 <> THROW
  S" passed" TYPE
}test
