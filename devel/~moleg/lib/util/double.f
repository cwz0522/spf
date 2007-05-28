\ 28-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ࠡ�� � �᫠�� ������� ������

\ ��� ������祭�� ���� 㭨������ ᫮�:
REQUIRE ?:       devel\~moleg\lib\util\ifcolon.f
REQUIRE COMPILE  devel\~moleg\lib\util\compile.f

?: A@ @ ; ?: A! ! ;

\ -- �⥪��� �������樨 ----------------------------------------------------

\ 㤠���� ������� �᫮ � ���設� �⥪� ������
: DDROP ( d --> ) 2DROP ;

\ ����஢��� ������� �᫮ d �� ���設� �⥪� ������
: DDUP ( d --> d d ) 2DUP ;

\ �������� ���⠬� ��� ������� �᫠ �� ���設� �⥪� ������ ���⠬�
: DSWAP ( da db --> db da ) 2SWAP ;

\ ����஢��� �� ���設� �⥪� ������� �᫮,
\ ��室�饥�� ��� ������ �� �� ���設� �⥪�
: DOVER ( da db --> da db da ) 2>R 2DUP 2R> 2SWAP ;

\ 㤠���� ��஥ ������� �᫮, �� ���設� �⥪�
: DNIP ( da db --> db ) 2>R 2DROP 2R> ;

\ ��������� ������� �᫮, ��室�饥�� �� ���設� �⥪� ������ ��� ������ d
: DTUCK ( da db --> db da db ) 2DUP 2>R 2SWAP 2>R ;

\ -- ࠡ�� � ������� -------------------------------------------------------

\ ������� �᫮ ������� ����� �� ����� �� 㪠������� �����
: D@ ( addr --> d ) 2@ ;

\ ��࠭��� �᫮ ������� ����� � ������ �� 㪠������ �����
: D! ( d addr --> ) 2! ;

\ �������஢��� ������� �᫮ �� ���設� ����䠩��
: D, ( d --> ) HERE 2 CELLS ALLOT D! ;

\ -- ����⠭��, ��६����, ���祭�� ������� ����� --------------------------

\ ᮧ���� ���������� ��६����� �࠭���� �᫮ ������� �����
: DVARIABLE ( / name --> ) CREATE 0 0 D, DOES> ;

\ ᮧ���� ���������� ����⠭�� ��� �᫠ ������� ����� d
: DCONSTANT ( d / name --> ) CREATE D, DOES> D@ ;

\ ��⮤ �����祭�� �������� �᫠ �� VALUE ��६����� ������� �����
: DVAL-CODE ( r: addr --> d ) R> A@ 2@ ;

\ ��⮤ ��࠭���� �������� �᫠ � VALUE ��६����� ������� �����
: DTOVAL-CODE ( r: addr d: d --> )
              R> [ CELL CFL + ] LITERAL - A@ 2! ;

\ ᮧ���� ���������� VALUE ��६�����, �࠭���� �᫮ ������� �����
: DVALUE ( d / name --> )
         HEADER
         COMPILE DVAL-CODE HERE >R 0 ,
         COMPILE DTOVAL-CODE ALIGN HERE R> A!
         D, ;

\ ��⮤ �����祭�� �������� �᫠ �� VALUE ��६����� ������� �����
: DUVAL-CODE ( r: addr --> d ) R> A@ TlsIndex@ + 2@ ;

\ ��⮤ ��࠭���� �������� �᫠ � VALUE ��६����� ������� �����
: DTOUVAL-CODE ( r: addr d: d --> )
               R> [ CELL CFL + ] LITERAL - A@ TlsIndex@ + 2! ;

\ ᮧ���� ���짮��⥫���� ���������� ��६����� ������� �����
: USER-DVAL ( --> d )
            HEADER
            COMPILE DUVAL-CODE USER-HERE ,
            COMPILE DTOUVAL-CODE
            2 CELLS USER-ALLOT ;



