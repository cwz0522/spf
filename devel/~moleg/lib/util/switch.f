\ 20-06-2005 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com 
\ �������������

\ ������ ����� ������ ���� ��������� ������ ���� ������ ���
: (sw) 0 , , ,
       DOES> DUP @ IF		     CELL+
		     ELSE -1 OVER !  2 CELLS +
		   THEN
	     @ EXECUTE ;

: switch ( 'a 'b | name --> ) CREATE (sw) ;

: switch: ( | name init work --> ) CREATE ' ' (sw) ;

\ EOF

: init ." ������ ������ " ;
: work ." ���������� " ;

switch: proba init work
' init ' work switch test

\ ��� TO � ��� �� ��������. ���� �������� ��� ����.

\EOF

    'a 'b switch name
    or
	  switch: name a b

      0 To name
      x To name


	: init ( n port --> ) DUP 1 ioperm THROW PutByte ;

	switch: send init PutByte

       n send  � ������ ��� ������� ioprem,
	       �� ������ ��� PutByte

\ ������������� ��������� ��� ������ � ���������� ������� ��� ��� ��������� 
\ � ������. � ������� ������� ����� ��������� �������� ioperm, � ���� �� ��� 
\ ( ���� ������� ������ ������� ) ����� ������ � ���� ��� ������ �� ����. 
\ � ������ ������ �� ioperm ����� ������. ���� ����� ������������ �����, 
\ ��� ������� ����� ���-�� ���������������� � ����� � ���� ��������. 
\ �������� ��� ����� ��������� � �������.
