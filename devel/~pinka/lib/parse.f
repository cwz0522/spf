\ 2001

: ParseFileName ( -- a u )
\ ��������� ��� �����  �� �������� ������. 
\ ��� ����� ���� � �������� ( "filename").

    BL SKIP
    SOURCE DROP >IN @ + C@   [CHAR] " = IF [CHAR] " DUP SKIP ELSE BL THEN
    PARSE  2DUP + 0 SWAP C!
;

\ 31.Mar.2004 

: IsCharSubs ( c -- f )
  DUP [CHAR] " <> IF
  DUP [CHAR] ' <> IF
  DROP FALSE EXIT THEN 
                  THEN
  DROP TRUE
;
: NextSubstring ( <char1>ccc<char2> -- addr u)
  SkipDelimiters
  GetChar               IF
  DUP IsCharSubs IF
  >IN 1+!        ELSE
  DROP BL        THEN
  PARSE  EXIT           THEN
  0 ( -- 0 0 )
;
: NextSubstring2 ( <char1>ccc<char2> -- addr u)
\ ������ ��������� ������ � ������������ ���������
  NextSubstring DUP IF
  OVER 1- C@
  IsCharSubs IF 
  SWAP 1- SWAP 2+ 
  THEN              THEN
;
