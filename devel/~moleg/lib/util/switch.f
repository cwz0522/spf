\ 20-06-2005 ��४���⥫�

\ ��ࢮ� ᫮�� ������ ���� �ᯮ����� ⮫쪮 ���� ���� ࠧ
: (sw) 0 , , ,
       DOES> DUP @ IF		     CELL+
		     ELSE -1 OVER !  2 CELLS +
		   THEN
	     @ EXECUTE ;

: switch ( 'a 'b | name --> ) CREATE (sw) ;

: switch: ( | name init work --> ) CREATE ' ' (sw) ;

\ EOF

: init ." ���� ��室 " ;
: work ." �믮������ " ;

switch: proba init work
' init ' work switch test

\ �� TO � ��� �� ࠡ�⠥�. ���� �������� ��� ����.

\EOF

    'a 'b switch name
    or
	  switch: name a b

      0 To name
      x To name


	: init ( n port --> ) DUP 1 ioperm THROW PutByte ;

	switch: send init PutByte

       n send  � ���� ࠧ �맮��� ioprem,
	       �� ��ன ࠧ PutByte

\ ����室������ ������ �� ࠡ�� � ����ᥢ�� ���ᨥ� ��� �� ���饭�� 
\ � ���⠬. � ����� ᭠砫� �㦭� �믮����� ������ ioperm, � ���� �� ⥬ 
\ ( �᫨ ����筮 ����� ����祭 ) ����� ����� � ���� ��� ���� �� ����. 
\ � ������ ��砥 �� ioperm ����� ������. ���� ����� �ᯮ�짮���� �����, 
\ ��� ᭠砫� �㦭� ��-� ���樠����஢��� � ��⥬ � �⨬ ࠡ����. 
\ ���ਬ�� ⠪ ����� ����㯠�� � 䠩����.
