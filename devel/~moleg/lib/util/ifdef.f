\ 25-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �믮����� ����⢨�, �᫨ ᫮�� �� �������

\ ������ TRUE �᫨ ᫥���饥 ᫮�� ������� � ���⥪��
: ?WORD ( / token --> flag )
        SP@ >R  NextWord SFIND
        IF R> SP! TRUE
         ELSE R> SP! FALSE
        THEN ;

\ �믮����� ᫥���騩 �� token ���, �᫨ token �� ������ � ���⥪��
: ?DEFINED ( / token --> ) ?WORD IF [COMPILE] \ THEN ; IMMEDIATE

\ �믮����� ᫥���騩 �� token ���, �᫨ token ������ � ���⥪��
: N?DEFINED ( / token --> ) ?WORD IF ELSE [COMPILE] \ THEN ; IMMEDIATE

\EOF -- sample --------------------------------------------------------------

?DEFINED A@  : A@ @ ; : A! ! ; : A, , ; : ADDR CELL ;

