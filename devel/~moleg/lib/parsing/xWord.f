\ 11-07-2004 ~mOleg
\ ࠧ��� ��ப � ࠧ��筮�� ���� ࠧ����⥫ﬨ
\ � ⮬ �᫥, ����� ࠧ����⥫� ������ �ᯮ�������

\ ����� �� ��ப� �᫮ � ��⭠����筮� ����
: HCHAR ( addr # -> CHAR ) 0 0 2SWAP >NUMBER IF THROW THEN 2DROP ;

\ ��࠭��� ᯨ᮪ ࠧ����⥫�� �� HERE ������ ������
: +delimiters ( addr --> # )
              BASE @ >R HEX
              >R
              BEGIN PeekChar 0x0A <> WHILE
                    NextWord DUP WHILE
                    HCHAR R@ + -1 SWAP C!
               REPEAT 2DROP
              THEN
              RDROP
              R> BASE !
              ;


\ ᮧ���� ᯨ᮪ ࠧ����⥫��
\ ࠧ����⥫� ������� � 16 ����, ����� ��室����� ⮫쪮 �� ����� ��ப�
: Delimiter: ( | xC xC xC EOL --> )
             CREATE HERE DUP 256 DUP ALLOT ERASE +delimiters
             ( --> addr )
             DOES> ;


: xWord ( delim --> ASC # )
        CharAddr >R
        BEGIN GetChar WHILE
              OVER + C@ 0= WHILE
              >IN 1+!
          REPEAT DUP
        THEN 2DROP
        R> CharAddr OVER -
        ;

\EOF

Delimiter: proba 3A 3B 5B 5D

: test BEGIN proba xWord DUP WHILE
             CR ." ���ᥬ�: " TYPE
                8 SPACES ." ࠧ����⥫�: "
                PeekChar EMIT
                >IN 1+!
       REPEAT 2DROP CR ;

test as[asdasd]dasdv;vkjjl:vlkj;l
