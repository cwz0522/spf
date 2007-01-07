\ ���������� � ����. ������ ���������� ������� �� ���� ����������.
\ ����� ���������� jmp'���.

\ �������� ������������ ���������:
\ <������-������> _CREATE-VC ( n -- v_codefile )

\ ��� �� ��������� ��-��������� (�� 4��):
\ CREATE-VC ( -- v_codefile )

\ VC-, VC-COMPILE, VC-LIT, VC-RET, ����������
\ ,    COMPILE,    LIT,    RET,
\ ������ ������� �������������� �������� -- cp

\ ����� ����, ����� VC- ( vc -- ) ����������� ��� ������������� 
\ �����, ������ ����� ����, �� ����������� �������� vc � �������� �����������

\ ��� ����� ������������� � ������������� DESTROY-VC ( vc -- )


\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE CONT ~profit/lib/bac4th.f

MODULE: codepatches
30 CONSTANT luft  \ ������� ���� �������

: __ CELL -- ;

0
__ block      \ ������ ������, �������� ���� ����� ������ ��� ����
__ there      \ ����������� HERE � ���� ����������� ���������
__ firstBlock \ ������ ����� ������� ��� �������� ������
__ lastBlock  \ ��������� �����
__ limit      \ ��������� ����������, ���� ������������ ���������
              \ �����, ����� ����������� �������� ���� �������� ����� �����
CONSTANT codePatches

VARIABLE counter
counter 0!

: allocatePatch ( vc -- ) >R R@ block @ ALLOCATE THROW
\ counter 1+!  counter @ CR . \ ��� �������� ������ � ������ ������
DUP 0! DUP R@ lastBlock !
CELL+ DUP R@ there ! 
R@ block @ + luft - R@ limit ! RDROP ;

: HERE DP @ ; \ HERE �� ������� -- �� �� �� ����� ��� � DP @ 
              \ ����� ������ �������� DP ����� ���������������
              \ ������� ������� ����������� ��� ��� ����� 
              \ ���������� ������������


EXPORT
: _CREATE-VC ( blockSize -- vc )
codePatches ALLOCATE THROW >R
R@ block !
R@ allocatePatch
R@ lastBlock @ R@ firstBlock !
R> ;

: CREATE-VC (  -- vc ) 1 12 LSHIFT _CREATE-VC ; \ ��-��������� ����� �� 4��

: DESTROY-VC ( vc -- )
DUP firstBlock @ SWAP FREE THROW
BEGIN DUP @ 
SWAP FREE THROW
\ -1 counter +!  counter @ CR . \ ��� �������� ������ � ������ ������
DUP 0= UNTIL DROP ;

: XT-VC ( vc -- xt ) firstBlock @ CELL+ ;

: VC- ( ... vc -- ) PRO LOCAL vc vc !
LOCAL savedHere HERE savedHere !
vc @ there @ DP !
CONT
HERE vc @ there !
HERE vc @ limit @ >  IF
vc @ lastBlock @
vc @ allocatePatch
vc @ lastBlock @ SWAP !
vc @ there @ BRANCH, THEN
savedHere @ DP ! ;

: VC-COMPILE, ( xt vc -- ) VC- COMPILE, ;
: VC-, ( n vc -- ) VC- , ;
: VC-LIT, ( n vc -- ) VC- LIT, ;
: VC-DLIT, ( du vc -- ) >R SWAP R@ VC-LIT, R> VC-LIT, ;
: VC-RET, ( vc -- ) VC- RET, ;
\ ���������� ������ � ���� ������ � ����:
: VC-COMPILED ( addr u cp -- ) VC- TRUE STATE B! EVALUATE ;
;MODULE

\EOF
REQUIRE SEE lib/ext/disasm.f
0 VALUE t
: r 
1000 CELLS CREATE-VC TO t
0 t VC-LIT,
4 0 DO ['] 1+ t VC-COMPILE, LOOP
['] . t VC-COMPILE,
S" dfdsdfdf" t VC-DLIT,
['] CR t VC-COMPILE,
['] TYPE t VC-COMPILE,
['] CR t VC-COMPILE,
S" 1 1 + ." t VC-COMPILED
t VC-RET,
t XT-VC REST ;

r
t DESTROY-VC
\ MemReport