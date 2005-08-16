( ���������, ������������� � ��������� ������ ��� �����������
  ���������� ������� DLL [������ ���� inline WINAPI]

  CALL DLL-CALL
  1. ������_���������_�������_asciiz_���_�������
                                             \ ������ �� __WIN:
  2. ���_�����_�������_�_dll                 \ = address of winproc
  3. dll_wid                                 \ ������ address of library name
  4. ������_��_asciiz_���_�������            \ = address of function name
  5. �����_����������_����_��������_�����_-1 \ # of parameters
  6. ������_��_����������_��������_���������_������� \ WINAPLINK
  asciiz_���_�������

  ���������:

  ������_���������_�������_asciiz_���_�������:
  - ������� ���� �������� � RP ��� �������� � ��������� ����������,
  �.�. 6 CELLS ���� ����� ����� ������� ���� 1 [������� ���������� asciiz]

  ���_�����_�������_�_dll:
  - ����� ������� ��� �������� � API-CALL; ������ ���� ������� ���
  ���������� EXE ��� ��� ������ EXE � ��� ����� ���������-��������� DLL

  dll_wid:
  - ������ �� �������, ���������� �����������-��������� ������ DLL

  ������_��_asciiz_���_�������:
  - � ������ ������ ������ ������, �� ������������ ��� ������������� � __WIN:

  �����_����������_����_��������_�����_-1:
  - � ����������� �� ��������������� ������� ����� ���� �������� ����� ����������...

  ������_��_����������_��������_���������_�������:
  - winaplink, ���������� ��� ������ �������� ��� ���������
  ������������ ������� ���_�����_�������_�_dll

  asciiz_���_�������:
  - ��� ������� � ����� �� ����� ��� �������� � DLSYM
)

: DLL-CALL ( �� ����� ��������� ����� ��������� ������� ���������� ������� )
  R@ CELL+ @
  ?DUP IF R@ @ R> + >R API-CALL
       ELSE ." need initialize" ABORT THEN
;
: DLL-CALL, ( funa funu n dll-wid xt -- addr )
  ['] DLL-CALL _COMPILE,

  HERE >R
  0 , \ size
    , \ address of winproc
    , \ address of library name
  HERE CELL+ CELL+ CELL+ , \ address of function name
    , \ # of parameters
  IS-TEMP-WL 0=
  IF
    HERE WINAPLINK @ , WINAPLINK ! ( ����� )
  ELSE 0 , THEN
  HERE SWAP DUP ALLOT MOVE 0 C, \ ��� �������
  HERE R@ - R@ !
  R>
;

\ S" function" 5 0xDDD 0xCCC DLL-CALL, 80 DUMP

ns.f


GET-CURRENT ALSO DL DEFINITIONS

: SEARCH-WORDLIST ( c-addr u oid -- 0 | xt 1 | xt -1 )
  >R 2DUP ( c-addr u c-addr u )
  0 ROT ROT R@ ROT ROT R> ( c-addr u 0 oid  c-addr u oid )
  SEARCH-WORDLIST
  ?DUP
  IF ( c-addr u 0 oid xt [-]1 )
     >R HERE >R DLL-CALL, DROP 
     STATE @ 0= IF RET, THEN
     R> STATE @ IF DROP ['] NOOP THEN
     R>
  ELSE 2DROP 2DROP 0 THEN
;

SET-CURRENT PREVIOUS

DL NEW: libxml2.dll

S" text.xml" DROP xmlRecoverFile

: TEST
S" text.xml" DROP xmlRecoverFile
;
