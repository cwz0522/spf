\ 26.03.2007

\ ����������, ����� ���������, � ����� ����� ���������� ����������:

: THROW
  DUP 0= IF THROW EXIT THEN

  
  CR OK RP@
  BEGIN DUP R0 @ U> 0= WHILE
    STACK-ADDR.
    CELL+
  REPEAT
  DROP

  THROW
;
