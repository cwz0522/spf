\ $Id$
\ Andrey Filatkin, af@forth.org.ru
\ �맮� ���譨� �㭪権, �ᯮ��஢����� �� c-�ࠢ����

S" lib\ext\spf-asm-tmp.f" INCLUDED
CODE _CAPI-CODE
      LEA  EBP, -4 [EBP]
      MOV  [EBP], EAX

      POP  EBX
      MOV  EAX, [EBX]
      OR   EAX, EAX
      JZ   SHORT @@3

@@1:  MOV  ECX, 12 [EBX]
      OR   ECX, ECX
      JZ   SHORT @@2
      LEA  EBX, [ECX*4]
      SUB  ESP, EBX
      MOV  EDX, EDI
      MOV  EDI, ESP
      MOV  ESI, EBP
      CLD
      REP  MOVS DWORD
      ADD  EBP, EBX
      MOV  EDI, EDX
      CALL EAX
      ADD  ESP, EBX
      RET

@@2:  CALL EAX
      RET

@@6:  4 ALIGN-NOP
@@3:  MOV  EAX, 4 [EBX]
      PUSH EAX
      MOV  EAX, IMAGE-BASE 0x1034 +
      CALL EAX
      OR   EAX, EAX
      JZ   SHORT @@4

      MOV  ECX, 8 [EBX]
      PUSH ECX
      PUSH EAX
      MOV  EAX, IMAGE-BASE 0x1038 +
      CALL EAX
      OR   EAX, EAX
      JZ   SHORT @@4
      MOV  [EBX], EAX
      JMP  SHORT @@1

@@4:  RET
END-CODE

: CAPI: ( "����楤���" "������⥪�" n -- )
  ( �ᯮ������ ��� ������ c-�㭪権.
    ����祭��� ��।������ �㤥� ����� ��� "����楤���".
    ���� address of winproc �㤥� ��������� � ������ ��ࢮ��
    �믮������ ����祭��� ᫮��୮� ����.
    ��� �맮�� ����祭��� "�����⭮�" ��楤��� ��ࠬ����
    ��������� �� �⥪ ������ � ���浪�, ���⭮� ���ᠭ����
    � ��-�맮�� �⮩ ��楤���. ������� �믮������ �㭪樨
    �㤥� ������� �� �⥪.
  )

  >IN @  HEADER  >IN !
  ['] _CAPI-CODE COMPILE,
  HERE >R
  0 , \ address of winproc
  0 , \ address of library name
  0 , \ address of function name
  , \ # of parameters
  IS-TEMP-WL 0=
  IF
    HERE WINAPLINK @ , WINAPLINK ! ( ��� )
  THEN
  HERE DUP R@ CELL+ CELL+ !
  NextWord HERE SWAP DUP ALLOT MOVE 0 C, \ ��� �㭪樨
  HERE DUP R> CELL+ !
  NextWord HERE SWAP DUP ALLOT MOVE 0 C, \ ��� ������⥪�
  LoadLibraryA DUP 0= IF -2009 THROW THEN \ ABORT" Library not found"
  GetProcAddress 0= IF -2010 THROW THEN \ ABORT" Procedure not found"
;

CODE CAPI-CALL ( ... n extern-addr -- x )
\ �맮� ���譥� �㭪樨, �ᯮ��஢����� �� c-�ࠢ����
      MOV  EBX, [EBP]
      LEA  EBP, 4 [EBP]
      MOV  EDX, EDI
      MOV  ECX, EBX
      LEA  EBX, [EBX*4]
      SUB  ESP, EBX
      MOV  EDI, ESP
      MOV  ESI, EBP
      CLD
      REP MOVS DWORD
      MOV EDI, EDX
      ADD EBP, EBX
      CALL EAX
      ADD  ESP, EBX
      RET
END-CODE
