\ 23.Dec.2006 Sat 21:59

\ from quick-swl3.f

: ENUM-VOCS ( xt -- )
\ xt ( wid -- )
  >R VOC-LIST @ BEGIN DUP WHILE
    DUP CELL+ ( a wid ) R@ ROT >R
    EXECUTE R> @
  REPEAT DROP RDROP
;

: ENUM-FORTH-VOCS ( xt -- )
\ ������� ������ ������� ����-�������� (� ������� CLASS ����� 0 ��� FORTH-WORDLIST )
\ xt ( wid -- )
  >R VOC-LIST @ BEGIN DUP WHILE
    DUP CELL+ ( a wid ) 
    DUP CLASS@ DUP 0= SWAP FORTH-WORDLIST = OR
    IF R@ ROT >R  EXECUTE R> ELSE DROP THEN
    @
  REPEAT DROP RDROP
;
