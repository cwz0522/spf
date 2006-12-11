\ . 20-06-2005 �����ਯ�-�������� ࠡ�� � �⥪�� ��� ���

Unit: psLikeMarkers

	20 CONSTANT #markers
	   USER     M0	  \ ��� �⥪�
	   USER     MP	  \ 㪠��⥫�

\ ���樠�����㥬 �⥪ ��થ஢
F: init  [ #markers CELLS ] LITERAL DUP
	ALLOCATE THROW DUP M0 ! + MP ! ;F

\ ��।���� ᪮�쪮 �ᥣ� ��થ஢ �� �⥪� ��થ஢ �࠭����
: Marks   ( --> n ) M0 @ MP @ - CELL / #markers + ;

\ ������ ���祭�� ��᫥����� ��થ�
: m-@	  ( --> n ) Marks IF MP @ @ ELSE -1 THROW THEN ;

\ ������� ��᫥���� ��થ� � �⥪� ��થ஢ �� �⥪ ������
: m-pop   ( --> n ) Marks IF m-@ MP cell+! ELSE -1 THROW THEN ;

\ ��࠭��� ���祭�� � �⥪� ������ �� �⥪ ��થ஢
: m-push  ( n --> )
	  Marks #markers -
	  IF MP DUP cell-! @ !
	    ELSE -1 THROW
	  THEN ;
EndUnit

psLikeMarkers

: ClearToMark ( --> ) m-pop SP! ;
: DropMark    ( --> ) m-pop DROP ;
: AddMark     ( --> ) SP@ m-push ;
: CountToMark ( --> n ) m-@ SP@ - CELL / ;
: ClearMarks  ( --> ) M0 @ #markers CELLS + MP ! ;

init

\EOF
     ������ ����� �ᯮ�짮���� �⥪ ������, ��� ���ᨢ. ����� ���
�ந����쭮�� ����㯠 � �⥪� ������ �������(ROLL, PICK), � ��� ���
�ࠢ����� ����訬 ������⢮� ������ ⠪�� ᫮� ��� :(

  AddMark     - 䨪���� ��㡨�� �⥪� ������ �� ����� ������ �६���
  DropMark    - 㤠��� ��᫥���� ��થ�
  ClearToMark - 㤠��� ���孨� ������ � �⥪� ������ �� ���祭��
		��࠭������ �� AddMark
  CountToMark - ��।���� ��㡨�� �⥪� ������ �� ��᫥����� ��࠭������
		��થ�.
  ClearMarks  - ������ �⥪ ��થ஢.

� �����ਯ� ��થ�� �࠭���� �� ��饬 �⥪� ������. �������� ��
����� 㤮��� ��ਠ��, �� ��� �������, �� � ��� ���� ��� ��થ஢
�⢥�� �⤥��� �⥪. ���⢥��⢥���, �᫨ �㤥� ��������� �����,
����� �⥪ ��������, � �ਤ���� 㤠���� �� ��થ��, �⮡� ࠡ��
� ���� ��⠢����� ���४⭮�.

�������� � �६���� �ਤ�� ����� 㤠筠� ����.


