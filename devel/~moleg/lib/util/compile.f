\ 21-02-2007 ~mOleg 
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �����, �������� ��� �� ������� � ����

\ ������ �� ��, ��� � ['] name COMPILE,
\ �� ������� ����� �����������, ��� POSTPONE
: COMPILE ( --> ) ?COMP ' LIT, ['] COMPILE, COMPILE, ; IMMEDIATE

\EOF

: sample ." sample " ;

: tst ['] sample COMPILE, ; IMMEDIATE
: ts1 COMPILE sample ; IMMEDIATE

: test tst CR ts1 ;
