\. 21-07-2004 ॠ������ �ᯮ������ ���ᨢ�� ��� �����ਯ�

Unit: eArray

\ ���������������������������������������������������������������������������

\      5 CONSTANT nesting

CREATE nStack 0 , nesting CELLS ALLOT

: n-- ( --> )
      nStack DUP @
      IF 1-!
       ELSE TRUE ABORT" n underflow!"
      THEN ;

: n++ ( --> )
      nStack DUP @ nesting <
      IF 1+!
       ELSE TRUE ABORT" n overflow!"
      THEN ;

: nd  ( --> ) nStack @ ;
: na  ( --> ) nStack DUP @ CELLS + ;
: n>  ( --> ) na @ DP !  n-- ;
: >n  ( --> ) n++ HERE na ! ;

\ ���������������������������������������������������������������������������

\    1000 CONSTANT def#

F: :def ( --> addr )
       def# ALLOCATE THROW
       >n DP ! :NONAME ;F

F: ;def ( addr --> addr )
       [COMPILE] ;
       HERE OVER - RESIZE THROW
       n> nd IF ] THEN
       ;F
EndUnit

\EOF

\ ����� ���ᠭ�� �ᯮ��塞��� ���ᨢ�
: { % ( --> addr )
    eArray :def ; IMMEDIATE

\ �������� ���ᠭ�� �ᯮ��塞��� ���ᨢ�
: } % ( addr --> obj )
    eArray ;def
    psObject token
    ?compName
    ; IMMEDIATE
