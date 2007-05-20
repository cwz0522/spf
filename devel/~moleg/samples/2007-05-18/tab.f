\ 18-05-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �襭�� ����� � ������� ����⮣� �� ��㬥
\ �८��������� ᨬ����� ⠡��権 � �஡��� � ���⭮

\ -- ������� ᫮�� ---------------------------------------------------------

\ �������� �᫮ � ��室�饬��� �� �⥪� �����⮢
: R+ ( r: a d: b --> r: a+b ) 2R> -ROT + >R >R ;

\ १�ࢨ஢��� �� HERE n ���� �����, ��������� �� ���⮬ char �
: ALLOTFILL ( n char --> ) HERE OVER ALLOT -ROT FILL ;

\ ��ࠢ���� �᫮ base �� 㪠������ ���祭�� n �
\ �࠭�� ��ࠢ������� �ந����쭠�.
\ ��ࠢ������� �ந�������� � ������� ��஭�
: ROUND ( n base --> n ) TUCK 1 - + OVER / * ;



   0x09 CONSTANT tab_  \ ��� ᨬ���� ⠡��樨

\ -- �ନ஢���� १������饩 ��ப� -------------------------------------

        USER-VALUE buffer  \ ���� �६������ ����
        USER-VALUE out>    \ ������ � ���ன ����� ��������� ����� � ����

     20 CONSTANT tab-limit \ �।���� ࠧ��� ⠡��樨

   CREATE spaces_ tab-limit BL ALLOTFILL \ ��ப� �஡����

\ ���������� � ���� ��ப� asc # � 㦥 ����騬��
: >out ( asc # --> ) DUP IF out> SWAP 2DUP + TO out> CMOVE ELSE 2DROP THEN ;
: c>out ( char --> ) out> TUCK C! 1 CHARS + TO out> ;

\ �뢥�� � ���� 㪠������ ���-�� �஡����
: gap ( # --> ) spaces_ SWAP tab-limit UMIN >out ;

\ ������� ���� � ������ ᮡ࠭��� � ���� ��ப�
: result> ( --> asc # ) buffer out> OVER - ;

\ �᢮�������� ����
: free-result ( --> ) buffer IF buffer FREE THROW 0 TO buffer THEN ;

\ ���樠������ ����
: init-buffer ( # --> )
              free-result
              CELLS ALLOCATE THROW
              DUP TO buffer TO out> ;

\ -- �८�ࠧ������ ⠡��権 � �஡��� -------------------------------------

\ ������� ������⢮ �஡���� �� ���� ⠡���� ��� 㪠����� ����樨
: space# ( pos tab# --> spaces )
         TUCK OVER >R ROUND R> -
         DUP IF NIP ELSE DROP THEN ;

\ �뤥���� �� ��ப� �����ப�, ����稢������� 㪠����� ᨬ�����
: piece ( src # char --> res # )
        >R OVER + OVER
        BEGIN 2DUP <> WHILE       \ ���� ���� ᨬ���� � ��ப�
              DUP C@ R@ <> WHILE  \ ���� ᨬ��� �� ������
            1 CHARS +
          REPEAT
        THEN RDROP NIP OVER - ;

\ ࠧ������ ��ப� �� ��� �����ப� �� ᨬ���� char
: split ( src # char --> rest # res # )
        >R 2DUP R> piece TUCK 2>R - NIP 2R@ + SWAP 2R> ;

\ ������ ��᫥����� ᨬ���� � ��室��� ����
: pos ( --> u ) out> buffer - ;

\ �८�ࠧ����� �������� ��ப�,
\ ᮤ�ঠ��� ᨬ���� ⠡��樨 � ��ப� � �஡�����
: tabs>spaces ( src # tab# --> res # )
              OVER init-buffer >R
              BEGIN tab_ split >out  DUP WHILE
                    pos R@ space# gap
                  SKIP1
              REPEAT RDROP 2DROP result> ;

\ -- �८�ࠧ������ �஡���� � ⠡��樨 ------------------------------------

        USER inpos \ ⥪��� ������

\ ������� ������⢮ �஡���� �� ��砫� ��ப�
: count-spaces ( asc # --> res # n )
               0 >R OVER + SWAP
               BEGIN 2DUP <> WHILE     \ ���� �� ����� ��ப�
                     DUP C@ BL = WHILE \ ���� �஡���
                   1 R+ 1 CHARS +
                 REPEAT
               THEN TUCK - R> ;

\ �८�ࠧ����� �஡���, �᫨ �������� � ⠡��樨
: convert-spaces ( pos n tab# --> )
                 >R BEGIN DUP WHILE
                          OVER R@ space#  2DUP < 0= WHILE
                          DUP inpos +!
                          TUCK - >R + R>
                        tab_ c>out
                      REPEAT SWAP DUP inpos +! gap
                    THEN RDROP 2DROP ;

\ �८�ࠧ����� �������� ��ப� src #, ᮤ�ঠ��� �஡���
\ � ��ப� ᮤ�ঠ��� ⠡��樨 ����� ���室��� �������
\ ��᫥����⥫쭮�⥩ �஡����.
: spaces>tabs ( src # tab# --> res # )
              OVER init-buffer >R  0 inpos !
              BEGIN BL split DUP inpos +! >out  DUP WHILE
                    count-spaces inpos @
                    SWAP R@ convert-spaces
              REPEAT RDROP 2DROP result> ;

\ EOF -- ��⮢�� ᥪ�� ----------------------------------------------------

\ ����㧨�� ᮤ�ন��� 䠩�� � �����
: source ( FileName # --> addr # )
         R/O OPEN-FILE THROW >R
           R@ FILE-SIZE THROW DROP
              DUP ALLOCATE THROW
           TUCK SWAP R@ READ-FILE THROW
         R> CLOSE-FILE THROW ;

S" sample.txt" source
              2DUP TYPE 2DUP DUMP CR
8 tabs>spaces 2DUP TYPE 2DUP DUMP CR
8 spaces>tabs 2DUP TYPE DUMP CR

