\ 10-01-2007 ~mOleg
\ ������ ������ �����, ����������� �� ����������

REQUIRE CODE  lib\ext\spf-asm.f

\ ��������� ���������� ��� � �����
\ �� ����� ������� �������
CODE ?bits ( N --> # )
           XOR EBX, EBX
      @@1: OR EAX, EAX
          JZ @@2
           MOV EDX, EAX
           AND EDX, # 1
           ADD EBX, EDX
           SHR EAX, # 1
          JMP @@1
      @@2: MOV EAX, EBX
         RET
      END-CODE