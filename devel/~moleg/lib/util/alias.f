\ 03-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ����.

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ ᮧ���� ᫮��, ���樨�㥬�� � ����� ��㣮�� ᫮��.
: ALIAS ( | BaseName AliasName --> ) ' NextWord SHEADER LAST-CFA @ ! ;

\ ALIAS - �� ���⮩ ��������� ᫮��, �易��� � �㦨� �����.
\ � �ਭ樯� ᫥���騥 �ਬ��� ���������:
\  : ;; ( --> ) [COMPILE] ; ; IMMEDIATE
\  ALIAS ; ;; IMMEDIATE
\ �� ⥬ �᪫�祭���, �� ALIAS ������ ����� ���� � �㤥� ࠡ����
\ ����� ����॥.
\ ��������: 䫠�� �������� ᫮�� �� ��᫥������, ⠪ ��, �᫨ �� ���
\ ᮧ���� ����� ᫮�� ������������ �ᯮ������, �����뢠�� ��᫥ IMMEDIATE

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ : proba 0x123DFE76 ;
      ALIAS proba test        \ ᮧ������ ��� test,
      test proba <> THROW     \ ���樨�㥬�� � ����� ᫮�� proba
S" passed" TYPE
}test



