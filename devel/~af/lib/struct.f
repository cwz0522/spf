\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ ������� �������, ᮤ�ঠ�� ������ - �㭪樨.

: STRUCT: ( "name" -- old-current )
  VOCABULARY
  GET-CURRENT
  ALSO LATEST NAME> EXECUTE DEFINITIONS
  0
;

: ;STRUCT ( old-current -- )
  S" /SIZE" ['] CONSTANT EVALUATE-WITH
  SET-CURRENT PREVIOUS
;

: f: ( offset "new-name" -- offset+cell )
  CREATE
  DUP , CELL+
  DOES> @ OVER @ + @ API-CALL
;
