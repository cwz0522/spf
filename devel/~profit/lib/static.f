\ ����������� ����������, ���������� ��������������� � �����
\ ���� �����������.
\ � ���������� � ������ B! ��� KEEP (����� LOCAL, ��. ������
\ �����) ����� ������������ ��� ��������� bac4th-�����������
\ ��������� ����������.

MODULE: static
\ ����� ���������� � ~profit/lib/bac4th.f
\ ��. ~mlg/BacFORTH-88/BF-Diplom.html �/���
\ http://fforum.winglion.ru/viewtopic.php?p=2151#2151
: KEEP ( addr --> / <-- ) R> SWAP DUP @  2>R EXECUTE 2R> SWAP ! ;

USER widLocals
widLocals 0!

USER widHere

: ADD-ORDER ( wid -- ) ALSO CONTEXT ! ;

: END-STATIC widLocals @  IF \ �������� �� ������� ���������� ������� ������� �� ������ �������� (���� ��?)
HERE PREVIOUS DEFINITIONS
widLocals @ FREE-WORDLIST
DP ! widLocals 0!         THEN ;

: (;) ?COMP END-STATIC S" ;" EVAL-WORD ;

: CREATE-LOCAL-WORDLIST ( -- )      \ ������ ������� ��������� ����������
TEMP-WORDLIST ADD-ORDER DEFINITIONS \ ������ ��������� �������, ������ ��� �������
S" ;" CREATED IMMEDIATE             \ ��������� � ������� ����� ; ������� ����� ����������� ������ ���. ����������
DOES> DROP (;) ;

: LOCAL-WORDLIST widLocals @ 0= IF     \ ��������� �� ��������� ������� ���. ����������.
CREATE-LOCAL-WORDLIST                  \ ���� � ������ ���, �� �� �������� � ��������������� ��� �������
CONTEXT @ widLocals !           ELSE
widHere @ DP !  DEFINITIONS     THEN ; \ ���� ������� ��� ������, �� ��������� �������� HERE � �������� ����� ������ � ���� �����

EXPORT
: STATIC ( "name -- ) ?COMP 
HERE LAST @ NAME> =              \ ��� ������ �� ��������������� 
IF  0 , HERE LAST @ NAME>C !     \ ����� ������, �������� ���� ����
ELSE                             \ ����� ��� ��� ����, ������� ������ ��������
0 BRANCH, >MARK                  \ jmp HERE+������ , ������������� ������ 
\ ALIGN                          \ ������������� ��� ����� �� ����������, ���� �������� �����... 
0 ,                              \ ���� ������, ����� ���� 
1 >RESOLVE                       \ ������ ������ jmp �� ���� 
THEN 

LAST @ HERE                      \ �������� HERE ������ �����������, ��������� LAST
CURRENT @  WARNING @  WARNING 0! \ ��������� �� ������ ���������� 
LOCAL-WORDLIST                   \ ������ ��� ��������� �� ��������� ������� ��������� ���������� 
CREATE IMMEDIATE                 \ ������ � ��������� ������� ��� ��������� ���������� 
WARNING ! 
OVER CELL - ,                    \ ����������� ����� ���������� ������� ������ 
HERE widHere !                   \ �������� HERE ������ ������� 
SET-CURRENT 
DP ! LAST !                      \ ��������� HERE ������ �����������, ��������������� LAST
DOES> @ LIT, ; IMMEDIATE

: LOCAL ( "name -- ) [COMPILE] STATIC
widLocals @ @ NAME> EXECUTE
POSTPONE KEEP ; IMMEDIATE

;MODULE

\EOF
: previousValue
STATIC a
a @
SWAP a ! ;

REQUIRE SEE lib/ext/disasm.f
SEE previousValue

\ 559330 E904000000       JMP     559339  ( previousValue+9  )
\ 559335 0000             ADD     [EAX] , AL
\ 559337 0000             ADD     [EAX] , AL
\ 559339 8BD0             MOV     EDX , EAX
\ 55933B A135935500       MOV     EAX , 559335  ( previousValue+5  )
\ 559340 891535935500     MOV     559335  ( previousValue+5  ) , EDX
\ 559346 C3               RET     NEAR

1 previousValue .
2 previousValue .
3 previousValue .

: sum ( a b -- )
STATIC a
STATIC b
a ! b !

a @ b @ +

STATIC c c !
c @ ;

: fact ( n -- n! ) \ �� ����� ������� ������, ��������.
DUP 0=      IF     \ �� ��� �� ����� ���������� ��� ����������� ���������
DROP 1      ELSE   \ �������� � ����������� ����������
LOCAL n            \ ���� ����� ��� � STATIC n  n KEEP
DUP n !
1- RECURSE
n @ *       THEN ;