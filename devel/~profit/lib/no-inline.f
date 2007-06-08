\ ���������� (�� ��������� �������) ������������ ��� ����� �������������
\ � �������������� ���������� � �������� (������������ � ~profit/lib/compile2heap.f
\ ��� ������������ ���������� ����).

\ �������������:
\ NO-INLINE{ ... }NO-INLINE
\ , ��� ������ ... -- ������������� ���.

\ �� ��������� ���������� ��� "������". ������������� ������������ �� ������ � 
\ ������ ������������� ��� ����������� ����, ��� ����������� ������� ��������� 
\ ��������� ������:
\ NO-INLINE{ 
\ : blabla 10 0 DO I . LOOP ;
\ }NO-INLINE

\ ���� ����� ����� ����� ������� ���������, �� ������������� ������������
\ ����������� ������� NO-INLINE=> ������� ����� ���������� � ������������
\ � run-time ��� ��������� ��������� ���������� �� ���� �����.

\ �������������� ' DROP , ��� �������. ��� ���� �������� MM_SIZE �����������������.
\ : DROP, NO-INLINE=> POSTPONE DROP ;

REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE /TEST ~profit/lib/testing.f

MODULE: no-inline

VARIABLE SAVE-MM_SIZE
SAVE-MM_SIZE 0!

\ ���������� ������ ������ ���������� (�� ����������) DO-LOOP
S" ~profit\lib\~moleg\doloop.f" INCLUDED

EXPORT

: NO-INLINE{ \ ������� ��� ������� ������������ �� ������ (����� ��������� ���� ����� -- ���������� ���������)
MM_SIZE SAVE-MM_SIZE !
0 TO MM_SIZE
ALSO no-inline ;

: }NO-INLINE
\ ���������� ����������������� INLINE,
SAVE-MM_SIZE @ TO MM_SIZE
PREVIOUS ;

: NO-INLINE=> PRO
SAVE-MM_SIZE KEEP
NO-INLINE{ CONT }NO-INLINE ;

;MODULE

/TEST
lib/ext/disasm.f

NO-INLINE{
CR CR .( NO-INLINE:)
:NONAME 10 0 ." [" ?DO I . LOOP ." ]" ; DUP REST EXECUTE
}NO-INLINE

CR CR .( USUAL:)
:NONAME 10 0 ." [" ?DO I . LOOP ." ]" ; DUP REST EXECUTE


: DROP, NO-INLINE=> POSTPONE DROP ;

: r [ DROP, ] DROP ;
SEE r