\ SHT = Sorted Hash Table

REQUIRE STR@ ~ac/lib/str5.f
REQUIRE MD5  ~clf/md5-ts.f

0
CELL -- sht.key
CELL -- sht.value
  32 -- sht.keyhash
  32 -- sht.valhash
CELL -- sht.keyL
CELL -- sht.keyR
CELL -- sht.khL
CELL -- sht.khR
CELL -- sht.vhL
CELL -- sht.vhR
CELL -- sht.prev  \ ��� ������������� ������ �� ����, � �� �����
CELL -- sht.vprev \ ��������� �� ������ vh ������ �� ���� ��������
CELL -- sht.par   \ ��� ��������� ������ ��������
CELL -- sht.oval  \ ��� ������ ���������� ��������
CELL -- sht.class \ ����������� ����� ��� [��]������������ � ��.
CELL -- sht.mux   \ ��� mutex'� ���������� ���������
CONSTANT /sht

\ ������� �������� sht �� �����, ��� ������� ���������, �.�. ����������.

: (ST!) { vala valu node -- } \ fixme: ����� ������� ������ ����.��������
  vala valu node sht.value S!
  vala valu MD5 node sht.valhash SWAP MOVE
;
: (ST!name) { keya keyu node -- }
  keya keyu node sht.key S!
  keya keyu MD5 node sht.keyhash SWAP MOVE
;
: (ST@K) { keya keyu sht \ pnode flag -- addr flag }
  \ flag ����� ����� ����� �������� COMPARE (� �� SEARCH):
  \ ���� flag=0, �� � ������ ������� ������ ���������� �����
  \ � addr=node - ��������� �� ���� ����
  \ ���� flag �� 0, �� �� 1 ��� -1 � ����������� �� ����������
  \ ��������� � ��������� (��������� �� ��������) ������,
  \ � addr - ������ ���������� (keyL ��� leyR), ���� ���� 
  \ �������� ��������� �� ����� ����, ���� �����������

\ fixme: ��� � ��� ����������� ������� ���������� ������ ������������ �����

  sht
  BEGIN \ ���������� ����� �������� ����� ��������� �� ���� sht
    DUP @
  WHILE
    -> pnode
    pnode @ sht.key @ STR@ keya keyu COMPARE
    ?DUP IF DUP -> flag
            0 < IF pnode @ sht.keyR ELSE pnode @ sht.keyL THEN
         ELSE pnode @ 0 EXIT THEN
  REPEAT
  ( pnode) flag
  DUP 0= IF DROP -1 THEN \ ���� sht ������ ��� ����
;
: (ST@KH) { ha hu sht \ pnode flag -- addr flag }
  \ ����� �� ���� �����
  \ ������ �������, ��� �� ��������, ���� ������� ��������� �� ����
  \ �������������� ������������ �� ����� ������...
  \ �� ��� ��������� �������� ��-�� ���������� MD5 ����� ���� ������
  sht
  BEGIN \ ���������� ����� �������� ����� ��������� �� ���� sht
    DUP @
  WHILE
    -> pnode
    pnode @ sht.keyhash 32 ha hu COMPARE
    ?DUP IF DUP -> flag
            0 < IF pnode @ sht.khR ELSE pnode @ sht.khL THEN
         ELSE pnode @ 0 EXIT THEN
  REPEAT
  ( pnode) flag
  DUP 0= IF DROP -1 THEN \ ���� sht ������ ��� ����
;
: (ST@VH) { ha hu sht \ pnode flag -- addr flag }
  \ ����� �� ���� ��������; ��������, ���� �������� ������ ��������!
  sht
  BEGIN \ ���������� ����� �������� ����� ��������� �� ���� sht
    DUP @
  WHILE
    -> pnode
    pnode @ sht.valhash 32 ha hu COMPARE
    ?DUP IF DUP -> flag
            0 < IF pnode @ sht.vhR ELSE pnode @ sht.vhL THEN
         ELSE pnode @ 0 EXIT THEN
  REPEAT
  ( pnode) flag
  DUP 0= IF DROP -1 THEN \ ���� sht ������ ��� ����
;
VECT dST-VALDUP ' DROP TO dST-VALDUP

