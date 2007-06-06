\ 28-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ������� ������� ������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f
 REQUIRE ADDR     devel\~moleg\lib\util\addr.f

\ -- �������� ����������� ----------------------------------------------------

\ ������� ������� ����� � ������� ����� ������
: DDROP ( d --> ) 2DROP ;

\ ���������� ������� ����� d �� ������� ����� ������
: DDUP ( d --> d d ) 2DUP ;

\ �������� ������� ��� ������� ����� �� ������� ����� ������ �������
: DSWAP ( da db --> db da ) 2SWAP ;

\ ���������� �� ������� ����� ������� �����,
\ ����������� ��� ������� �� �� ������� �����
: DOVER ( da db --> da db da ) 2>R 2DUP 2R> 2SWAP ;

\ ������� ������ ������� �����, �� ������� �����
: DNIP ( da db --> db ) 2>R 2DROP 2R> ;

\ ��������� ������� �����, ����������� �� ������� ����� ������ ��� ������ d
: DTUCK ( da db --> db da db ) 2DUP 2>R 2SWAP 2>R ;

\ -- ������ � ������� -------------------------------------------------------

\ ������� ����� ������� ����� �� ������ �� ���������� ������
: D@ ( addr --> d ) 2@ ;

\ ��������� ����� ������� ����� � ������ �� ��������� ������
: D! ( d addr --> ) 2! ;

\ ������������� ������� ����� �� ������� ���������
: D, ( d --> ) HERE 2 CELLS ALLOT D! ;

\ -- ���������, ����������, �������� ������� ����� --------------------------

\ ������� ���������� ���������� �������� ����� ������� �����
: DVARIABLE ( / name --> ) CREATE 0 0 D, DOES> ;

\ ������� ���������� ��������� ��� ����� ������� ����� d
: DCONSTANT ( d / name --> ) CREATE D, DOES> D@ ;

\ ����� ���������� �������� ����� �� VALUE ���������� ������� �����
: DVAL-CODE ( r: addr --> d ) R> A@ 2@ ;

\ ����� ���������� �������� ����� � VALUE ���������� ������� �����
: DTOVAL-CODE ( r: addr d: d --> )
              R> [ CELL CFL + ] LITERAL - A@ 2! ;

\ ������� ���������� VALUE ����������, �������� ����� ������� �����
: DVALUE ( d / name --> )
         HEADER
         COMPILE DVAL-CODE HERE >R 0 ,
         COMPILE DTOVAL-CODE ALIGN HERE R> A!
         D, ;

\ ����� ���������� �������� ����� �� VALUE ���������� ������� �����
: DUVAL-CODE ( r: addr --> d ) R> A@ TlsIndex@ + 2@ ;

\ ����� ���������� �������� ����� � VALUE ���������� ������� �����
: DTOUVAL-CODE ( r: addr d: d --> )
               R> [ CELL CFL + ] LITERAL - A@ TlsIndex@ + 2! ;

\ ������� ���������������� ���������� ���������� ������� �����
: USER-DVAL ( --> d )
            HEADER
            COMPILE DUVAL-CODE USER-HERE ,
            COMPILE DTOUVAL-CODE
            2 CELLS USER-ALLOT ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ 1 DEPTH NIP
       1 2 2DUP DVALUE sample sample D= 0= THROW
       3 4 2DUP TO sample sample D= 0= THROW

       USER-DVAL simple
       4 5 2DUP TO simple  simple D= 0= THROW
       6 7 2DUP DCONSTANT proba proba D= 0= THROW
       7 8 2DUP DVARIABLE test test 2!  test 2@ D= 0= THROW
      DEPTH <> THROW
  S" passed" TYPE
}test


