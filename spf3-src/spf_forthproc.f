( �������� �������������� ����� "����-����������"
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

( ���������� ��� ��������������� ������ ����.
  ESP - ��������� ����� ���������
  EBP - ��������� ����� ������
  EDI - ����������� ������� [��������� ������ ������ � SPF]
)

HEX

\ ================================================================
\ �������� �����������

CODE DUP ( x -- x x ) \ 94
\ �������������� x.
     MOV EAX, [EBP]
     SUB EBP, # 4
     MOV [EBP], EAX
     RET
END-CODE

CODE 2DUP ( x1 x2 -- x1 x2 x1 x2 ) \ 94
\ �������������� ���� ����� x1 x2.
       XCHG EBP, ESP
       POP EAX
       POP ECX
       PUSH ECX
       PUSH EAX
       PUSH ECX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE ?DUP ( x -- 0 | x x ) \ 94
\ �������������� x, ���� �� ����.
     MOV EAX, [EBP]
     OR  EAX, EAX
     JZ  @@1
     SUB EBP, # 4
     MOV [EBP], EAX
@@1: RET
END-CODE

CODE DROP ( x -- ) \ 94
\ ������ x �� �����.
     ADD EBP, # 4
     RET
END-CODE

CODE 2DROP ( x1 x2 -- ) \ 94
\ ������ �� ����� ���� ����� x1 x2.
     ADD EBP, # 8
     RET
END-CODE

CODE SWAP ( x1 x2 -- x2 x1 ) \ 94
\ �������� ������� ��� ������� �������� �����
     MOV EAX, [EBP]
     MOV EBX, 4 [EBP]
     MOV [EBP], EBX
     MOV 4 [EBP], EAX
     RET
END-CODE

CODE 2SWAP ( x1 x2 x3 x4 -- x3 x4 x1 x2 ) \ 94
\ �������� ������� ��� ������� ���� �����.
     XCHG EBP, ESP
     POP EAX
     POP EBX
     POP ECX
     POP EDX
     PUSH EBX
     PUSH EAX
     PUSH EDX
     PUSH ECX
     XCHG EBP, ESP
     RET
END-CODE

CODE OVER ( x1 x2 -- x1 x2 x1 ) \ 94
\ �������� ����� x1 �� ������� �����.
     MOV EAX, 4 [EBP]
     SUB EBP, # 4
     MOV [EBP], EAX
     RET
END-CODE

CODE 2OVER ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 ) \ 94
\ ���������� ���� ����� x1 x2 �� ������� �����.
     MOV EAX, 0C [EBP]
     MOV EBX, 8 [EBP]
     XCHG EBP, ESP
     PUSH EAX
     PUSH EBX
     XCHG EBP, ESP
     RET
END-CODE

CODE NIP ( x1 x2 -- x2 ) \ 94 CORE EXT
\ ������ ������ ������� ��� �������� �����.
     MOV EAX, [EBP]
     ADD EBP, # 4
     MOV [EBP], EAX
     RET
END-CODE

CODE ROT ( x1 x2 x3 -- x2 x3 x1 ) \ 94
\ ���������� ��� ������� �������� �����.
     XCHG EBP, ESP
     POP ECX
     POP EBX
     POP EAX
     PUSH EBX
     PUSH ECX
     PUSH EAX
     XCHG EBP, ESP
     RET
END-CODE


\ ================================================================
\ ���� ���������

\ CODE >R    \ 94
\ ����������: ( x -- ) ( R: -- x )
\ ��������� x �� ���� ���������.
\ �������������: ��������� � ������ ������������� �� ����������.
\     MOV EAX, [EBP]
\     ADD EBP, # 4
\     POP EBX
\     PUSH EAX
\     PUSH EBX
\     RET
\ END-CODE

( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 18.04.2000 )

CODE >R    \ 94
\ ����������: ( x -- ) ( R: -- x )
\ ��������� x �� ���� ���������.
\ �������������: ��������� � ������ ������������� �� ����������.
     MOV EAX, [EBP]
     ADD EBP, # 4
     POP EBX
     PUSH EAX
     JMP EBX
END-CODE

\ CODE R>    \ 94
\ ����������: ( -- x ) ( R: x -- )
\ ��������� x �� ����� ��������� �� ���� ������.
\ �������������: ��������� � ������ ������������� �� ����������.
\     POP EBX
\     POP EAX
\     PUSH EBX
\     SUB EBP, # 4
\     MOV [EBP], EAX
\     RET
\ END-CODE

( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 18.04.2000 )

CODE R>    \ 94
\ ����������: ( -- x ) ( R: x -- )
\ ��������� x �� ����� ��������� �� ���� ������.
\ �������������: ��������� � ������ ������������� �� ����������.
     POP EBX
     POP EAX
     SUB EBP, # 4
     MOV [EBP], EAX
     JMP EBX
END-CODE