: ST! { vala valu keya keyu sht \ pnode node -- }
  keya keyu sht (ST@K) 0=
  \ ����� ���� �� ������ �� "keya keyu MD5 sht (ST@KH) 0=",
  \ �� ����� ��� ����������� ����� �������� ���� ����� ��� ������ pnode
  IF \ ������, ������� ��������
     -> node
     vala valu node (ST!)
     node sht.vprev @ ?DUP IF 0! THEN \ ���������� ��������� ����� ��������,
                          \ �.�. ��� ������ ����������� ���������� ���� �� �������
     EXIT
  THEN
  -> pnode

  \ �� ������, ��������
  /sht ALLOCATE THROW -> node
  vala valu node (ST!)
  keya keyu node (ST!name)
  pnode node sht.prev !
  node sht.keyhash 32 sht (ST@KH)
  IF node SWAP !
  ELSE ." (hash dup!)" DROP THEN \ ������� ����� ��� ���! :)
  node sht.valhash 32 sht (ST@VH)
  IF node OVER !
     node sht.vprev ! \ ��� ������� ������� ��� ����� ��������
  ELSE dST-VALDUP THEN \ �� �� �������� � ������� �����, ��� ���������
  node pnode !
;
: ST@ { keya keyu sht \ pnode -- vala valu }
  keya keyu sht (ST@K)
  IF DROP S" "
  ELSE sht.value @ STR@ THEN
;
: ST? { keya keyu sht \ pnode -- vala valu flag }
  keya keyu sht (ST@K)
  IF DROP S" " FALSE
  ELSE sht.value @ STR@ TRUE THEN
;
: ST@H { keya keyu sht \ pnode -- vala valu }
  keya keyu MD5 sht (ST@KH)
  IF DROP S" "
  ELSE sht.value @ STR@ THEN
;
: ST?H { keya keyu sht \ pnode -- vala valu flag }
  keya keyu MD5 sht (ST@KH)
  IF DROP S" " FALSE
  ELSE sht.value @ STR@ TRUE THEN
;
USER uST-RECLEVEL
USER uST-MAXRECLEVEL

: ST-FOREACH-SORTED { xt sht \ pnode -- }
\ xt: ( ... vala valu keya keyu node -- ... )
\ � ������� ����������� ����������� �����
\ ������ �� ������������� ��� ��������, ������� ������� ��������
\ ����� ���� �����, �� ����������� �� ��� ������������� ������ ;)
  uST-RECLEVEL 1+! uST-RECLEVEL @ uST-MAXRECLEVEL @ MAX uST-MAXRECLEVEL !
  sht @ 0= IF EXIT THEN
  sht @ sht.keyL DUP @ IF xt SWAP RECURSE ELSE DROP THEN
  sht @ sht.value @ STR@ sht @ sht.key @ STR@ sht @ xt EXECUTE
  sht @ sht.keyR DUP @ IF xt SWAP RECURSE ELSE DROP THEN
  uST-RECLEVEL @ 1- uST-RECLEVEL !
;

: ST-FOREACH-HASHED { xt sht \ pnode -- }
\ xt: ( ... vala valu keya keyu node -- ... )
\ ����� �������� � ��������� ������� (���� �� ��������),
\ � ������� �������� �� ����� ������ 32
  uST-RECLEVEL 1+! uST-RECLEVEL @ uST-MAXRECLEVEL @ MAX uST-MAXRECLEVEL !
  sht @ 0= IF EXIT THEN
  sht @ sht.khL DUP @ IF xt SWAP RECURSE ELSE DROP THEN
  sht @ sht.value @ STR@ sht @ sht.key @ STR@ sht @ xt EXECUTE
  sht @ sht.khR DUP @ IF xt SWAP RECURSE ELSE DROP THEN
  uST-RECLEVEL @ 1- uST-RECLEVEL !
;

: ST-FOREACH-VHASHED { xt sht \ pnode -- }
\ xt: ( ... vala valu keya keyu node -- ... )
\ ���� �� ���������� ��������� (�� ������) �� ������,
\ �.�. � ����� ������ �� �� ���� ������
\ � ���� �� �� ���� ���������, ���� ��� �������� � ������
  uST-RECLEVEL 1+! uST-RECLEVEL @ uST-MAXRECLEVEL @ MAX uST-MAXRECLEVEL !
  sht @ 0= IF EXIT THEN
  sht @ sht.vhL DUP @ IF xt SWAP RECURSE ELSE DROP THEN
  sht @ sht.value @ STR@ sht @ sht.key @ STR@ sht @ xt EXECUTE
  sht @ sht.vhR DUP @ IF xt SWAP RECURSE ELSE DROP THEN
  uST-RECLEVEL @ 1- uST-RECLEVEL !
;
