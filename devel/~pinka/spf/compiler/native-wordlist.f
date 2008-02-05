\ Oct.2006, Feb.2007, 
\ Jan.2008 something extracted from xt.immutable.f
\ �������� ������ ����-����

: RESOLVE-NAME ( c-addr u wid -- xt true | c-addr u false )
  @ CDR-BY-NAME DUP IF NIP NIP NAME> TRUE THEN
;

: RELATE-NAME ( xt  c-addr u  wid -- )
\ ��������� ��� (�������� c-addr u) � ��������� � xt � ������ wid
  >R
  HERE LAST-CFA ! ROT , \ ������ �� xt
  0 C,                  \ flags
  \ +SWORD was here
  HERE LAST ! S",       \ ���� ���
  \ (������ SPF4)
  LAST @  R> DUP @ , !  \ ������� � ������ wid
;


[DEFINED] QuickSWL-Support  [IF] WARNING @  WARNING 0!

: RELATE-NAME DUP >R RELATE-NAME LAST @ R> QuickSWL-Support::update1-wlhash ;

WARNING !                   [THEN]



: NAMING- ( xt c-addr u -- )
\ �������� �����, �������� ���������� xt, 
\ ��� ������, �������� ������� c-addr u, � ������� ������.
  GET-CURRENT RELATE-NAME
;
: NAMING ( c-addr u xt -- ) \ NAMED or GIVE-NAME or ?
\ ���� ����� ��� � ��������� ��� � ������� ����� ���� :)
\ ����� ����� ����� ����� �������� �� ������� �����.
  -ROT NAMING-
;

( �������������� �������� ����� ������������� � xt. ��������,
���� ���� ������, �� ����� ������ ������� ���� �� ������ xt,
���� ���� �����, �� ����� �������������� ������ /��. inlines.f/.
� ��������� ������ ��������� ��������� ����
��� ��������� ���������� � ��������� �������� ��������������:
 attrib-a attib-u xt -- text-a text-u
 attrib-a attib-u xt -- value
)


: WORDLIST-NAMED ( addr u -- wid )
\ � � ������� ������� ��������� ����� � �������� ������,
\ ������������ wid
  WORDLIST DUP >R CODEGEN-WL::MAKE-CONST NAMING R> ( wid )
  LAST @ OVER CELL+ ! ( ������ �� ��� �������, SPF4 )
;

: &  ( c-addr u -- xt )  \ see also ' (tick)
  SFIND IF EXIT THEN -321 THROW
;



\EOF
\ old ideas:

: ALIAS ( xt c-addr u -- ) NAMING- ;
: DEFER-NAMING ( c-addr u -- entry ) 0 , 0 C, HERE -ROT S", 0 , ;
: ~~~BIND-NAME ( xt entry -- ) TUCK 5 - ! .....  ;

: &EX, ( c-addr u -- )
  & EXEC,
;
: &LT, ( c-addr u -- )
  I-LIT IF LIT, EXIT THEN -321 THROW
;