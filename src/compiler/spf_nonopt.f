( �����, �-� ������ ���������  ) 
( ������������ ������ '        )

GET-CURRENT
WORDLIST CONSTANT NON-OPT-WL
ALSO ' NON-OPT-WL EXECUTE CONTEXT ! DEFINITIONS
TC-WL ALSO TC-IMM

CODE1 RDROP ( -> )
     POP EBX
     LEA ESP, 4 [ESP]
     JMP EBX
;C

CODE1 >R    \ 94
\ ����������: ( x -- ) ( R: -- x )
\ ��������� x �� ���� ���������.
\ �������������: ��������� � ������ ������������� �� ����������.
   POP  EBX
   PUSH EAX
   MOV EAX, [EBP]
   LEA EBP, 4 [EBP]
   JMP EBX
;C

CODE1 R>    \ 94
\ ����������: ( -- x ) ( R: x -- )
\ ��������� x �� ����� ��������� �� ���� ������.
\ �������������: ��������� � ������ ������������� �� ����������.
     LEA EBP, -4 [EBP]
     MOV [EBP], EAX
     POP EBX
     POP EAX
     JMP EBX
;C


CODE1 ?DUP ( x -- 0 | x x ) \ 94
\ �������������� x, ���� �� ����.
     OR EAX, EAX
     JNZ  ' DUP
     RET
;C

\ ================================================================
\ ����� ������������ (��� ��������������� ������ ����)

CODE1 EXECUTE ( i*x xt -- j*x ) \ 94
\ ������ xt �� ����� � ��������� �������� �� ���������.
\ ������ ��������� �� ����� ������������ ������, ������� �����������.
     MOV EBX, EAX
     MOV EAX, [EBP]
     LEA EBP, 4 [EBP]
     JMP EBX
;C

:: THROW
  ?DUP
  IF
     DUP 109 = IF DROP EXIT THEN \ broken pipe - ������ �� ������, � ����� �������� ������ � CGI
     HANDLER @ 
     DUP
     IF RP! 
        R> HANDLER !
        R> SWAP >R
        SP! DROP R>
     ELSE DROP FATAL-HANDLER THEN
  THEN
;; 


PREVIOUS PREVIOUS SET-CURRENT

