\ 23.Dec.2006 Sat 16:08
( ��������� ������-������ ��� ������� ����
  � ����� �� ����������. ��� ������� �� quick-swl3.f

  ����� WID-EXTRA [ wid -- addr ] ���� �������� ������ ��� �������������.
  ������ ����������, ������������ ��� ������ ��� ����� ����,
  ������ �������������� ����� WID-EXTRA
  � ���, ����� ��� ���������� ������ ��������� ������.

  ������ ������������� ������� AT-WORDLIST-CREATING [ wid -- wid ]
  ���������� ��� �������� ������ ������ ����.
)

REQUIRE [UNDEFINED] lib\include\tools.f
REQUIRE Included ~pinka\lib\ext\requ.f
REQUIRE REPLACE-WORD lib\ext\patch.f

WARNING @  WARNING 0!

MODULE: WidExtraSupport

Require ENUM-VOCS enum-vocs.f

2 CELLS CONSTANT /THIS-EXTR   \ [ free cell | voc class ]

: MAKE-EXTR ( wid -- )
  HERE DUP /THIS-EXTR DUP ALLOT ERASE
  ( wid here )
  OVER CLASS@ OVER CELL+ !
  SWAP CLASS!
;
: MAKE-EXTR2 ( wid -- ) \ �� ������������; �� ������ ��������, ��������� ����� ����� WORDLIST
  GET-CURRENT >R  DUP SET-CURRENT
  MAKE-EXTR
  R> SET-CURRENT
;

EXPORT

: WID-EXTRA ( wid -- a )  \ ����� ��������� ��� ������ ���������� ������
  [ 3 CELLS ] LITERAL + \ an old "class of vocabulary" cell
  @
;

DEFINITIONS

: WID-CLASSA ( wid -- a )
  WID-EXTRA CELL+
;

EXPORT

WARNING @ WARNING 0!
: CLASS! ( cls wid -- ) WID-CLASSA ! ;
: CLASS@ ( wid -- cls ) WID-CLASSA @ ;
WARNING !

: AT-WORDLIST-CREATING ( wid -- wid ) ... ;

\ : WORDLIST ( -- wid )
\   WORDLIST DUP MAKE-EXTR AT-WORDLIST-CREATING ( wid )
\ ;

\ ���� �������� ��� storage.f, ����� ��������� ����� VOC-LIST

( WORDLIST ���� ��������������,
  �.�. ��������� ������������ ��� ��������� �� ������ VOC-LIST
  �������� �� ������� ����������.
)
' WORDLIST  \ see compiler\spf_wordlist.f
: WORDLIST ( -- wid ) \ 94 SEARCH
  HERE VOC-LIST @ , VOC-LIST !
  HERE 0 , \ ����� ����� ��������� �� ��� ���������� ����� ������
       0 , \ ����� ����� ��������� �� ��� ������ ��� ����������
       0 , \ wid �������-������
       0 , \ ����� ������� = wid �������, ������������� �������� �������

  DUP MAKE-EXTR AT-WORDLIST-CREATING ( wid )
;

' WORDLIST SWAP REPLACE-WORD

\ : VOCABULARY
\   VOCABULARY  VOC-LIST @ CELL+
\   DUP MAKE-EXTR AT-WORDLIST-CREATING DROP
\ ;

' VOCABULARY
: VOCABULARY  \ see  compiler/spf_defwords.f
  CREATE
  HERE 0 , \ cell for wid
  WORDLIST ( addr wid )
  LATEST OVER CELL+ !   \ ������ �� ��� �������
  GET-CURRENT OVER PAR! \ �������-������
  \ FORTH-WORDLIST SWAP CLASS! ( ����� )
  SWAP ! \ ��� wid
  VOC    \ ������� "�������"
  DOES> @ CONTEXT !
;
' VOCABULARY SWAP REPLACE-WORD  \ ����� �������� � �� 'MODULE:', � ���� ���������� �� storage.f


' MAKE-EXTR ENUM-VOCS \ ���� ������������ �������� (!!!)

;MODULE

WARNING !