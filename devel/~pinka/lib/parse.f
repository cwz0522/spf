

: ParseFileName ( -- a u )
\ ��������� ��� �����  �� �������� ������. 
\ ��� ����� ���� � �������� ( "filename").

    BL SKIP
    SOURCE DROP >IN @ + C@   [CHAR] " = IF [CHAR] " DUP SKIP ELSE BL THEN
    PARSE  2DUP + 0 SWAP C!
;
