\ 02-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �����প� �६������ ���� ��� ᮧ����� ����ﭭ�� �६����� ᫮�

REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
REQUIRE ADDR     devel\~moleg\lib\util\addr.f
REQUIRE ON-ERROR devel\~moleg\lib\util\on-error.f
REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f

        \ ��६����� ��� ����஫� ��୮�� ���뢠��� � ����뢠��� ᫮�
        USER controls ( --> addr )

        \ ࠧ��� �६������ ���� ��� ᡮન ᫮� ���� ����䠩��
        0x4000 CONSTANT #compbuf ( --> const )

        \ ���� �६������ ����
        USER-VALUE CompBuf ( --> addr )

        \ ��६����� ��� �६������ �࠭���� ���� DP �� CURRENT
        USER save-dp ( --> addr )

\ ����⠭����� ��⥬�� ��६����
: rest ( --> )
       save-dp A@ DP !
       0 controls !
       [COMPILE] [ ;

\ ����� ��������� �� �६���� ����
: init: ( --> )
        0 controls A!
        HERE save-dp A!
        CompBuf IFNOT #compbuf ALLOCATE THROW TO CompBuf THEN
    ['] rest ON-ERROR
        CompBuf DP A!
        ] ;

\ �������� ��������� �� �६���� ����, �믮����� ��� ᮤ�ন���
\ ����⠭����� ���ﭨ� ��⥬��� ��६�����
: ;stop ( --> )
        RET,
    EXIT-ERROR rest
        CompBuf EXECUTE ;

FALSE WARNING !

\ ���� ⠪
\ �� �室� � ��।������ ��६����� controls 㢥��稢����� �� 1
\ �� ��室� �� ��।������ - 㬥��蠥��� �� 1
: : 1 controls ! : ;
: ; controls @ 1 = IFNOT -22 THROW THEN  0 controls ! [COMPILE] ; ; IMMEDIATE

TRUE WARNING !

?DEFINED test{ \EOF -- ���⮢�� ᥪ��� ---------------------------------------

test{ \ ���� ���� ���஢���� ᮡ�ࠥ����
  S" passed" TYPE
}test



