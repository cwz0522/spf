\ 02-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ���������� ������ ��� �������� ���������� ��������� ����

REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
REQUIRE ADDR     devel\~moleg\lib\util\addr.f
REQUIRE ON-ERROR devel\~moleg\lib\util\on-error.f
REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f

        \ ���������� ��� �������� �������� ����������� � ����������� ����
        USER controls ( --> addr )

        \ ������ ���������� ������ ��� ������ ���� ���� ���������
        0x4000 CONSTANT #compbuf ( --> const )

        \ ����� ���������� ������
        USER-VALUE CompBuf ( --> addr )

        \ ���������� ��� ���������� �������� ������ DP �� CURRENT
        USER save-dp ( --> addr )

\ ������������ ��������� ����������
: rest ( --> )
       save-dp A@ DP !
       0 controls !
       [COMPILE] [ ;

\ ������ ���������� �� ��������� �����
: init: ( --> )
        0 controls A!
        HERE save-dp A!
        CompBuf IFNOT #compbuf ALLOCATE THROW TO CompBuf THEN
    ['] rest ON-ERROR
        CompBuf DP A!
        ] ;

\ ��������� ���������� �� ��������� �����, ��������� ��� ����������
\ ������������ ��������� ��������� ����������
: ;stop ( --> )
        RET,
    EXIT-ERROR rest
        CompBuf EXECUTE ;

FALSE WARNING !

\ ���� ���
\ ��� ����� � ����������� ���������� controls ������������� �� 1
\ ��� ������ �� ����������� - ����������� �� 1
: : 1 controls ! : ;
: ; controls @ 1 = IFNOT -22 THROW THEN  0 controls ! [COMPILE] ; ; IMMEDIATE

TRUE WARNING !

?DEFINED test{ \EOF -- �������� ������� ---------------------------------------

test{ \ ���� ������ ������������ ������������
  S" passed" TYPE
}test



