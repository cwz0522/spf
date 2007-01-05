\ 26-03-2005  ࠡ�� � ⥭��묨 ॣ���ࠬ�
\ 29-03-2005  ⥯��� ᮤ�ন��� ॣ���� ���������� �� �������� OUT,
\             ����� �⮣� �믮������ ᫮�� 㪠������ �� ᮧ����� ⥭�.
\             ��� ��� �������� �ᯮ�짮����, ���ਬ�� ����������
\             ������ ��� ࠡ��� � �������.
\ 02-01-2007  ⥯��� �����஢�� ��� SPF4

0 CELL -- off_action
  CELL -- off_value
  CELL -- off_base
 CONSTANT shadow_rec

\ ᮧ���� ⥭���� ॣ���� ��� ���� base ���樨஢�� ���祭��� n
: Shadow ( Vect n Base --> )
         CREATE HERE shadow_rec ALLOT
		    TUCK off_base !
		    TUCK off_value !
		         off_action !
         DOES> ;

\ ������� shadow �࠭��: [ᮤ�ন���][����][�����]
: pms ( addr --> n Port Vect )
      DUP  off_value @ 
      OVER off_base @
      ROT  off_action @ ;	

\ ��࠭��� ᮤ�ন��� ⥭����� ॣ���� � ॠ��� ॣ����
: Update ( addr --> ) pms EXECUTE ;
 
\ ��⠭����� 㪠����� ���� � ⥭���� ॣ����
: SetH ( mask addr --> ) off_value TUCK @ OR SWAP ! ;
	
\ ����� 㪠����� � ��᪥ ���� � ⥭���� ॣ����
: ResH ( mask addr --> ) off_value SWAP INVERT OVER @ AND SWAP ! ;

\ ������஢��� 㪠����� ���� ⥭����� ॣ����
: FlipH ( mask addr --> ) off_value TUCK @ XOR SWAP ! ;

\ �᭮��� ����樨 � ॣ���ࠬ� - ������� ᮤ�ন��� ⥭����� � ॠ�쭮��
\ ॣ���஢
: SET   ( mask addr --> ) TUCK SetH  Update ;
: RES   ( mask addr --> ) TUCK ResH  Update ;
: FLIP  ( mask addr --> ) TUCK FlipH Update ;

\EOF - ���஢��� � ���ᠭ�� ------------------------------------------------- 

\ �� ࠡ�� � ॠ��� ������� ������ ��������� �����, �� ���� ॣ����, 
\ ����㯭� ⮫쪮 �� ������, �� ��� ᮤ�ন��� ����室���, ��祬 �����筮
\ ��� ����� � �ᯮ�짮����. 

\ �ਬ�� �ᯮ�짮�����:

: ~content CR ." � ॣ���� " . ."  ����ᠭ�: " . ;

HEX

   ' ~content FFFF 345678 Shadow test

    test Update
    FF0000 test SET     .(  ������ ���� FFFFFF )
    00AA00 test RES     .(  ������ ���� FF55FF )
    FEDCBA test FLIP    .(   ������ ����  18945 ) 		 
CR

\ ����� ��ࠧ�� ��� 㪠������� ॣ���� �/� ᮧ������ ⥭���� ॣ����, 
\ � ���஬ ����� �������� ⮫쪮 �⤥��� ���� ��� ��㯯� ���, ��
\ ���ࠣ���� ��⠫��.
\ ����� ���室 ����� �ᯮ�짮���� �� ⮫쪮 �� ࠡ�� � ॣ���ࠬ� 8)


