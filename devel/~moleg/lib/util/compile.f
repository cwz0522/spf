\ 21-02-2007  �����, �������� ��� �� ������� � ����

\ ������ �� ��, ��� � ['] name COMPILE,
\ �� ������� ����� �����������, ��� POSTPONE
: COMPILE ( --> ) ?COMP ' LIT, ['] COMPILE, COMPILE, ; IMMEDIATE

\EOF

: sample ." sample " ;

: tst ['] sample COMPILE, ; IMMEDIATE
: ts1 COMPILE sample ; IMMEDIATE

: test tst CR ts1 ;
