\ 31-03-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ���������, vect � value ����������, ������ � ����.

REQUIRE ?: devel\~moleg\lib\util\ifcolon.f

  \ ������ �������� ������ ����                                            \
    ?: ADDR ( --> const ) 4 ;                                              \
  \                                                                        \
  \ ������ � ��������� ��������                                            \
    ?: A@ @ ; ?: A! ! ; ?: A, , ;                                          \
  \                                                                        \
  \ !!! ����� ������������ � �� ���� ������ �������� �� ��������           \
  \ ������ �� ����������. ����� ������� � ��������� �����.                 \
    ?: atod ( addr --> disp ) HERE ADDR + - ;                              \
  \                                                                        \
  \ ������������� � ������� ��������� ���4                                 \
  \ ������������� ������������ ������� CALL �� addr                        \
    ?: CALL, ( addr --> ) 0xE8 C, atod A, ;                                \
  \                                                                        \
  \ ������ �� ��, ��� � ['] name COMPILE,                                  \
  \ ���-���� ����� ����������� �����, ��� POSTPONE                         \
    ?: COMPILE ( --> ) ?COMP ' LIT, ['] COMPILE, COMPILE, ; IMMEDIATE      \


\ ������� ��������� �
\ ������� �� ���-�������� � ���, ��� �������� ��������� �������������
\ ����� � ���, � ������� �� ��� - ��� � ��� ������������� CALL �� ���������.
\ � ��� ��������, ��� ��������� �������� ��������� �� �����������������.
: const ( n / name --> )
        CREATE , IMMEDIATE
        DOES> @
              STATE @ IF 0x8D C, 0x6D C, 0xFC C,  \ LEA EBX, -4 [EBX]
                         0x89 C, 0x45 C, 0x00 C,  \ MOV [EBP], EAX
                         0xB8 C, ,                \ MOV EAX, # const
                       ELSE
                      THEN ;

\ ������� ������-���������� �
\ ���� ���������� �� ���������������� - ��������� NOOP
: vect ( / name --> ) HEADER ['] NOOP CALL, RET, ;

\ ���������� ����� �������� vect ���������� �
: (is) ( addr 'vect --> ) TUCK ADDR + - SWAP A! ;

\ �������� �������� vect ���������� �
: is   ( n / name --> )
       ' 1 +
       STATE @ IF LIT, COMPILE (is)
                ELSE (is)
               THEN ; IMMEDIATE

\ �������� ���������� vect ���������� - �� ���� ������ �� ���� ��� ���������
: (evoke) ( addr --> addr ) 1 + DUP A@ + ADDR + ;

\ ������� ���������� vect ���������� �
: evoke ( / name --> addr )
        '
        STATE @ IF LIT, COMPILE (evoke)
                 ELSE (evoke)
                THEN ; IMMEDIATE

\ ������� value ���������� �
: value ( n / name --> )
        HEADER
         0x8D C, 0x6D C, 0xFC C,  \ LEA EBX, -4 [EBX]
         0x89 C, 0x45 C, 0x00 C,  \ MOV [EBP], EAX
         0x90 C,                  \ NOP               \ ������������ ��������
         0xB8 C, ,                \ MOV EAX, # const  \ +08
         RET, ;

\ ��������� n value-���������� � ������ name �
: to ( n / name --> )
     ' 8 +
     STATE @ IF LIT, COMPILE A!
              ELSE A!
             THEN ; IMMEDIATE

\ ��������� n value-���������� � ������ name �
: +to ( n / name --> )
      ' 8 +
      STATE @ IF LIT, COMPILE +!
               ELSE +!
              THEN ; IMMEDIATE

\ �������� �������� ���������� �� ����� - ������ �������.
: change ( a addr --> b ) DUP @ -ROT ! ;

\ �������� �������� value ���������� �� �����, ������ �������.
: exch ( a / name --> b )
       ' 8 +
       STATE @ IF LIT, COMPILE change
                ELSE change
               THEN ; IMMEDIATE

\ �������� ������� �� ������������� � ��� �������� ����������� � ���, ���
\ ������������ �� ������ ����� ��� � �������������� 8), ��� �������, ���
\ ��� �� ���� ��������� ��� ���������� ������ ������������� ��.
\ ������, �� ����� ������ ������� ����������� � ���, ��� ������ ���������
\ vect - �������� �� to � value � ������� is !!! ��� ������-�� ����������
\ �������. �� � � ������� �������� ���� ������������ ��������� ��������
\ CREATE-DOES> ���������: VALUE DOES> ; VECT DOES> ; CONSTANT DOES>
\ ������ ��� ��������� DOES> � ����� ������ �� ��������- �� ���� ������
\ �� ����� ������������.

\EOF -- �������� ������ -----------------------------------------------------
                                   DECIMAL

  123 value proba S" ������ ���� 123 = " TYPE proba . CR
  200 to proba S" ������ ���� 200 = " TYPE proba . CR
  : testa 300 to proba ; testa S" ������ ���� 300 = " TYPE proba . CR
  vect sample S" ������ ���� " TYPE ' NOOP . S" = " TYPE evoke sample . CR
  : testb ." vect sample passed. " ; ' testb is sample   sample CR
  : testc evoke sample . ;
  S" ������ ���� " TYPE ' testb . S" = " TYPE testc CR
  20 +to proba S" ������ ���� 320 = " TYPE proba . CR
  : testd 30 +to proba ; S" ������ ���� 350 = " TYPE testd proba . CR
  234 exch proba S" ������ ���� 350 = " TYPE . CR
  S" ������ ���� 234 = " TYPE proba . CR

