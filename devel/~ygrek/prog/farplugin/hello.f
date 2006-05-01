REQUIRE (dllinit) farplugindll.f

REQUIRE TPluginStartupInfo  plugin.f
REQUIRE VAR  ~ygrek/lib/var.f
REQUIRE ENUM ~ygrek/lib/enum.f 

\ REQUIRE ACCERT( lib/ext/debug/accert.f

1234 CONSTANT SOMETHING

\ 0 ACCERT-LEVEL ! \ 1 for debugging output

DEFSTRUCT TPluginStartupInfo FARAPI
FARAPI. /SIZE@  FARAPI. StructSize !

( 
 �㭪�� GetMsg �����頥� ��ப� ᮮ�饭�� �� �몮���� 䠩��.
 � �� �����ன�� ��� Info.GetMsg ��� ᮪�饭�� ���� :-)

: GetMsg ( MsgId -- pchar ) FARAPI. ModuleNumber @ FARAPI. GetMsg @ API-CALL ;

:NONAME DUP 1+ SWAP CREATE , DOES> @ GetMsg ; ENUM MESSAGES:

0 
 MESSAGES: MTitle MMessage1 MMessage2 MMessage3 MMessage4 MButton ;
DROP

: .H ( x -- ) BASE @ SWAP HEX ." 0x0" . BASE ! ;

( 
�㭪�� SetStartupInfo ��뢠���� ���� ࠧ, ��। �ᥬ�
��㣨�� �㭪�ﬨ. ��� ��।����� ������� ���ଠ��,
����室���� ��� ���쭥�襩 ࠡ���.
)

:NONAME ( psi -- void )
\  ACCERT( CR S" SetStartupInfo " )
  FARAPI. /SIZE CMOVE
  SOMETHING
; 1 CELLS CALLBACK: SetStartupInfo

( 
�㭪�� GetPluginInfo ��뢠���� ��� ����祭�� �᭮����
  [general] ���ଠ樨 � �������
)

VARIABLE MyPluginMenuStrings \ array[0..0] of PChar;
VARIABLE MyPluginConfigStrings

:NONAME { pi \ -- void }  
   TEMP VAR TPluginInfo pi ;TEMP
\  ACCERT( CR ." GetPluginInfo" )

   pi. /SIZE NIP  pi. StructSize !

   PF_DISABLEPANELS PF_VIEWER OR pi. Flags !

   MTitle MyPluginMenuStrings !
   MyPluginMenuStrings pi. PluginMenuStrings !

   1 pi. PluginMenuStringsNumber !

   MTitle MyPluginConfigStrings !
   MyPluginConfigStrings pi. PluginConfigStrings !

   1 pi. PluginConfigStringsNumber !

  SOMETHING \ �����頥� ��-�����
; 1 CELLS CALLBACK: GetPluginInfo


CREATE Dlg 10 CELLS ALLOT

: (Dialog) OVER ! CELL+ ;
:NONAME ' COMPILE, POSTPONE (Dialog) ; ENUM Dialog:

( 
  �㭪�� OpenPlugin ��뢠���� �� ᮧ����� ����� ����� �������.
)
:NONAME ( Item OpenFrom -- Handle )
\  S" OpenPlugin" ShowMessage
  (
   2DUP
   ." OpenPlugin : "
   ." from = " .H ." item = " .H CR )

   2DROP 

   Dlg
    Dialog: MTitle MMessage1 MMessage2 MMessage3 MMessage4 MButton ;
   DROP

   1 \ ButtonsNumber
   6 \ ItemsNumber
   Dlg \ Items
   0 \ HelpTopic
   FMSG_WARNING FMSG_ERRORTYPE OR FMSG_LEFTALIGN OR \ Flags
   FARAPI. ModuleNumber @ \ PluginNumber
   FARAPI. Message @ API-CALL
   DROP

  INVALID_HANDLE_VALUE 
; 2 CELLS CALLBACK: OpenPlugin

(
  ��뢠���� �� �맮�� �� ���� ����஥� ��������
) 
:NONAME ( number -- flag )
  DROP

  TRUE
; 1 CELLS CALLBACK: Configure

