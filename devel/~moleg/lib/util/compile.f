\ 21-02-2007  ᫮��, ���ண� ��� �� 墠⠥� � ����

\ ������ � ��, �� � ['] name COMPILE,
\ �� ��ࠧ�� ����� �������筮�, 祬 POSTPONE
: COMPILE ( --> ) ?COMP ' LIT, ['] COMPILE, COMPILE, ; IMMEDIATE

\EOF

: sample ." sample " ;

: tst ['] sample COMPILE, ; IMMEDIATE
: ts1 COMPILE sample ; IMMEDIATE

: test tst CR ts1 ;
