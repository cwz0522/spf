\ 20-05-04            ����᪨� ��ப��� ��६����

\ ᮧ���� ��ப���� ��६�����, ���樠�����㥬�� ⮫쪮 �� �ᯮ�짮�����
\ ���� ��� ��ப� �뤥����� �� HERE
\ �����頥� ���� � ࠧ��� ���� ��� ��ப�
: String  ( # --> )
          CREATE 0 , ,
          ( --> addr # )
          DOES> DUP @     \ ���樠����஢���?
                IF DUP @ SWAP CELL+ @
                 ELSE HERE TUCK OVER ! CELL+ @ DUP 1+ ALLOT ALIGN
                THEN ;


\ ᪮��஢��� ��ப� � Buf, �������� ���� � ����
: CopyZ ( Addr Buf # --> ) 2DUP + >R CMOVE 0 R> C! ;

\ ����஢��� ��ப�, �।�⠢������ � ���� Addr # � ���� ������� #buf
\ �᫨ ������ ��ப� ����� ����, � ��������� �� ����� #buf ᨬ�����
\ � ����� ��ப� �㤥� �।�⠢���� � ���� AscZ
: sCopy ( Addr # Addr #buf --> ) ROT MIN CopyZ ;

\ �������� � ��ப� � ����� ��ப� Asc #, १���� ��ꥤ������ �।�⠢���
\ � ASCIIZ ����. �᫨ ������ ��ப� �ॢ�蠥� ������ ����, � ������塞��
\ ��ப� 㪮���� ⠪, �⮡� ��騩 ࠧ��� �� �ॢ�蠫 ࠧ��� ����.
: sPlus ( Asc # Addr #buf --> ) SWAP ASCIIZ> TUCK + >R - MIN R> SWAP CopyZ ;

\ ������� ��ப� �� ����, ᮧ������� �� String
: sGet ( Addr #buf --> Addr # ) DROP ASCIIZ> ;