CODE 2>R   \ 94 CORE EXT
\ �������������: ��������� ������������.
\ ����������: ( x1 x2 -- ) ( R: -- x1 x2 )
\ ��������� ���� ����� x1 x2 �� ���� ���������. ������������ 
\ ������������ SWAP >R >R.
     MOV   ECX, [EBP]
     MOV   EBX, 4 [EBP]
     ADD   EBP, # 8
     POP   EAX
     PUSH  EBX
     PUSH  ECX
     PUSH  EAX
     RET
END-CODE

CODE 2R>  \ 94 CORE EXT
\ �������������: ��������� ������������.
\ ����������: ( -- x1 x2 ) ( R: x1 x2 -- )
\ ��������� ���� ����� x1 x2 �� ����� ���������. ������������ 
\ ������������ R> R> SWAP.
     POP EAX
     POP ECX
     POP EBX
     PUSH EAX
     SUB EBP, # 8
     MOV [EBP], ECX
     MOV 4 [EBP], EBX
     RET
END-CODE

\ CODE R@    \ 94
\ ����������: ( -- x ) ( R: x -- x )
\ �������������: ��������� � ������ ������������� ������������.
\     SUB EBP, # 4
\     POP EBX
\     POP EAX
\     PUSH EAX
\     PUSH EBX
\     MOV [EBP], EAX
\     RET
\ END-CODE

( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 17.04.2000 )

CODE R@ \ 94
\ ����������: ( -- x ) ( R: x -- x )
\ �������������: ��������� � ������ ������������� ������������.
   SUB EBP, # 4
   MOV EAX, DWORD 4 [ESP]
   MOV DWORD [EBP], EAX
   RET
END-CODE   


CODE 2R@  \ 94 CORE EXT
\ �������������: ��������� ������������.
\ ����������: ( -- x1 x2 ) ( R: x1 x2 -- x1 x2 )
\ ���������� ���� ����� x1 x2 �� ����� ���������. ������������ 
\ ������������ R> R> 2DUP >R >R SWAP.
     POP EAX
     POP ECX
     POP EBX
     PUSH EBX
     PUSH ECX
     PUSH EAX
     SUB EBP, # 8
     MOV [EBP], ECX
     MOV 4 [EBP], EBX
     RET
END-CODE

\ CODE RDROP ( -> )
\     POP EBX
\     POP EAX
\     PUSH EBX
\     RET
\ END-CODE

( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 18.04.2000 )

CODE RDROP ( -> )
     POP EAX
     POP EBX
     JMP EAX
END-CODE

' RDROP TO TC-RDROP

\ ================================================================
\ �������� � �������

CODE @ ( a-addr -- x ) \ 94
\ x - �������� �� ������ a-addr.
     MOV EBX, [EBP]
     MOV EAX, [EBX]
     MOV [EBP], EAX
     RET
END-CODE

CODE ! ( x a-addr -- ) \ 94
\ �������� x �� ������ a-addr.
     MOV EBX, [EBP]
     MOV EAX, 4 [EBP]
     MOV [EBX], EAX
     ADD EBP, # 8
     RET
END-CODE

CODE C@ ( c-addr -- char ) \ 94
\ �������� ������ �� ������ c-addr. ���������� ������� ���� ������ �������.
     MOV EBX, [EBP]
     XOR EAX, EAX
     MOV AL,  [EBX]
     MOV [EBP], EAX
     RET
END-CODE

CODE C! ( char c-addr -- ) \ 94
\ �������� char �� ������ a-addr.
     MOV EBX, [EBP]
     MOV EAX, 4 [EBP]
     MOV [EBX], AL
     ADD EBP, # 8
     RET
END-CODE

CODE W@ ( c-addr -- word )
\ �������� word �� ������ c-addr. ���������� ������� ���� ������ �������.
     MOV EBX, [EBP]
     XOR EAX, EAX
     MOV AX,  [EBX]
     MOV [EBP], EAX
     RET
END-CODE

CODE W! ( word c-addr -- )
\ �������� word �� ������ a-addr.
     MOV EBX, [EBP]
     MOV EAX, 4 [EBP]
     MOV [EBX], AX
     ADD EBP, # 8
     RET
END-CODE

CODE 2@ ( a-addr -- x1 x2 ) \ 94
\ �������� ���� ����� x1 x2, ���������� �� ������ a-addr.
\ x2 �� ������ a-addr, x1 � ��������� ������.
\ ����������� DUP CELL+ @ SWAP @
     XCHG EBP, ESP
     POP EBX
     MOV EAX, 4 [EBX]
     PUSH EAX
     MOV EAX, [EBX]
     PUSH EAX
     XCHG EBP, ESP
     RET
END-CODE

CODE 2! ( x1 x2 a-addr -- ) \ 94
\ �������� ���� ����� x1 x2 �� ������ a-addr,
\ x2 �� ������ a-addr, x1 � ��������� ������.
\ ����������� SWAP OVER ! CELL+ !
     XCHG EBP, ESP
     POP EBX
     POP EAX
     MOV [EBX], EAX
     POP EAX
     MOV 4 [EBX], EAX
     XCHG EBP, ESP
     RET
END-CODE

\ ================================================================
\ ����������

CODE 1+ ( n1|u1 -- n2|u2 ) \ 94
\ ��������� 1 � n1|u1 � �������� ����� u2|n2.
     INC DWORD [EBP]
     RET
