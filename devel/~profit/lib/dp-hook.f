\ �������� ���� ����� ���������� � ��������

\ ������������� �������� DP-HOOK ���� ����� ��������
\ �������� �������� �� �������� ������ ����������.

\ ��������� �����. � �� ������� ���� ������� ��� � SPF
\ DP -- �� ����������, � "�����" �����������, �������
\ ��� ����� ��������� "�� ����".

\ ��-�� ��������� ~ac/lib/ns/so-xt.f c NEAR_NFA:
\ http://sourceforge.net/tracker/index.php?func=detail&aid=1734449&group_id=17919&atid=117919
\ ���������� DUPLICATE �������� ��������� ����� ������� ��� ����� �� ����.

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE R@ENTER, ~profit/lib/bac4th.f
REQUIRE REPLACE-WORD lib/ext/patch.f
REQUIRE NextNFA lib\ext\vocs.f

MODULE: dp-hook

\ ������� �� lib/ext/disasm.f
: FIND-REST-END ( xt -- addr | 0)
    DUP NextNFA DUP
    IF 
      NIP
      NAME>C 1- \ Skip CFA field
    ELSE
      DROP
      DP @ - ABS 100 > IF 0 EXIT THEN \ no applicable end found
      DP @ 1-
    THEN

    BEGIN \ Skip alignment
      DUP C@ 0= WHILE 1- 
    REPEAT ;


\ : DUPLICATE HEADER ' DUP FIND-REST-END OVER - HERE SWAP DUP ALLOT RET, CMOVE ;
: DUPLICATE HEADER ' 10000 HERE SWAP DUP ALLOT RET, CMOVE ;
\ ���� �� ������ ��� �����. � ������ ������ �����
\ �����������. � ������� ����� ������� ����������
\ ��� ���� � _��������_ ��� � ����� �����.
\ ������������� �������� � �������� jmp � call ��������

DUPLICATE DP1 DP \ �������� ���������� DP � DP1 , ��� ��� DP �� ������ �������
\ SEE DP1 \ �������������� ��� DP1 ��������� DP

EXPORT

' NOOP ->VARIABLE &DP-HOOK \ ���������� ������ ����� ���� ����������� ����������
\ xt � &DP-HOOK -- ����������� ����������, � �� ����� ������ ������ ��������/�����������

\ ������������ ������������� ����������� (scattered colon)
\ ���������� ����� �������, ������� ������� ���. ���� ����� 
\ ���� �� � ��������� �����������, �� ����� 
\ ����������-���������/����������-����� ������� ��� bac4th'�
\ ��-�� ����������� � �������������� (��. ~profit/lib/compile2Heap.f)
:NONAME &DP-HOOK @ >R ['] NOOP &DP-HOOK ! [ R@ENTER, ]  R> &DP-HOOK ! DP1 ; ' DP REPLACE-WORD
\ �������� �������� ��� �� ����� ������� ����������� ��������
\ ���������. ��� ������� ��� ���� ����� ����� ���� �������������
\ ������������ HERE � ������ � ����� DP-HOOK

: SET-DP-HOOK ( xt --> \ <-- ) PRO  &DP-HOOK B!  CONT ; \ �������� �� ����� ������ ����������� xt ��� ����������� ����������
: DIS-DP-HOOK ( --> \ <-- ) PRO  ['] NOOP &DP-HOOK B!  CONT ; \ ��������� ��� ������������ ���������� �� ����� ������ �����������

;MODULE

/TEST
:NONAME ." ." ; &DP-HOOK !

$> 1 ,
$> : r DUP ;

:NONAME HERE . ; &DP-HOOK !


$> 1 ,
$> : r1 DUP ;