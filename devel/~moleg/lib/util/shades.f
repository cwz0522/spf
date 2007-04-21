\ 26-03-2005 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ � �������� ����������

 0 CELL -- off_action
   CELL -- off_value
   CELL -- off_base
 CONSTANT shadow_rec

\ ������� ������� ������� ��� ����� base ����������� ��������� n
: Shadow ( Vect n Base / name --> )
         CREATE HERE shadow_rec ALLOT
                    TUCK off_base !
                    TUCK off_value !
                         off_action !
         DOES> ;

\ ��������� shadow ������: [����������][�����][������]
: pms ( addr --> n Port Vect )
      DUP  off_value @
      OVER off_base @
      ROT  off_action @ ;

\ ��������� ���������� �������� �������� � �������� �������
: Update ( addr --> ) pms EXECUTE ;

\ ���������� ��������� ���� � ������� ��������
: SetH ( mask addr --> ) off_value TUCK @ OR SWAP ! ;

\ �������� ��������� � ����� ���� � ������� ��������
: ResH ( mask addr --> ) off_value SWAP INVERT OVER @ AND SWAP ! ;

\ ������������� ��������� ���� �������� ��������
: FlipH ( mask addr --> ) off_value TUCK @ XOR SWAP ! ;

\ �������� �������� � ���������� - �������� ���������� �������� � ���������
\ ���������
: SET   ( mask addr --> ) TUCK SetH  Update ;
: RES   ( mask addr --> ) TUCK ResH  Update ;
: FLIP  ( mask addr --> ) TUCK FlipH Update ;

\EOF - ����������� � �������� -------------------------------------------------

\ ��� ������ � �������� ������� ������ ��������� ��������, ��� ���� �������,
\ ��������� ������ �� ������, �� ��� ���������� ����������, ������ ����������
\ ����� ����� � ������������.

\ ������ �������������:

: ~content CR ." � ������� " . ."  ��������: " . ;

HEX

   ' ~content FFFF 345678 Shadow test

    test Update
    FF0000 test SET     .(  ������ ���� FFFFFF )
    00AA00 test RES     .(  ������ ���� FF55FF )
    FEDCBA test FLIP    .(   ������ ����  18945 )
CR

\ ����� ������� ��� ���������� �������� �/� ��������� ������� �������,
\ � ������� ����� �������� ������ ��������� ���� ��� ������ ���, ��
\ ���������� ���������.
\ ������ ������ ����� ������������ �� ������ ��� ������ � ���������� 8)


