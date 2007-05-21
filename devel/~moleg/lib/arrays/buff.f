\ 19-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������������ ������������� ������

  \ ��������� ������
  0 CELL -- off-place     \ ������� ������� ���������� ������� � ������
    CELL -- off-limit     \ ���������� ������ ������
    0    -- off-space     \ ������ ������������ ������
  CONSTANT /buffer        \ ������ ������ ������

\ ������� ����� ��������� �����
: Buffer ( # --> buf )
         /buffer + 0x1000 ROUND  DUP ALLOCATE THROW
         0 OVER off-place !  >R /buffer - R@ off-limit ! R> ;

\ ������� ����� ������ ������ � ��� ���������� �����
: Buffer> ( buf --> asc # ) DUP off-space SWAP off-place @ ;

\ �������� ���������� ������ asc # � �����
: >Buffer ( asc # buf --> flag )
          2DUP off-place @ +            \ asc # buf #+#
          OVER off-limit @ OVER >       \ asc # buf #+# flag
          IF OVER off-place ACHANGE     \ asc # buf disp
             + off-space SWAP CMOVE
             TRUE
           ELSE 2DROP 2DROP
             FALSE
          THEN ;

\ �������� ���������� ������.
: Clean ( buf --> ) 0 SWAP off-place ! ;

\ ���������� ������ ���������� �������
: retire ( buf --> ) FREE THROW ;

\EOF -- �������� ������ -----------------------------------------------------

1 Buffer VALUE zzzz

S" s" BEGIN 2DUP zzzz >Buffer WHILE REPEAT 2DROP
zzzz Buffer> SWAP . .
zzzz Buffer> DUMP