END-CODE

CODE 1- ( n1|u1 -- n2|u2 ) \ 94
\ ������� 1 �� n1|u1 � �������� �������� n2|u2.
     DEC DWORD [EBP]
     RET
END-CODE

CODE 2+ ( W -> W+2 )
     ADD DWORD [EBP], # 2
     RET
END-CODE

CODE 2- ( W -> W-2 )
     SUB DWORD [EBP], # 2
     RET
END-CODE

CODE + ( n1|u1 n2|u2 -- n3|u3 ) \ 94
\ ������� n1|u1 � n2|u2 � �������� ����� n3|u3.
     MOV EAX, [EBP]
     ADD EBP, # 4
     ADD [EBP], EAX
     RET
END-CODE

CODE D+ ( d1|ud1 d2|ud2 -- d3|ud3 ) \ 94 DOUBLE
\ ������� d1|ud1 � d2|ud2 � ���� ����� d3|ud3.
       XCHG EBP, ESP
       POP ECX
       POP EAX
       MOV EBX, ESP
       ADD 4 [EBX], EAX
       ADC [EBX], ECX
       XCHG EBP, ESP
       RET
END-CODE

CODE - ( n1|u1 n2|u2 -- n3|u3 ) \ 94
\ ������� n2|u2 �� n1|u1 � �������� �������� n3|u3.
     MOV EAX, [EBP]
     ADD EBP, # 4
     SUB [EBP], EAX
     RET
END-CODE

CODE 1+! ( A -> )
     MOV EBX, [EBP]
     ADD EBP, # 4
     INC DWORD [EBX]
     RET
END-CODE

CODE 0! ( A -> )
     MOV EBX, [EBP]
     ADD EBP, # 4
     MOV DWORD [EBX], # 0
     RET
END-CODE

CODE COUNT ( c-addr1 -- c-addr2 u ) \ 94
\ �������� ������ �������� �� ������ �� ��������� c-addr1.
\ c-addr2 - ����� ������� ������� �� c-addr1.
\ u - ���������� ����� c-addr1, ���������� ������ ������ ��������,
\ ������������ � ������ c-addr2.
     MOV EBX, [EBP]
     XOR EAX, EAX
     MOV AL, [EBX]
     INC EBX
     MOV [EBP], EBX
     SUB EBP, # 4
     MOV [EBP], EAX
     RET
END-CODE

CODE * ( n1|u1 n2|u2 -- n3|u3 ) \ 94
\ ����������� n1|u1 � n2|u2 � �������� ������������ n3|u3.
       XCHG EBP, ESP
       POP  EAX
       POP  ECX
       IMUL ECX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE AND ( x1 x2 -- x3 ) \ 94
\ x3 - ��������� "�" x1 � x2.
     MOV EAX, [EBP]
     ADD EBP, # 4
     AND [EBP], EAX
     RET
END-CODE

CODE OR ( x1 x2 -- x3 ) \ 94
\ x3 - ��������� "���" x1 � x2.
     MOV EAX, [EBP]
     ADD EBP, # 4
     OR  [EBP], EAX
     RET
END-CODE

CODE XOR ( x1 x2 -- x3 ) \ 94
\ x3 - ��������� "����������� ���" x1 � x2.
     MOV EAX, [EBP]
     ADD EBP, # 4
     XOR [EBP], EAX
     RET
END-CODE

CODE INVERT ( x1 -- x2 ) \ 94
( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 06.09.2000 )

\ ������������� ��� ���� x1 � �������� ���������� �������� x2.
\     MOV EAX, [EBP]
\     NOT EAX
\     MOV [EBP], EAX
     NOT DWORD [EBP]
     RET
END-CODE

\ CODE NEGATE ( n1 -- n2 ) \ 94
\ n2 - �������������� �������� n1.
\      MOV EAX, [EBP]
\      NEG EAX
\      MOV [EBP], EAX
\      RET
\ END-CODE

( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 07.03.2000 )

CODE NEGATE 
       NEG DWORD [EBP]
       RET
END-CODE

CODE DNEGATE ( d1 -- d2 ) \ 94 DOUBLE
\ d2 ��������� ��������� d1 �� ����.
       XCHG EBP, ESP
       POP  EBX
       POP  ECX
       XOR  EAX, EAX
       SUB  EAX, ECX
       MOV  EDX, # 0
       SBB  EDX, EBX
       PUSH EAX
       PUSH EDX
       XCHG EBP, ESP
       RET
END-CODE

CODE ABS ( n -- u ) \ 94
\ u - ���������� �������� n.
       MOV EAX, [EBP]
       OR  EAX, EAX
       JNS @@1
       NEG EAX
@@1:   MOV [EBP], EAX
       RET
END-CODE

CODE NOOP ( -> )
     RET
END-CODE

CODE S>D ( n -- d ) \ 94
\ ������������� ����� n � ������� ����� d � ��� �� �������� ���������.
       XCHG EBP, ESP
       POP EAX
       CDQ
       PUSH EAX
       PUSH EDX
       XCHG EBP, ESP
       RET
