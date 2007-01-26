\ ���������� � ����. ������ ���������� ������� �� ���� ����������.
\ ����� ���������� jmp'���.

\ �������� ������������ ���������:
\ <������-������> _CREATE-VC ( n -- v_codefile )

\ ��� �� ��������� ��-��������� (�� 4��):
\ CREATE-VC ( -- v_codefile )

\ VC-, VC-COMPILE, VC-LIT, VC-RET, ����������
\ ,    COMPILE,    LIT,    RET,
\ ������ ������� �������������� �������� -- vc
\ , �� ���� �������� ���� ��� ����������

\ ����� ����, ����� VC- ( vc --> \ <-- ) ����������� ��� ������������� 
\ �����, ������ ����� ����, �� ����������� �������� vc � �������� �����������

\ �������� ���������������� � �������� ����� ���:
\ vc EXECUTE

\ ��� ����� ������������� � ������������� DESTROY-VC ( vc -- )


\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE __ ~profit/lib/cellfield.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE CONT ~profit/lib/bac4th.f

MODULE: codepatches
30 CONSTANT luft  \ ������� ���� �������

0
1 -- rlit     \ ���������� PUSH (0x64)
__ firstBlock \ ������ ����� ������� ��� �������� ������
1 -- ret      \ ���������� RET (0xC3)
__ALIGN       \ ����������� �� ������
__ block      \ ������ ������, �������� ���� ����� ������ ��� ����
__ there      \ ����������� HERE � ���� ����������� ���������
__ lastBlock  \ ��������� �����
__ limit      \ ��������� ����������, ���� ������������ ���������
              \ �����, ����� ����������� �������� ���� �������� ����� �����
CONSTANT codePatches

: firstBlock! SWAP CELL+ SWAP firstBlock ! ;
: firstBlock@ firstBlock @ CELL- ;

VARIABLE counter
counter 0!

: allocatePatch ( vc -- ) >R R@ block @ ALLOCATE THROW
\ counter 1+!  counter @ CR . \ ��� �������� ������ � ������ ������
DUP 0! DUP R@ lastBlock !
CELL+ DUP R@ there ! 
R@ block @ + luft - R@ limit ! RDROP ;

: HERE DP @ ; \ HERE �� ������� -- �� �� �� ����� ��� � DP @ 
              \ ����� ������ �������� DP � HERE ����� 
              \ ��������������� ������� ������� �����������,
              \ ��� ��� ����� ���������� ������������.


EXPORT
: _CREATE-VC ( blockSize -- vc )
codePatches ALLOCATE THROW >R
0x68 R@ rlit C!
0xC3 R@ ret C!
R@ block !
R@ allocatePatch
R@ lastBlock @ R@ firstBlock!
R> ;

: CREATE-VC (  -- vc ) 1 12 LSHIFT _CREATE-VC ; \ ��-��������� ����� �� 4��

: DESTROY-VC ( vc -- )
DUP firstBlock@ SWAP FREE THROW
BEGIN DUP @ 
SWAP FREE THROW
\ -1 counter +!  counter @ CR . \ ��� �������� ������ � ������ ������
DUP 0= UNTIL DROP ;

: XT-VC ( vc -- xt ) firstBlock@ CELL+ ;
\ : XT-VC ( vc -- xt ) ; \ ����� � ���, �� ������������ ����� ���������� ����� ������ �������...


: VC- ( ... vc --> \ <-- ) PRO LOCAL vc vc !
vc @ there @ DP B! \ ������ � ���������� DP � ��������������� ��� ������
CONT
HERE vc @ there !
HERE vc @ limit @ >  IF
vc @ lastBlock @
vc @ allocatePatch
vc @ lastBlock @ SWAP !
vc @ there @ BRANCH, THEN ;

: VC-COMPILE, ( xt vc -- ) VC- COMPILE, ;
: VC-, ( n vc -- ) VC- , ;
: VC-LIT, ( n vc -- ) VC- LIT, ;
: VC-DLIT, ( du vc -- ) >R SWAP R@ VC-LIT, R> VC-LIT, ;
: VC-RET, ( vc -- ) VC- RET, ;

\ ���������� ������ � ���� ������ � ����:
: VC-COMPILED ( addr u vc -- ) VC- TRUE STATE B! EVALUATE ;
\ ���������, ��� ��� ���������� EVALUATE'�� �������� � 
\ ���� ����, ������� VC- ����� ��������� ����� �� 
\ ������� �����...  ������� �������� ����� (� ������ 
\ �������� ������������������ ���. �����) �� ������������.

;MODULE


/TEST
REQUIRE SEE lib/ext/disasm.f
0 VALUE t
: r 
CREATE-VC TO t
0 t VC-LIT,
4 0 DO ['] 1+ t VC-COMPILE, LOOP
['] . t VC-COMPILE,
S" dfdsdfdf" t VC-DLIT,
['] CR t VC-COMPILE,
['] TYPE t VC-COMPILE,
['] CR t VC-COMPILE,
S" 1 1 + ." t VC-COMPILED
t VC-RET,
t XT-VC REST CR
t ( XT-VC ) EXECUTE ;

$> r

t DESTROY-VC
\ MemReport