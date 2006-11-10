\ ��⮬���᪮� ���஢���� ������⥪, ����.
\ 14-10-2006 written by mOleg for SPF4.17 ( mininoleg@yahoo.com )

\ 10-11-2006 �襭�� �஡���� ����ࠡ�⪨ ���ࠫ�� �⠭����� EVAL-WORD
: eval-word
    SFIND ?DUP
    IF
         STATE @ =
         IF COMPILE, ELSE EXECUTE THEN
     ELSE
         S" NOTFOUND" SFIND
         IF EXECUTE
         ELSE 2DROP ?SLITERAL THEN
    THEN ;

\ ᥪ�� ����஥� -----------------------------------------------------------

\ ��������: ���� �� Create �ᥣ�� ������ ���� �᪮�����஢�� !!!

CREATE russian   \ ᮮ�饭�� �� ���᪮� �몥
\ CREATE english   \ select english messages

\ �᫨ �⨬ ���஢��� ��� ���� � �� ��᫥���騥
\ CREATE testing

\ -- ᫮��, ������ �� 墠⠥� � ��� ----------------------------------------

\ � �� �� � : ⮫쪮 ��� ��室�� �� ���設� �⥪� ������ � ���� ��ப�
\ � ���稪��:   S" name" S: ��� ᫮�� ;
: S: ( asc # --> ) SHEADER ] HIDE ;

\ ��६ ��।��� ���ᥬ� �� �� ���, ���� �� ����� ��⮪�
\ � ��砥 ����砭�� ��⮪� �����頥� 0 0 ����� ��ப� � �� ������
\ �������� ���� ���� �� ����32.
: iNextWord ( --> asc # )
            NextWord

            DUP IF EXIT ELSE 2DROP THEN

            REFILL IF RECURSE   \ ����� ����� �뫮 �� ���� NextWord
                    ELSE 0 0
                   THEN ;

\ ��� �⮣� ᫮�� ��� � ���
: IS POSTPONE TO ; IMMEDIATE

\ ---------------------------------------------------------------------------

\ �� ᫮�� �஬� ����䥩��� ���祬 � �⤥��� ᫮����
VOCABULARY tests
           ALSO tests DEFINITIONS

\ ����ਧ��� ��� ᫮� �������� ���� ������� ����� �����㬥�⮢
USER-VECT is-delimiter
USER-VECT action

\ �᭮���� 横�
: process ( --> )
          BEGIN iNextWord DUP WHILE
                2DUP is-delimiter WHILE
               action
           REPEAT 2DROP EXIT
          THEN CR ." test section not finished" CR ABORT ;

\ �饬 ᫮�� ��������㥬�� ��ப�� � ���⥪��
\ ����, ����� � ᯥ樠�쭮� ᫮��� �᪠��: �����-����� settings ?
: ?keyword ( asc " --> flag )
           SFIND
           IF DROP TRUE
            ELSE 2DROP FALSE
           THEN ;

\ ---------------------------------------------------------------------------

\ ���, ���஥ ����稢��� ��⮢�� ᥪ��
: test-delimiter  ( --> asc # ) S" ;test" ;

\ ⠪ ����॥, 祬 ����� ࠧ �᪠�� � ᫮����� ��࠭��⥫� �१ SFIND
: is-test-delimiter ( asc # --> false|nfalse ) test-delimiter COMPARE ;

\ � �� ��㣠� ����ୠ⨢� 8)
: work-delimiter    ( --> asc # ) S" ;work" ;
: is-work-delimiter ( asc # --> false|nfalse ) work-delimiter COMPARE ;

\ � �� �����প� ������ਥ� � �⨫� ����32
: comm-delimiter    ( --> asc # ) S" comment;" ;
: is-comm-delimiter ( asc # --> false|nfalse ) comm-delimiter COMPARE ;

\ � �� �������� ࠧ����� �몮�
: rus-delimiter     ( --> asc # ) S" ;rus" ;
: is-rus-delimiter ( asc # --> false|nfalse ) rus-delimiter COMPARE ;
: eng-delimiter     ( --> asc # ) S" ;eng" ;
: is-eng-delimiter ( asc # --> false|nfalse ) eng-delimiter COMPARE ;

\ ---------------------------------------------------------------------------

        PREVIOUS DEFINITIONS
                 ALSO tests

\ �� �६� ���஢���� ���� ⥪�� ����� ��࠭��⥫ﬨ �����������
\ ��� �ய�᪠����.
\ ����� �ᯮ�짮���� ����� ��।������!
: test: S" testing" ?keyword
         IF    ['] eval-word IS action
          ELSE ['] 2DROP IS action
         THEN
        ['] is-test-delimiter IS is-delimiter
        process ; IMMEDIATE

\ �᫨ ��࠭��⥫� ����祭 �� �室��� ��⮪�, � ����� �� �����-�
\ ��稭�� �ய�饭� ��砫� ᥪ樨 ���஢����
test-delimiter S: CR ." testing delimiters unpaired!" ABORT ; IMMEDIATE


\ ��室�� ����⢨� ����� ���஢����, � ���� �� �६� ���஢����
\ ������ ᥪ�� �믮������� �� �㤥�! �� � ��㣮� �६� �㤥�.
: work: S" testing" ?keyword
         IF    ['] 2DROP IS action
          ELSE ['] eval-word IS action
         THEN
        ['] is-work-delimiter IS is-delimiter
        process ; IMMEDIATE

work-delimiter S: CR ." working delimiters unpaired!" ABORT ; IMMEDIATE


\ �����প� ������ਥ� � �⨫� ����32
: comment: ['] 2DROP IS action
           ['] is-comm-delimiter IS is-delimiter
           process ; IMMEDIATE

comm-delimiter S: CR ." comments unpaired!" ABORT ; IMMEDIATE


\ �����প� �몮�
: rus:  S" russian" ?keyword
         IF    ['] eval-word IS action
          ELSE ['] 2DROP IS action
         THEN
        ['] is-rus-delimiter IS is-delimiter
        process ; IMMEDIATE

: eng:  S" english" ?keyword
         IF    ['] eval-word IS action
          ELSE ['] 2DROP IS action
         THEN
        ['] is-eng-delimiter IS is-delimiter
        process ; IMMEDIATE

rus-delimiter S: CR ." �ய�饭� ��砫� ᥪ樨 rus!" ABORT ; IMMEDIATE
eng-delimiter S: CR ." eng section start is missed!" ABORT ; IMMEDIATE

        PREVIOUS

comment:                     ��� ���� ��� ����

        � �।����� � ������ ��������� ��⠢���� ��� ��� ��⮬���᪮�
 �஢�ન �� ࠡ��ᯮᮡ����. ����� ��ࠧ�� ����� ��⮬���᪨ �஢�����
 ࠡ��ᯮᮡ����� ��� ������⥪, �室��� � ����ਡ�⨢ ����, �� � ᠬ���
 ����. ���⢥��⢥��� �ਤ���� ������� �ਯ�, ����� �㤥� ��ॡ����
 �� ���� � .\devel\~??? � ��⮬���᪨ �� ���������. �訡�� �� ᥡ� �ࠧ�
 ������� 8). � ⮬� �� ����� ���室 ����� �ᯮ�짮���� ��� ��⮬���᪮�
 �����樨 ���ᨩ ����, ࠧ����� �����⬮�.
 �� � ����� ��㣨� �ਬ������ ����� ����.

        ���� � ���஬ �㤥� �஢������� ���஢����, � ⠪ �� ���ﭨ�
 ��६����� state �� ����� �� ࠡ��ᯮᮡ����� �����. �� ���� �����
 ��⠢���� ���� t�st: ;t�st � ������ ��।������, � ����� �ᯮ�짮����
 �⤥�쭮 ��� ࠡ��� � ०��� ������樨. �������� ��� t�st: ;t�st ��
 �।�ᬠ�ਢ����� ⠪ ��� � �⫨稥 �� ����32 � ᫮� ��� �ਧ���� immediatest,
 �� ���� t�st w�rk ����� �।������� � ���� �������묨 ��� � ��㣠.


 16-10-2006. ���������� �����প� ������ਥ� � �⨫� ����32. ����⢥���
             ᥩ�� �� �⠥� ᥪ�� ��������.
 17-10-2006. ���������� ᥪ樨 rus: ;rus eng: ;eng ⥪�� �� ���
             ᥪ権 �㤥� ������஢����� ���� � ��砥, �᫨
             � ���⥪�� �㤥� ������� ᫮�� russian ��� ᫮�� english.
             ���⢥��⢥���, ����稥 ����� ���祢�� ᫮� �ਢ����
             � ������樨 ���� �� ���� ��� ᥪ権.


comment;

        ALSO tests DEFINITIONS

        0 VALUE marker  \ ���������� ��㡨�� �⥪�
        0 VALUE tester  \ ���������� ��㡨�� �⥪� 8)

\ � ����� ��஭� ���ࠢ��� ��ᡠ���� �⥪�?
: ?where ( delta --> )
         0< IF  rus: ." �� �⥪� ��⠢���� ��譨� ���祭��" ;rus
                eng: ." Data stack overflow." ;eng
             ELSE
                rus: ." C� �⥪� ���� ��譨� ���祭��" ;rus
                eng: ." Data stack underflow." ;eng
            THEN ;

\ �஢��塞, �� �뫮 �� ��������� �� �⥪�
: ?changes ( 0x --> flag )
           tester marker - CELL / DUP >R >R
           BEGIN R> 1- DUP WHILE >R
                       0=  WHILE
            REPEAT rus: ." ��������� �� ���設� �⥪� ������ " ;rus
                   eng: ." data stack contents is changed " ;eng
                   2R> -

                   rus: ." �������� " . ." -�� ���祭��." ;rus
                   eng: . ." -th value changed." ;eng

                   EXIT
           THEN RDROP RDROP
           ." �" ;

\ ���� �� ��������� �� �⥪�?
: ?violations ( --> )
              SP@ marker - DUP
              IF ?where
               ELSE DROP ?changes
              THEN ;


        0 VALUE standoff \ ��ࠦ��� ����������� ��� �� �६� included

        PREVIOUS DEFINITIONS
                 ALSO tests

\ ---------------------------------------------------------------------------

\ ��।��塞 ᮡ�⢥��� included
: INCLUDED ( asc # --> )
           0x0D EMIT standoff DUP SPACES 3 + TO standoff

           2>R  SP@ TO tester
            0 0 0 0 0 0 0 0 0 0
           SP@ TO marker

           2R> ." including: " 2DUP TYPE 5 SPACES

           ['] (INCLUDED) CATCH

         standoff 3 - 0 MAX TO standoff

           IF rus: ." �஡���� � ᡮમ� ����." CR ;rus
              eng: ." Can't make the library."   CR ;eng
              ERR-STRING TYPE

            ELSE ?violations
           THEN

    tester SP!
    0x0A EMIT ;

        PREVIOUS

\ ���� �� ����� ���.
: MARKER ( "<spaces>name" -- ) \ 94 CORE EXT
         HERE
         GET-CURRENT ,
         GET-ORDER DUP , 0 ?DO DUP , @ , LOOP
         CREATE ,
         DOES> @ DUP \ ONLY
         DUP @ SET-CURRENT CELL+
         DUP @ >R R@ CELLS 2* + 1 CELLS - R@ 0
         ?DO DUP DUP @ SWAP CELL+ @ OVER ! SWAP 2 CELLS - LOOP
         DROP R> SET-ORDER
         DP ! ;

\ ---------------------------------------------------------------------------

\ ⥯��� ��, �� �⨬ �����஢���, �� �� �⮬, �⨬ �⮡� ��
\ ��⠫��� � ���-��⥬�, ������砥� �⨬ ᫮���.
: testlib ( asc # --> )
          S" MARKER remove " EVALUATE
          INCLUDED
          S" remove" eval-word ;



comment:
        ⥯��� ��� ���஢���� ������⥪� �����筮 �� ��������� �
 ������� S" path\name" testlib. �� �६� ᡮન �������窨 �� ���஢����
 ������ �㤥� ���� � ��砥, �᫨ ���� ���� �� �।�ᬮ�५. �� �஬�
 �⮣� ����஫������� ���樨, ����� ��᫥ ������祭�� �������窨
 �������� ��ᡠ���� �� �⥪� ������: ��९�������\��८����襭�� ����
 ��������� �⥪� �� ��।������� ��㡨�� ( �᫨ �㦭� ��᫥������ ���������
 �⥪� �� �������, 祬 ᥩ�� ��㡨��(10 �祥�), ����室��� 㢥����� ���-��
 �㫥� � included. ��᫥ ������祭�� ���� ᪮�����஢���� ��� 㤠�����.
comment;

\ ---------------------------------------------------------------------------

test: \ ��⮬���᪨ ᥡ� ����㥬, �᫨ ��������� ᮮ⢥�����騩 ����

S" .\lib\include\core-ext.f" testlib
S" .\lib\include\double.f"   testlib
S" .\lib\include\string.f"   testlib
S" .\lib\include\tools.f"    testlib
S" .\lib\include\facil.f"    testlib

;test

comment:

�㦭� �������� �஢��� ������ �⥪� ��� ���� ����� test: ;test
- �뤠���� �।�०�����

�訡��: � ᥪ樨 test: ;test �� ���������� �᫠

comment;