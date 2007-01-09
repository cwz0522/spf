\ 28-12-2006
\ �����塞 ��㤮��� SFIND �� ����� ������
\ ���冷� ᫥������� ��ࠬ��஢ ⥯��� �㤥� ᫥���騬:
\ ( asc # --> asc # false | wid imm true )
\ � ���� �ᥣ�� �����頥� �� �᫠!
\ ���� �����頥� ��砫��� ��ப� � �ਧ����� false
\ ���� - ���� 䫠�_immediate true

S" tools.f" INCLUDED  \ ����� ����, �� ⮣�� �㦭� 㡨��� � �� [IF]-� � �.�.

\ � ���4 - �� ᫮�� ࠡ�⠥� �� �祭� ��୮ - ��८�।����
: ?IMMEDIATE ( NFA -> F ) NAME>F C@ &IMMEDIATE AND 0<> ;

\ 㤠���� � ���設� �⥪� 㪠������ �᫮ ��ࠬ��஢
: nDROP ( [ .. ] n --> ) 1+ CELLS SP@ + SP! ;

\ ______________________________________________________________________________

\ �뤠�� ���� � ������ �����䨪��� �����.
\ �� ��� ⢮���⢮ ����� � ����� �� ������ ॣ����
: id>asc ( NFA --> asc # ) DUP 1+ SWAP C@ ;

\ �ࠢ���� ����祭��� ���ᥬ� � ������ ᫮��
\ ⠪ ��� ������ ���, �᫨ ��������� �ଠ� ᫮��୮� ����
: identify ( asc # nameid --> flag )
           id>asc 2SWAP COMPARE ;

\ �����誠 �� ��砩 ��஢����� ᫮��३
\ �ᯮ���� ���ᥬ� � id ᫮���� ���� ���� ��砫� 楯�窨 ᫮�, � ���ன
\ ����室��� �᪠�� ᫮��. ������ ��᫠ �� �����, ⠪ ��� ��⨬�����
\ ��ࠢ�� ����⠢�� @ � ���.
: hashname ( asc # wid --> asc # link ) @ ;

\ ���� ᫮�� � 㪠������ ᫮���
\ ⮦� ���塞 ���冷� ��ࠬ��஢, �� ��� 祣� ᮪�頥��� ࠧ��� ᫮��.
: search-wordlist  ( asc # voc-id -- asc # false | xt imm_flag true )
                   hashname
                   BEGIN DUP WHILE
                         >R 2DUP R@ identify WHILE
                         R> CDR
                   REPEAT
                     2DROP R@ NAME>C @
                           R> ?IMMEDIATE TRUE
                   THEN ;

\ �� �室� ᯨ᮪ ᫮��३, � ������ �㦭� ���� ���� � �� ���-��
\          � ��ப� - �����䨪��� �����
\ �� ��室� � ��砥 ���ᯥ� ��ப� � false
\           � ��砥 �ᯥ� �ᯮ����� ���� ᫮�� � ��� 䫠��
\           immediate � true
: sfindin ( vidn ... vidb wida #  asc # --> asc # false | xt imm_flag true )
          ROT BEGIN DUP WHILE 1- >R  \ ���-�� ᫮��३ ��� ��ᬮ�� �� R
                    ROT search-wordlist 0= WHILE \ ���� �� WHILENOT
                    R>
               REPEAT
                 R> -ROT 2>R nDROP 2R> TRUE
                 \ ������� �㤥� �� �⥪�� 8) �� ��� ���� �����.
              THEN ;
\ sfindin ᤥ��� ������ ��� ⮣�, �⮡� ����� ����������� �᪠�� � ���������
\ ᫮��३, � �� ⮫쪮 � ���⥪��.

\ ���� ᫮�� � ���⥪��
: sfind ( addr u -- addr u 0 | xt imm true )
        2>R GET-ORDER 2R> sfindin ;

\ ���� ���� ᫮��, �।�⠢������� ��ப�� � ⥪��
\ ��᫥ ' � ⥪�饬 ���⥪��.
\ �����頥� ����, � ��砥 ����宦����� ᫮�� ��������� �᪫�祭��
: ' ( "<spaces>name" -- xt )
    NextWord sfind
    IF DROP           \ �ਧ��� immediate ��� �� �㦥�
     ELSE -321 THROW
    THEN ;

\ ���� ᫮��, �᫨ ������ �ᯥ譠 ᪮�����஢��� ��� ���� � ⥪�饥
\ ᮡ�ࠥ��� ��।������.
: ['] ( name | --> )
      ?COMP ' LIT,
      ; IMMEDIATE

\ �믮����� ����⢨�, ᮣ��᭮ ��६����� state
: stateact ( xt imm_flag --> )
           STATE @ > IF COMPILE, ELSE EXECUTE THEN ;

\ ������஢��� ᫮��, �।�⠢������ ��ப��
\ �믮����� ����⢨�, ᮣ��᭮ ���ﭨ� STATE
\ �������� ����筮 ������ ⠪��, ⠪ ��� ��� ��࠭�� �����,
\ �� �饬 ������ ᫮��, � �� ����� �� �室� �����.
: eval-name ( asc # --> )
            sfind IF stateact
                   ELSE -2003 THROW
                  THEN ;

\ ������஢��� ���ᥬ� ( ᫮�� ��� �᫮ ) �।�⠢������ ��ப��
\ �믮����� ����⢨�, ᮣ��᭮ ���ﭨ� STATE
: eval-word ( asc # --> )
            sfind IF stateact
                   ELSE ?SLITERAL
                  THEN ;

\ ��� ����� ����� - � ��� ᭠砫� ����� ᫮��, �᫨ ��� �� �������
\ �� ������ NOTFOUND, � �믮��塞 ��� - ���� ��⠥��� ������ �᫮.
\ �� ��� � ��砥, �᫨, ���ਬ�� �᫠ ��� �㦭� ��४����, ��
\ ���� �� notfound ����� ���� �����筮 ������, � ⮬� �� � ��砫�
\ �⠭���⭮�� NOTFOUND-� ᭠砫� ����� �᫮, ���� ��⥬ ��⠥���
\ ��-� ��㣮� ��������. - ⠪ ����砥��� ����॥ ࠧ��� �ᥫ (���
\ ���᪠ �� ᫮���� NOTFOUND-a), �� �᫠, ���ਬ�� ����� �������
\ ��� �ᯮ����� ���-� ����. ��� �᪮७�� ��ࢮ�� ��ਠ�� �����
\ ��� ������� ᫮���� �࠭��� ��᫥���� ��।������ NOTFOUND � �⤥�쭮�
\ �祩��, � @ ?EXECUTE ��� ���. ���� ⮫쪮 � ⮬, �� ��� �᪫�祭��
\ �㦭� ��ࠡ��뢠��, � �� ���஬������ ��� � ����� ���� ��⮬
\ �����������. ��� �� � �� ��ன ��ਠ��, ��� �� � ����� �⠭�����.

TRUE [IF] \ �� ��ਠ�� ��������� �⠭���⭮��

\ �뤥��� � �⤥�쭮� ᫮��, ��祬� �� � ���?
\ �� ����� ���짮������, �᫨ ��࠭�� �����⭮, �� �� �室� ��-�
\ ���⠭���⭮� ���� �� �᫮.
: notfound ( asc # --> )
           S" NOTFOUND" sfind
           IF DROP EXECUTE
            ELSE 2DROP ?SLITERAL
           THEN ;

\ ������஢��� �室��� ��⮪ �� �� ���, ���� �� �� ���������
\ �����, �᫨ �� �� NOTFOUND - � �뫮 �� ����� ���� � ��ᨢ�:
\ : interpret  BEGIN NextWord DUP WHILE eval-word ?STACK REPEAT 2DROP ;

: interpret ( -> )
            BEGIN NextWord  DUP WHILE
                  ['] eval-name CATCH
                  IF notfound THEN
                  ?STACK
            REPEAT 2DROP ;


[ELSE] \ �� � ��������� ���浪�� ᫥������� ?sliteral & notfound

: notfound ( asc # --> )
           S" NOTFOUND" sfind
           IF DROP EXECUTE
            ELSE -2003 THROW
           THEN ;

: interpret ( -> )
            BEGIN NextWord DUP WHILE
                  ['] eval-word CATCH \ ��� ᭠砫� ��� ��� �᫮
                  IF notfound THEN    \ � ���� ��⥬ NOTFOUND
                  ?STACK
            REPEAT 2DROP ;
[THEN]

\ EOF ᮢ���⨬���� � �⠭����� �����

\ �� ��� ᮢ���⨬��� � ���� ��
: SEARCH-WORDLIST1 ( asc # voc-id -- asc # false | xt -1/1 )
                   search-wordlist

                   IF IF 1 ELSE -1 THEN \ ��� �। ���� � �� ��砥 ��-��
                    ELSE FALSE          \ ⮣�, �� 䫠� ᫮��� ����砥���
                   THEN ;

: SFIND ( --> )
        2>R GET-ORDER 2R> sfindin
        IF IF 1 ELSE -1 THEN        \ � �� ᠬ��.
         ELSE FALSE
        THEN ;

\ ���� ��� �������, �� ⠪ ������� ����筥�
: EVAL-WORD ( asc # --> ) eval-name ;

\EOF ��⮢�� ᥪ��

CR CR S" �஢�ઠ ���᪠ � ᫮��� � ������� search-wordlist" TYPE CR

: ok~ ." �ᯥ譮" ;

S" adas" 2DUP TYPE FORTH-WORDLIST search-wordlist
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" ok~" 2DUP TYPE FORTH-WORDLIST search-wordlist
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

IMMEDIATE
S" ok~" 2DUP TYPE FORTH-WORDLIST search-wordlist
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" ok~" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

VOCABULARY TEST
           ALSO TEST DEFINITIONS

S" ok~" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" sdad" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

: ~test ." �ᯥ譮" ;

S" ~test" 2DUP TYPE sfind
    [IF]     S"  �������" TYPE
      [IF]     S"  imm " TYPE
       [ELSE]  S"  std " TYPE
      [THEN]   EXECUTE CR
     [ELSE] S"  �� ������� " TYPE SWAP . SPACE . CR
    [THEN]

S" ' ~test " TYPE ' ~test EXECUTE CR

S" eval-name " TYPE S" ~test" eval-name CR

IMMEDIATE S" eval-name " TYPE S" ~test" eval-name CR

: tev NextWord eval-name ; IMMEDIATE

: ~nott ." nott" ;

S" : test tev ~nott ; " TYPE : test tev ~nott ; CR
S" : testa tev ~test ; " TYPE : testa tev ~test ; CR

S" 12345678 eval-word " TYPE S" 12345678" eval-word . CR


interpret S" interpret " TYPE  ~test CR

\ � �᭮���� �� ࠡ�⠥�.



