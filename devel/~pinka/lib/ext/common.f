REQUIRE [UNDEFINED] lib\include\tools.f

[UNDEFINED] NDROP [IF]

\ ����� �� ���� n, ����� ������ n �������� �� �����.

: NDROP ( x*n n -- )  1+ CELLS SP@ + SP! ;

[THEN]
