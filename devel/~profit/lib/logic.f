REQUIRE /TEST ~profit/lib/testing.f

\ : NOT IF FALSE ELSE TRUE THEN ; ( \ ������� ��� ��������
: NOT  0= ;                         \ ������� ��� ���������� ������� )
: <=   > NOT ;
: >=   < NOT ;

/TEST

REQUIRE SEE lib/ext/disasm.f
$> :NONAME CR DUP . NOT IF ." noo!" ELSE ." yay!" THEN ; TRUE OVER EXECUTE  FALSE OVER EXECUTE REST
$> :NONAME CR DUP . IF ." yay!" ELSE ." noo!" THEN ; TRUE OVER EXECUTE  FALSE OVER EXECUTE REST