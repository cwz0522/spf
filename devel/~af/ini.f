\ ����� � ini-䠩���� v1.1
\ Andrey Filatkin, 2001

WINAPI: GetPrivateProfileStringA    kernel32.dll
WINAPI: WritePrivateProfileStringA  kernel32.dll

USER-CREATE BufIni 4096 USER-ALLOT
: N>S ( u -- addr0)
  S>D DUP >R DABS <# #S R> SIGN #> DROP ;

\ ������� ��ப���� ���祭�� ����
: GetIniString ( addr0_ini addr0_sec addr0_key addr0_def -- addr0)
\ ��� addr0_ini - ���-�ନ��஢����� ��ப� - ��� ini 䠩��
\ addr0_sec - ��� ᥪ樨
\ addr0_key - ��� ����
\ addr0_def - ���祭�� �� 㬮�砭��
\ addr0 - �ॡ㥬�� ��ப�
  ASCIIZ> 1+ PAD SWAP MOVE
  >R >R
  4096 BufIni PAD
  2R>
  GetPrivateProfileStringA DROP
  BufIni
;

\ ������� ��ப���� ���祭�� ����
: SetIniString ( addr0_ini addr0_sec addr0_key addr0 -- )
\ ���� - addr0 - �����뢠���� ��ப�
  -ROT SWAP
  WritePrivateProfileStringA DROP
;

\ ������� �᫮��� ���祭�� ����
: GetIniInt ( addr0_ini addr0_sec addr0_key u1 -- u2)
\ u1 - ��䮫⭮� �᫮
  DUP >R
  N>S GetIniString
  ASCIIZ> ['] ?SLITERAL1 CATCH 0= IF
    RDROP
  ELSE
    2DROP R>
  THEN
;

\ ������� �᫮��� ���祭�� ����
: SetIniInt ( addr0_ini addr0_sec addr0_key u1 -- )
  N>S SetIniString
;

\ ������� ᯨ᮪ ���祩 � ᥪ樨
: EnumSectionKeys ( addr0_ini addr0_sec addr u -- flag)
\ ��� addr0_ini - ���-�ନ��஢����� ��ப� - ��� ini 䠩��
\ addr0_sec - ��� ᥪ樨
\ addr - ���� ��� ᯨ᪠
\ u - ��� ࠧ���
\ ��ଠ� ᯨ᪠ ���祩:
\ ����� ���� - 0-��ப�, � ���� ᯨ᪠ ��� ���
  ROT >R
  SWAP
  0 PAD C!  PAD
  0 R>
  GetPrivateProfileStringA 0<>
;

\ ������� ����
: DeleteIniKey ( addr0_ini addr0_sec addr0_key -- )
  0 SetIniString
;

\ ������� ᥪ��
: DeleteIniSection ( addr0_ini addr0_sec -- )
  0 0 SetIniString
;