END-CODE

CODE D>S ( d -- n ) \ 94 DOUBLE
\ n - ���������� d.
\ �������������� �������� ���������, ���� d ��������� ��� ���������
\ �������� ��������� �����.
     ADD EBP, # 4
     RET
END-CODE

CODE U>D ( U -> D ) \ ��������� ����� �� ������� �������� �����
     XCHG EBP, ESP
     XOR  EBX, EBX
     PUSH EBX
     XCHG EBP, ESP
     RET
END-CODE


CODE UM* ( u1 u2 -- ud ) \ 94
\ ud - ������������ u1 � u2. ��� �������� � ���������� �����������.
       XCHG EBP, ESP
       POP  ECX
       POP  EAX
       MUL  ECX
       PUSH EAX
       PUSH EDX
       XCHG EBP, ESP
       RET
END-CODE

CODE / ( n1 n2 -- n3 ) \ 94
\ ������ n1 �� n2, �������� ������� n3.
\ �������������� �������� ���������, ���� n2 ����� ����.
\ ���� n1 � n2 ����������� �� ����� - ������������ ��������� ������� �� 
\ ����������.
       XCHG EBP, ESP
       POP  ECX
       POP  EAX
       CDQ
       IDIV ECX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE U/ ( W1, W2 -> W3 ) \ ����������� ������� W1 �� W2
       XCHG EBP, ESP
       POP  ECX
       POP  EAX
       XOR  EDX, EDX
       DIV  ECX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE +! ( n|u a-addr -- ) \ 94
\ ��������� n|u � ���������� ����� �� ������ a-addr.
     XCHG EBP, ESP
     POP  EBX
     POP  EAX
     ADD  [EBX], EAX
     XCHG EBP, ESP
     RET
END-CODE

CODE MOD ( n1 n2 -- n3 ) \ 94
\ ������ n1 �� n2, �������� ������� n3.
\ �������������� �������� ���������, ���� n2 ����� ����.
\ ���� n1 � n2 ����������� �� ����� - ������������ ��������� ������� �� 
\ ����������.
       XCHG EBP, ESP
       POP ECX
       POP EAX
       CDQ
       IDIV ECX
       PUSH EDX
       XCHG EBP, ESP
       RET
END-CODE

CODE UMOD ( W1, W2 -> W3 ) \ ������� �� ������� W1 �� W2
       XCHG EBP, ESP
       POP  ECX
       POP  EAX
       XOR  EDX, EDX
       DIV  ECX
       PUSH EDX
       XCHG EBP, ESP
       RET
END-CODE

CODE UM/MOD ( ud u1 -- u2 u3 ) \ 94
\ ������ ud �� u1, �������� ������� u3 � ������� u2.
\ ��� �������� � ���������� �����������.
\ �������������� �������� ���������, ���� u1 ���� ��� �������
\ ��������� ��� ��������� ��������� ����������� �����.
       XCHG EBP, ESP
       POP ECX
       POP EDX
       POP EAX
       DIV ECX
       PUSH EDX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE MAX ( n1 n2 -- n3 ) \ 94
\ n3 - ������� �� n1 � n2.
       XCHG EBP, ESP
       POP EAX
       POP ECX
       CMP EAX, ECX
       JG  @@1
       PUSH ECX
       JMP @@2
@@1:   PUSH EAX
@@2:   XCHG EBP, ESP
       RET
END-CODE

CODE MIN ( n1 n2 -- n3 ) \ 94
 \ n3 - ������� �� n1 � n2.
       XCHG EBP, ESP
       POP EAX
       POP ECX
       CMP ECX, EAX
       JG @@1
       PUSH ECX
       JMP @@2
@@1:   PUSH EAX
@@2:   XCHG EBP, ESP
       RET
END-CODE

CODE 2/ ( x1 -- x2 ) \ 94
\ x2 - ��������� ������ x1 �� ���� ��� ������ ��� ��������� �������� ����.
     MOV EAX, [EBP]
     SAR EAX, # 1
     MOV [EBP], EAX
     RET
END-CODE

CODE */MOD ( n1 n2 n3 -- n4 n5 ) \ 94
\ �������� n1 �� n2, �������� ������������� ������� ��������� d.
\ ��������� d �� n3, �������� ������� n4 � ������� n5.
       XCHG EBP, ESP
       POP EBX
       POP ECX
       POP EAX
       IMUL ECX
       IDIV EBX
       PUSH EDX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE M* ( n1 n2 -- d ) \ 94
\ d - �������� ��������� ��������� n1 �� n2.
     MOV EAX, [EBP]
     MOV EDX, 4 [EBP]
     IMUL EDX
     MOV 4 [EBP], EAX
     MOV [EBP], EDX
     RET
END-CODE

CODE LSHIFT ( x1 u -- x2 ) \ 94
\ �������� x1 �� u ��� �����. ��������� ���� � �������� �������� ����,
\ ������������� ��� ������.
\ ������������� �������� ���������, ���� u ������ ��� �����
\ ����� ��� � ������.
     XCHG EBP, ESP
     POP ECX
     POP EAX
     SHL EAX, CL
     PUSH EAX
     XCHG EBP, ESP
     RET
