\ 21-01-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ���� ᫮�� � 㪠������ ᯨ᪥ ᫮��३

 REQUIRE WHILENOT devel\~moleg\lib\util\control.f
 REQUIRE FRAME    devel\~mOleg\lib\util\stackadd.f

\ ���� � ������ �᪮���� ᫮�� �㤥� ������ �����.
CREATE word-to-find 2 CELLS ALLOT ( --> addr )

\ ���� ᫮�� � 㪠������ ᯨ᪥ ᫮��३
\ ��� xt ��᫥ �믮������ ���᪠ ����� ������
\ �ந����쭮� ������⢮ ��ࠬ��஢
: sFindIn ( asc #  vidn ... vidb vida #  --> asc # false | ?? xt imm )
          N>R word-to-find 2!
          BEGIN R@ WHILE
                word-to-find 2@  2R> 1 - >R
                SEARCH-WORDLIST DUP WHILENOT
               DROP
            REPEAT NR> nDROP EXIT
          THEN RDROP
          word-to-find 2@ FALSE ;

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ \ ��� ���� �஢�ઠ �� ᮡ�ࠥ�����.
  S" passed" TYPE
}test
