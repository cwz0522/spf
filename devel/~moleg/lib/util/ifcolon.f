\ 31-01-2007 ~mOleg ( mail to: mininoleg@yahoo.com )
\ �������� ᫮�� ?: � ᫥���騬� ᢮��⢠�� - ᫮�� ���������� � ⥪�騩
\ ᫮����, ⮫쪮 �᫨ ��� � ⠪�� �� ������ � ���⥪��.
\ !!! �ᯮ�짮���� � �஬ ���ᨨ �� ���� 4.18 !!!
\ ver 1.2 - ��������� ॠ��� �� ��⥬��� ��६����� WARNING.

VOCABULARY recoil \ �� �஬������ ᫮�� ��࠭塞 � ᮡ�⢥��� ᫮����
           ALSO recoil DEFINITIONS

        \ ��࠭����� ������ ��� �⪠� � �ਧ��� �� ����
        USER unique-flag

        \ ��������� ⥪�騩 sheader ��⥬�
        ' SHEADER BEHAVIOR ->VECT std-sheader

\ 㤠���� ��᫥���� ��।������� ᫮�� �� ⥪�饣� ᯨ᪠
: unlink ( --> ) LATEST CDR GET-CURRENT ! ;

\ �᫨ ��᫥���� ᫮�� �㦭� �⬥���� - �⬥�塞 ���.
: ?cut ( --> )
       unique-flag @
       IF unlink
          unique-flag @ HERE - ALLOT
          unique-flag 0!
       THEN ;

\ ᮧ���� ���� ���������, �᫨ ����室���, �⬥���� ��஥ ᫮��
: (sHeader) ( asc # --> ) ?cut std-sheader ;

\ �᫨ ᫮�� 㭨���쭮 - ������ 0 � ���� ��ப�
\ ���� ������ ���� ��� �⪠�, � ���� ���⮩ ��ப�.
: ?namex ( / name --> here|0 asc # )
         NextWord SFIND
         IF DROP S" _" HERE  ELSE FALSE  THEN
         -ROT ;

ALSO FORTH DEFINITIONS \ ��� ᫮�� ���� � ������ ᫮���� SPF

\ � �� �� � : ⮫쪮 ��� ��室�� �� ���設� �⥪� ������
\ � ���� ��ப� � ���稪��. �ਬ��:  S" name" S: ��� ᫮�� ;
: S: ( asc # --> ) SHEADER ] HIDE ;

\ �������� ᫮�� � ⥪�騩 ᫮����, ⮫쪮 �᫨ � ���⥪�� ��� ᫮��
\ � ⠪�� �� ������.
: ?: ( --> )
     WARNING @ IF ?namex ELSE FALSE NextWord THEN
     S:   unique-flag ! ;

 ' (sHeader) TO SHEADER  \ ⥯��� ��ࠡ��뢠�� �⪠��

PREVIOUS PREVIOUS

\EOF -- ��⮢�� ᥪ�� -----------------------------------------------------

                           TRUE WARNING !
VOCABULARY testing
           ALSO testing DEFINITIONS

?: test ( --> ) ."  first test sample" CR ;
?: test ( --> ) ."  second test sample" CR ;
    CREATE sample
?: test ( --> ) ."  thrid test sample" CR ;
 : eotest ( --> )
          ." ������ ���� �ᥣ� �� ᫮�� � ᫮���: test, eotest � sample" CR
          WORDS
          ." ������ ���� �믮���� ���� test : "
          test
          ; eotest

                        PREVIOUS DEFINITIONS
CR CR
                              WARNING 0!

VOCABULARY testing
           ALSO testing DEFINITIONS

?: test ( --> ) ."  first test sample" CR ;
?: test ( --> ) ."  second test sample" CR ;
    CREATE sample
?: test ( --> ) ."  thrid test sample" CR ;
 : eotest ( --> )
          ." ������ ���� �� ���� ᫮� � ⥪�饬 ᫮���" CR
          WORDS
          ." ������ ���� �믮���� ��⨩ test : "
          test
          ; eotest


\EOF
     ������ �㦥� ������让 ����� ᫮�, ����� ����� ���� � ��⥬�,
� ����� � �� ����, � ��������� �������⥫�� 䠩�� �� �����...

� ⠪�� ��砥 ����㯠�� ᫥���騬 ��ࠧ��: ������砥� ������ ���� 8),
�� ᮬ��⥫�� ᫮�� ��稭��� �� � : � � ?: � ��!!!  �8)

������, �� ᫮�� ��稭��饥�� � :? ᮡ�����, �� ��⮬ ���㤥��� 8)
�᫨, ����筮 � ��⥬� 㦥 ���� ᫮�� � ⠪�� ������, � �᫨ ���
⠪��� �����, � ᫮��, ᮮ⢥��⢥���, ��⠭����. �� �����, ��
�� ����� ᬥ�� �ᯮ�짮���� ��直� IMMEDIATE ��᫥ ; !!!
������ ⠪ �������� ���, 祬 �ᯮ�짮���� [UNDEFINED] ��� REQUIRE.

��, ᫮�� ���뢠���� ⮫쪮, ����� ��稭��� ��।������� ᫥���饥.

�������� ��� ���������� ����� �ࠢ���� � ������� ��⥬��� ��६�����
WARNING - �� ��⠭���� �⮩ ��६����� ����୮� ��।������ ᫮��
          ����頥���, � �� ��⠭�������� � 0 ��८�।������ �ந�室��.