END-CODE

CODE RSHIFT ( x1 u -- x2 ) \ 94
\ �������� x1 �� u ��� ������. ��������� ���� � �������� �������� ����,
\ ������������� ��� ������.
\ ������������� �������� ���������, ���� u ������ ��� �����
\ ����� ��� � ������.
     XCHG EBP, ESP
     POP ECX
     POP EAX
     SHR EAX, CL
     PUSH EAX
     XCHG EBP, ESP
     RET
END-CODE

CODE SM/REM ( d1 n1 -- n2 n3 ) \ 94
\ ��������� d1 �� n1, �������� ������������ ������� n3 � ������� n2.
\ ������� � �������� ��������� ��������.
\ ������������� �������� ���������, ���� n1 ����, ��� ������� ���
\ ��������� ��������� �������� �����.
     XCHG EBP, ESP
     POP EBX
     POP EDX
     POP EAX
     IDIV EBX
     PUSH EDX
     PUSH EAX
     XCHG EBP, ESP
     RET
END-CODE

CODE FM/MOD ( d1 n1 -- n2 n3 ) \ 94
\ ��������� d1 �� n1, �������� ������� n3 � ������� n2.
\ ������� � �������� ��������� ��������.
\ ������������� �������� ���������, ���� n1 ����, ��� ������� ���
\ ��������� ��������� �������� �����.
     XCHG EBP, ESP
     POP EBX
     POP EDX
     POP EAX
     PUSH EAX
     IDIV EBX
     OR EAX, EAX
     JS @@1
@@2: POP EBX
     PUSH EDX
     PUSH EAX
     XCHG EBP, ESP
     RET
@@1: OR EDX, EDX
     JZ @@2
     DEC EAX
     MOV ECX, EAX
     IMUL EBX
     POP EBX
     SUB EBX, EAX
     PUSH EBX
     PUSH ECX
     XCHG EBP, ESP
     RET
END-CODE

CODE DIGIT ( C, N1 -> N2, TF / FF ) \ N2 - �������� ������ C ���
           \ ����� � ������� ��������� �� ��������� N1
       XCHG EBP, ESP
       POP ECX
       POP EAX
       CMP AL, # 30
       JC @@1
       CMP AL, # 3A
       JNC @@2
       SUB AL, # 30
       CMP AL, CL
       JNC @@1
       PUSH EAX
       JMP @@3
@@2:   CMP AL, # 41
       JC @@1
       SUB AL, # 37
       CMP AL, CL
       JNC @@1
       PUSH EAX
@@3:   MOV EAX, # -1
       PUSH EAX
@@4:   XCHG EBP, ESP
       RET
@@1:   XOR EAX, EAX
       PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

\ ================================================================
\ ���������

CODE = ( x1 x2 -- flag ) \ 94
\ flag "������" ����� � ������ �����, ����� x1 ������� ����� x2.
     MOV EAX, [EBP]
     ADD EBP, # 4
     CMP [EBP], EAX
     MOV EAX, # 0
     JNZ @@1
     NOT EAX
@@1: MOV [EBP], EAX
     RET
END-CODE

CODE <> ( x1 x2 -- flag ) \ 94 CORE EXT
\ flag "������" ����� � ������ �����, ����� x1 �� ����� x2.
     MOV EAX, [EBP]
     ADD EBP, # 4
     CMP [EBP], EAX
     MOV EAX, # -1
     JNZ @@1
     NOT EAX
@@1: MOV [EBP], EAX
     RET
END-CODE

CODE < ( n1 n2 -- flag ) \ 94
\ flag "������" ����� � ������ �����, ����� n1 ������ n2.
       MOV ECX, [EBP]
       ADD EBP, # 4
       MOV EAX, [EBP]
       SUB EAX, ECX
       MOV EAX, # 0
       JNL @@1
       NOT EAX
@@1:   MOV [EBP], EAX
       RET
END-CODE

CODE > ( n1 n2 -- flag ) \ 94
\ flag "������" ����� � ������ �����, ����� n1 ������ n2.
       MOV ECX, [EBP]
       ADD EBP, # 4
       MOV EAX, [EBP]
       SUB EAX, ECX
       MOV EAX, # 0
       JNG @@1
       NOT EAX
@@1:   MOV [EBP], EAX
       RET
END-CODE

CODE D< ( d1 d2 -- flag ) \ DOUBLE
\ flag "������" ����� � ������ �����, ����� d1 ������ d2.
       XCHG EBP, ESP
       POP  EBX
       POP  EAX
       POP  EDX
       POP  ECX
       SUB  ECX, EAX
       SBB  EDX, EBX
       MOV  EAX, # 0
       JNS  @@1
       NOT  EAX
@@1:   PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE U< ( u1 u2 -- flag ) \ 94
\ flag "������" ����� � ������ �����, ����� u1 ������ u2.
       XCHG EBP, ESP
       POP  ECX
       POP  EAX
       CMP  EAX, ECX
       JB   @@1
       XOR  EAX, EAX
       JMP  @@2
