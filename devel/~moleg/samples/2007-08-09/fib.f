\ 08-09-2007 ~mOleg
\ �� ��䥪⨢���� ४��ᨢ��� �����⬮�

\ �����ᨢ�� ��ਠ�� ��宦����� n-⮣� �᫠ ��������
\ ������᪨� ��ਠ��, ����� ���� ��� �ਬ�� �ᯮ�짮����� ४��ᨨ
\ ��� ��宦����� n-⮣� �᫠ ��������
: FIBr ( n -- n' )
       DUP 1 >
       IF DUP 1 -
      RECURSE SWAP 2 -
      RECURSE +
       THEN ;

\ ������᪨� ��ਠ�� ��宦����� n-⮣� �᫠ ��������
\ ��� ��ਠ��.
: FIBl ( n --> fib )
       DUP IF 1 - ELSE EXIT THEN
       0 1 ROT
       BEGIN DUP WHILE
             >R OVER + SWAP
             R> 1 -
       REPEAT
       DROP + ;

\ �뢮� �᫠ � ���� ������ n ᨬ�����
: .R ( n # --> )
     >R DUP >R ABS S>D <# #S R> SIGN #> R> OVER - 0 MAX SPACES TYPE ;

\ ����㥬 ��� �����⬠
: testl TIMER@ 2>R FIBl TIMER@ ROT 15 .R SPACE 2R> D- D. SPACE ;
: testr TIMER@ 2>R FIBr TIMER@ ROT 15 .R SPACE 2R> D- D. SPACE ;

\ �ࠢ������ ��� �����⬠ �� ��䥪⨢����
: test 47 0 DO CR I 4 .R
                  I testl
                  I testr
            LOOP ;

\EOF    ����� ᪮�쪮 㣮��� ������� � ⮬, �� �ࠢ����� ������ �����⬮� ��
 ���४⭮, ������, �� ����� �� �⬥��� ⮣� 䠪�, �� ���筮 ��� ��宦�����
 ��������� �᫠ �������� �ਢ������ ������ ४��ᨢ�� ������...  �筮 ⠪
 ��,  ���ਬ��,  ��室  ��ॢ�  ��४�਩  �ᥣ��  �।�⠢�����  ४��ᨢ��
 �����⬮�.

