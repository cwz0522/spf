( ��������� ������� ���������� ��� WINAPI � WNDPROC
  Windows-��������� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)


VARIABLE AOLL
VARIABLE AOGPA

CODE _WINAPI-CODE

      LEA  EBP, -4 [EBP]
      MOV  [EBP], EAX

      POP  EBX
      MOV  EAX, [EBX]
      OR   EAX, EAX
      JNZ  SHORT @@1

      PUSH EBX
      PUSH EDI
      PUSH EBP
      MOV  EAX, 4 [EBX]
      PUSH EAX
      A; 0xA1 C,  AddrOfLoadLibrary
      ALSO FORTH , PREVIOUS \   MOV  EAX, AddrOfLoadLibrary
A; HERE 4 - ' AOLL EXECUTE !
      CALL EAX
      OR   EAX, EAX
      POP EBP
      POP EDI
      POP EBX
      JZ  SHORT @@2

      PUSH EDI
      PUSH EBP
      MOV  ECX, 8 [EBX]
      PUSH ECX
      PUSH EAX
      A; 0xA1 C,  AddrOfGetProcAddress
      ALSO FORTH , PREVIOUS \    MOV  EAX, AddrOfGetProcAddress
A; HERE 4 - ' AOGPA EXECUTE !
      CALL EAX
      OR   EAX, EAX
      POP EBP
      POP EDI
      JZ  SHORT @@2
      MOV [EBX], EAX

@@1:  PUSH EDI
      PUSH EBP
      SUB  ESP, # 64
      MOV  EDI, ESP
      MOV  ESI, EBP
      A;  0xB9  C,  0x10 W, 0 W, \   MOV  ECX, # 16
      CLD
      REP MOVS DWORD
      MOV  EBP, ESP
      CALL EAX
      MOV  EBX, EBP
      SUB  EBX, ESP
      MOV  ESP, EBP
      ADD  ESP, # 64
      POP EBP
      SUB EBP, EBX
      POP EDI

@@2:  RET

END-CODE

' _WINAPI-CODE TO WINAPI-CODE

CODE API-CALL ( ... extern-addr -- x )
\ ����� ������� ������� (API ��� ������ ������� ����� COM)

      PUSH EDI
      PUSH EBP
      SUB  ESP, # 64
      MOV  EDI, ESP
      MOV  ESI, EBP
      MOV  ECX, # 16
      CLD
      REP MOVS DWORD
      MOV  EBP, ESP
      CALL EAX
      MOV  EBX, EBP
      SUB  EBX, ESP
      MOV  ESP, EBP
      ADD  ESP, # 64
      POP EBP
      SUB EBP, EBX
      POP EDI
      RET
END-CODE

CODE _WNDPROC-CODE
     MOV  EAX, ESP
     SUB  ESP, # #ST-RES
     PUSH EBP
     MOV  EBP, 4 [EAX] ( ����� �������� �� CALLBACK )
     PUSH EBP
     MOV  EBP, EAX
     ADD  EBP, # 12
     PUSH EBX
     PUSH ECX
     PUSH EDX
     PUSH ESI
     PUSH EDI
     MOV  EAX, [EAX] ( ����� ������ ����-��������� )
     MOV  EBX, [EAX]
     MOV  EAX, -4 [EBP]
     CALL EBX
     LEA  EBP, -4 [EBP]
     MOV  [EBP], EAX
     POP  EDI
     POP  ESI
     POP  EDX
     POP  ECX
     POP  EBX
     MOV  EAX, ESP
     MOV  ESP, EBP
     MOV  EBP, 4 [EAX] \ ����������� EBP
     MOV  EAX, [EAX]   \ ����� �������� �� CALLBACK
     XCHG EAX, [ESP]
     RET
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
     INT 3
END-CODE


' _WNDPROC-CODE TO WNDPROC-CODE

VECT FORTH-INSTANCE>  \ ��� ��������� ����� ����������� �� �����
VECT <FORTH-INSTANCE  \ � ������ � WNDPROC-��������� (������������� TlsIndex)

' FORTH-INSTANCE> TO TC-FORTH-INSTANCE>
' <FORTH-INSTANCE TO TC-<FORTH-INSTANCE

3968 CONSTANT #ST-RES