@@1:   MOV  EAX, # -1
@@2:   PUSH EAX
       XCHG EBP, ESP
       RET
END-CODE

CODE 0< ( n -- flag ) \ 94
\ flag "������" ����� � ������ �����, ����� n ������ ����.
       MOV EAX, [EBP]
       SHL EAX, # 1  \ �� ������������ ��������� ��������� :)
       SBB EAX, EAX
@@1:   MOV [EBP], EAX
       RET
END-CODE

CODE 0= ( x -- flag ) \ 94
\ flag "������" ����� � ������ �����, ����� x ����� ����.
     XOR EAX, EAX
     CMP DWORD [EBP], # 0
     JNZ @@1
     NOT EAX
@@1: MOV [EBP], EAX
     RET
END-CODE

CODE 0<> ( x -- flag ) \ 94 CORE EXT
\ flag "������" ����� � ������ �����, ����� x �� ����� ����.
     XOR EAX, EAX
     CMP DWORD [EBP], # 0
     JZ  @@1
     NOT EAX
@@1: MOV [EBP], EAX
     RET
END-CODE

CODE D0= ( xd -- flag ) \ 94 DOUBLE
\ flag "������" ����� � ������ �����, ����� xd ����� ����.
        XCHG EBP, ESP
        POP EAX
        POP ECX
        OR EAX, ECX
        MOV EAX, # -1
        JZ @@1
        NOT EAX
@@1:    PUSH EAX
        XCHG EBP, ESP
        RET
END-CODE

\ ================================================================
\ ������

CODE -TRAILING ( c-addr u1 -- c-addr u2 ) \ 94 STRING
\ ���� u1 ������ ����, u2 ����� u1, ������������ �� ���������� �������� � ����� 
\ ���������� ������, �������� c-addr � u1. ���� u1 ���� ��� ��� ������ ������� 
\ �� ��������, u2 ����.
      PUSH EDI
      MOV ECX, [EBP]
      JCXZ @@1
      MOV EDI, 4 [EBP]
      ADD EDI, ECX
      DEC EDI
      MOV AL, # 20
      STD
      REPZ SCAS BYTE
      JZ  @@2
      INC ECX
@@2:  CLD
      MOV [EBP], ECX
@@1:  POP EDI
      RET
END-CODE

CODE COMPARE ( c-addr1 u1 c-addr2 u2 -- n ) \ 94 STRING
\ �������� ������, �������� c-addr1 u1, �� �������, �������� c-addr2 u2.
\ ������ ������������, ������� � �������� �������, ������ �� ��������, �� ����� 
\ �������� �������� �� ����� ��� �� ���������� ��������. ���� ��� ������ 
\ ���������, n ����. ���� ��� ������ ��������� �� ����� �������� �������� �� 
\ �����, �� n ����� ������� (-1), ���� u1 ������ u2, ����� ������� (1).
\ ���� ��� ������ �� ��������� �� ����� �������� �������� �� �����, �� n ����� 
\ ������� (-1), ���� ������ ������������� ������ ������, �������� c-addr1 u1
\ ����� ������� �������� ��������, ��� ��������������� ������ � ������, 
\ �������� c-addr2 u2, � ������� � ��������� ������.
      PUSH EDI
      MOV EDX,   [EBP]
      MOV EDI, 4 [EBP]
      MOV ECX, 8 [EBP]
      MOV ESI, 0C [EBP]
      ADD EBP, # 0C
      CMP ECX, EDX
      PUSHFD
      JC  @@1
      MOV ECX, EDX
@@1:  JECXZ @@2
      CLD
      REPZ CMPS BYTE
      JZ  @@2
      POP EBX
      MOV EAX, # -1
      JC  @@3
      NEG EAX
      JMP @@3
@@2:  XOR EAX, EAX
      POPFD
      JZ  @@3
      MOV EAX, # -1
      JC  @@3
      NEG EAX
@@3:  MOV [EBP], EAX
      POP EDI
      RET
END-CODE

CODE SEARCH ( c-addr1 u1 c-addr2 u2 -- c-addr3 u3 flag ) \ 94 STRING
\ ���������� ����� � ������, �������� c-addr1 u1, ������, �������� c-addr2 u2.
\ ���� ���� "������", ���������� ������� �� ������ c-addr3 � ����������� u3
\ ���������. ���� ���� "����", ���������� �� �������, � c-addr3 ���� c-addr1,
\ � u3 ���� u1.
      PUSH EDI
      CLD
      MOV EBX,   [EBP]
      OR EBX, EBX
      JZ @@5
      MOV EDX, 8 [EBP]
      MOV EDI, 0C [EBP]
      ADD EDX, EDI
@@4:  MOV ESI, 4 [EBP]
      LODS BYTE
      MOV ECX, EDX
      SUB ECX, EDI
      JCXZ @@1
      REPNZ SCAS BYTE
      JNZ @@1   \ �� ���� ������ ��� ������� ������� ������� ������
      CMP EBX, # 1
      JZ @@2   \ ������� ������ ����� ����� 1 � �������
      MOV ECX, EBX
      DEC ECX
      MOV EAX, EDX
      SUB EAX, EDI
      CMP EAX, ECX
      JC @@1  \ ������� ������ ������ ������� ������
      PUSH EDI
      REPZ CMPS BYTE
      POP EDI
      JNZ @@4
