\ ������������ �� UTF-8
\ ��. http://ru.wikipedia.org/wiki/Unicode

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE { lib/ext/locals.f
REQUIRE fetchByte ~profit/lib/fetchWrite.f

2 BASE !

: byte ( n -- n1 ) 11111111 AND ;

\ 8-� ��� ��������� �� ���� ��� ���. ����., � �������� ������� ����
: cutBit ( n -- n2 b ) \ b=true ���� ����
DUP 1111111 < SWAP
2* byte SWAP ;

\ addr -- ����� ����������-������� ������� ��������� �� UTF-8 ������������������,
\ � ������ �������� �������� ������� �������� �� ���-�� ���-�� ����
: utf8Next ( addr -- wchar ) >R
R@ fetchByte
cutBit IF ( 0xxxxxxx )
2/
       ELSE
2* byte \ ������ ���� 1, �� �� ���������
cutBit IF ( 110xxxxx )
11 LSHIFT
R@ fetchByte 111111 AND +
       ELSE
cutBit IF ( 1110xxxx )
1000 LSHIFT
R@ fetchByte 111111 AND 110 LSHIFT +
R@ fetchByte 111111 AND +
       ELSE
cutBit IF ( 11110xxx )
1110 LSHIFT
R@ fetchByte 111111 AND 1100 LSHIFT +
R@ fetchByte 111111 AND 110 LSHIFT +
R@ fetchByte 111111 AND +
       ELSE
       THEN
       THEN
       THEN
       THEN
RDROP ;

DECIMAL

\ addr u -- UTF-8 ������������������
\ buf -- �����, � ������� ������������ ������� � ���� ���������� Unicode
\ ��� ��� �� �� ����� �� ������������� ���-�� �������� � UTF-8 ������������������,
\ �� ��� buf ������� �������� u*2 ������. ����� ����������, ������� end, �����
\ ����� ���������
: utf8Decode ( addr u buf -- ) { \ limit [ CELL ] A [ CELL ] B -- end }
B !  OVER A !
+ TO limit
BEGIN
A @ limit > 0= WHILE
A utf8Next B writeWord
REPEAT 
B @ 2 - ; \ end -- ����� ��������� ���������� �������


/TEST
2 BASE !
CREATE a
1010 C, 
11001010 C, 10101010 C,
11101010 C, 10101010 C, 10101010 C,
11110101 C, 10101010 C, 10101010 C, 10101010 C,
DECIMAL

CREATE b 3 2* ALLOT

a 3 b utf8Decode DROP
b 20 DUMP