@@2:  DEC EDI           \ ����� ������ ����������
      SUB EDX, EDI
      MOV 0C [EBP], EDI
      MOV  8 [EBP], EDX
@@5:  MOV EAX, # -1
      JMP @@3
@@1:  XOR EAX, EAX
@@3:  ADD EBP, # 4
      MOV [EBP], EAX
      POP EDI
      RET
END-CODE

\ CODE CMOVE ( c-addr1 c-addr2 u -- ) \ 94 STRING
\ ���� u ������ ����, ���������� u ���������������� �������� �� ������������ 
\ ������ ������� � ������ c-addr1 � c-addr2, ������ �� ��������, ������� � 
\ ������� ������� � �������.
\        PUSH EDI
\        XCHG EBP, ESP
\        POP ECX
\        POP EDI
\        POP ESI
\        JCXZ @@1
\        CLD
\        REP MOVS BYTE
\ @@1:   XCHG EBP, ESP
\        POP EDI
\        RET
\ END-CODE
( �������� ����� ������� ����������� [C] Dmitry Yakimov [ftech@tula.net] )
( 07.03.2000 )

CODE CMOVE ( c-addr1 c-addr2 u -- ) \ 94 STRING
\ ���� u ������ ����, ���������� u ���������������� �������� �� ������������ 
\ ������ ������� � ������ c-addr1 � c-addr2, ������ �� ��������, ������� � 
\ ������� ������� � �������.
       PUSH EDI
       XCHG EBP, ESP
       POP ECX \ u
       POP EDI \ addr2
       POP ESI \ addr1
       JCXZ @@2
       CLD
       MOV EAX, ECX
       SHR ECX, # 2
       JCXZ @@1
       REP MOVS DWORD
@@1:   MOV ECX, EAX
       AND ECX, # 3
       REP MOVS BYTE
@@2:   XCHG EBP, ESP
       POP EDI
       RET
END-CODE


CODE CMOVE> ( c-addr1 c-addr2 u -- ) \ 94 STRING
\ ���� u ������ ����, ���������� u ���������������� �������� �� ������������ 
\ ������ ������� � ������ c-addr1 � c-addr2, ������ �� ��������, ������� ��
\ ������� ������� � �������.
       PUSH EDI
       XCHG EBP, ESP
       POP ECX
       POP EDI
       POP ESI
       OR ECX, ECX
       JZ @@1
       STD
       ADD EDI, ECX
       DEC EDI
       ADD ESI, ECX
       DEC ESI
       REP MOVS BYTE
@@1:   CLD
       XCHG EBP, ESP
       POP EDI
       RET
END-CODE

CODE FILL ( c-addr u char -- ) \ 94
\ ���� u ������ ����, ������� char � u ������ �� ������ c-addr.
       PUSH EDI
       XCHG EBP, ESP
       POP  EAX
       POP  ECX
       POP  EDI
       OR   ECX, ECX
       JZ   @@1
       CLD
       REP STOS BYTE
@@1:   XCHG EBP, ESP
       POP EDI
       RET
END-CODE

CODE ASCIIZ> ( c-addr -- c-addr u )
     MOV  EBX, [EBP]
     XOR  EAX, EAX
@@1: MOV  AL, [EBX]
     INC  EBX
     OR   AL, AL
     JNZ  @@1
     DEC  EBX
     SUB  EBX, [EBP]
     SUB  EBP, # 4
     MOV  [EBP], EBX
     RET
END-CODE

\ ================================================================
\ ��������� ������

CODE SP! ( A -> )
     MOV EAX, [EBP]
     MOV EBP, EAX
     RET
END-CODE

CODE RP! ( A -> )
     MOV EAX, [EBP]
     ADD EBP, # 4
     POP EBX
     MOV ESP, EAX
     PUSH EBX
     RET
END-CODE

CODE SP@ ( -> A )
     MOV EAX, EBP
     SUB EBP, # 4
     MOV [EBP], EAX
     RET
END-CODE

CODE RP@ ( -- RP )
     POP EBX
     SUB EBP, # 4
     MOV [EBP], ESP
     PUSH EBX 
     RET
END-CODE

\ ================================================================
\ ���������

CODE 0 ( -> 0 )
     SUB EBP, # 4
     MOV DWORD [EBP], # 0
     RET
END-CODE

CODE 1 ( -> 1 )
     SUB EBP, # 4
     MOV DWORD [EBP], # 1
     RET
END-CODE

CODE -1 ( -> -1 )
     SUB EBP, # 4
     MOV DWORD [EBP], # -1
     RET
END-CODE

CODE 2 ( -> 2 )
     SUB EBP, # 4
     MOV DWORD [EBP], # 2
     RET
END-CODE

CODE 3 ( -> 3 )
     SUB EBP, # 4
     MOV DWORD [EBP], # 3
     RET
END-CODE

\ ================================================================
\ ����� ������������ (��� ��������������� ������ ����)

CODE EXECUTE ( i*x xt -- j*x ) \ 94
\ ������ xt �� ����� � ��������� �������� �� ���������.
\ ������ ��������� �� ����� ������������ ������, ������� �����������.
     MOV EBX, [EBP]
     ADD EBP, # 4
     JMP EBX
END-CODE

\ CODE EXIT \ 94
\ \ �������������: ��������� ������������.
\ \ ����������: ( -- ) ( R: nest-sys -- )
\ \ ���������� ���������� ����������� �����������, ��������� nest-sys.
\ \ ����� ����������� EXIT ������ do-loop ��������� ������ ������ ��������� ����� 
\ \ ����������� UNLOOP.
\      POP EAX
\      RET
\ END-CODE

\ ================================================================
\ ������� ������ (������ ������ �����)

CODE TlsIndex! ( x -- ) \ ��������� ���������� ���� ������
     MOV  EDI, [EBP]
     ADD  EBP, # 4
     RET
END-CODE

CODE TlsIndex@ ( -- x )
     SUB  EBP, # 4
     MOV  [EBP], EDI
     RET
END-CODE

CODE FS@ ( addr -- x )
     MOV  EBX, [EBP]
     MOV  EAX, FS: [EBX]
     MOV  [EBP], EAX
     RET
END-CODE

CODE FS! ( x addr -- )
     MOV  EBX, [EBP]
     MOV  EAX, 4 [EBP]
     MOV  FS: [EBX], EAX
     ADD  EBP, # 8
     RET
END-CODE

\ ================================================================
\ ��������� LOCALS

CODE DRMOVE ( x1 ... xn n*4 -- )
\ ��������� n ����� �� ����� ������ �� ���� ���������
     POP  EDX \ ����� ��������
     MOV  ESI, [EBP]
@@1: 
     8B C, 44 C, 35 C, 00 C, \ MOV  EAX, [EBP] [ESI]
     PUSH EAX
     SUB  ESI, # 4
     JNZ  @@1
     MOV  EAX, [EBP]
     ADD  EBP, EAX
     ADD  EBP, # 4
     JMP  EDX
END-CODE

CODE RP+@ ( offs -- x )
\ ����� ����� �� ��������� offs ���� �� ������� ����� ��������� (0 RP+@ == RP@)
     MOV  ESI, [EBP] A;
     8B C, 44 C, 34 C, 04 C, \ MOV EAX, 4 [ESP] [ESI]
     MOV [EBP], EAX
     RET
END-CODE
     
CODE RP+ ( offs -- addr )
\ ����� ����� �� ��������� offs ���� �� ������� ����� ���������
     MOV  ESI, [EBP] A;
     8D C, 44 C, 34 C, 04 C, \ LEA EAX, 4 [ESP] [ESI]
     MOV [EBP], EAX
     RET
END-CODE

CODE RP+! ( x offs -- )
\ �������� ����� x �� �������� offs ���� �� ������� ����� ���������
     MOV  EAX, 4 [EBP]
     MOV  ESI, [EBP]
     ADD  EBP, # 8  A;
     89 C, 44 C, 34 C, 04 C, \ MOV  4 [ESP] [ESI], EAX
     RET
END-CODE

CODE RALLOT ( n -- addr )
\ ��������������� n ����� �� ����� ���������
(     POP  EAX
     MOV  EBX, [EBP]
     SUB  ESP, EBX
     MOV  [EBP], ESP
     JMP  EAX
) \ ������� � �������������� (� �� ���� ������ 8� �������, exception �����)
     POP  EDX
     XOR  EAX, EAX
     MOV  ECX, [EBP]
@@1: PUSH EAX
     DEC  ECX
     JNZ  @@1
     MOV  [EBP], ESP
     JMP  EDX
END-CODE

CODE (RALLOT) ( n -- )
\ ��������������� n ����� �� ����� ���������
     POP  EDX
     XOR  EAX, EAX
     MOV  ECX, [EBP]
@@1: PUSH EAX
     DEC  ECX
     JNZ  @@1
     ADD  EBP, # 4
     JMP  EDX
END-CODE


\ CODE RFREE ( n -- )
\ ������� n ����� ����� ���������
\      MOV  EAX, [EBP]
\      ADD  EBP, # 4
\      ADD  EAX, EAX
\      ADD  EAX, EAX
\      ADD  ESP, EAX
\      RET
\ END-CODE

( ���������� ~DAY 21.10.2000 )

CODE RFREE ( n -- )
\ ������� n ����� ����� ���������
     POP  EDX
     MOV  EAX, [EBP]
     ADD  EBP, # 4
     ADD  EAX, EAX
     ADD  EAX, EAX
     ADD  ESP, EAX
     JMP  EDX
END-CODE

CODE (LocalsExit) ( -- )
\ ������� ������ � ���� ��������, ����� ���� ����� �� �����
     POP  EAX
     ADD  ESP, EAX
     RET
END-CODE

DECIMAL
