; SPF.nsi

;--------------------------------
; Include Modern UI
!include "MUI.nsh"

;--------------------------------
; Define SPF-PATH SPF-VER-MAJOR and SPF-VER-MINOR 

;--------------------------------
; Configuration

!define VER_MAJOR "{SPF-VER-MAJOR}"
!define VER_MINOR "{SPF-VER-MINOR}"

!define VER_DATE "{MY_DATE}"
!define PROD_NAME "SP-Forth"
!define PROD_FILE "spf-"
!define PROD_VENDOR "RUFIG"
!define PROD_ICON "{SPF-PATH}\src\spf.ico"

;--------------------------------
; General
SetCompressor /SOLID lzma
!packhdr header.dat "upx --best header.dat"
CRCCheck on
Name "${PROD_NAME}"
Caption "$(LSetup) ${PROD_NAME} ${VER_MAJOR}.${VER_MINOR} [${VER_DATE}]"
OutFile "${PROD_FILE}${VER_MAJOR}${VER_MINOR}-setup.exe"

;Folder selection page
InstallDir "$PROGRAMFILES\${PROD_NAME}"
;Get install folder from registry if available
InstallDirRegKey HKLM "SOFTWARE\${PROD_VENDOR}\${PROD_NAME}" "InstallLocation"

;--------------------------------
; Interface Settings

!define MUI_ABORTWARNING
!define MUI_ICON "${PROD_ICON}"
; ������ BrandingText ����� NSIS'������
; BrandingText /TRIMRIGHT  "$(LBrandingSitePlaceHolderPl)"
; NSIS ��������� ����� ������ BrandingText �� ��������� ��������,
; ������� ��������� ����� ������� ��� ����� ����������.

;--------------------------------
; Pages

!define MUI_WELCOMEPAGE_TITLE "$(LWelcomeHeaderText)"
!define MUI_WELCOMEPAGE_TEXT "$(LWelcomeMainText)"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "$(LLicenseData)"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_LINK "$(LSupportText)"
!define MUI_FINISHPAGE_LINK_LOCATION "$(LSupportLink)"

;!define MUI_FINISHPAGE_RUN
;!define MUI_FINISHPAGE_RUN_FUNCTION onFinishRun
;!define MUI_FINISHPAGE_RUN_TEXT "$(LRunManagerText)"

!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\$(LReadmeFile)"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(LViewReadmeText)"

!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!define MUI_FINISHPAGE_NOAUTOCLOSE

!insertmacro MUI_PAGE_FINISH

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Russian"

LangString LSetup ${LANG_ENGLISH} "Installing"
LangString LSetup ${LANG_RUSSIAN} "���������"

LangString LSupportText ${LANG_ENGLISH} "Support site: www.forth.org.ru"
LangString LSupportText ${LANG_RUSSIAN} "��������� �� ����� www.forth.org.ru"

LangString LSupportLink ${LANG_ENGLISH} "http://www.forth.org.ru/"
LangString LSupportLink ${LANG_RUSSIAN} "http://www.forth.org.ru/"

LangString LBrandingSitePlaceHolderPl ${LANG_ENGLISH} "http://www.forth.org.ru/"
LangString LBrandingSitePlaceHolderPl ${LANG_RUSSIAN} "http://www.forth.org.ru/"

LangString LEservInstalled ${LANG_ENGLISH} "${PROD_NAME} installed successfully."
LangString LEservInstalled ${LANG_RUSSIAN} "${PROD_NAME} ������� ����������."

LangString LClickNext ${LANG_ENGLISH} "Click 'Next' to continue"
LangString LClickNext ${LANG_RUSSIAN} "������� '�����' ��� �����������"

LangString LNoInstall ${LANG_ENGLISH} "don't install"
LangString LNoInstall ${LANG_RUSSIAN} "�� �������������"

LangString LServiceHeader3 ${LANG_ENGLISH} "Install finishing"
LangString LServiceHeader3 ${LANG_RUSSIAN} "���������� ���������"

LangString LReadmeYN ${LANG_ENGLISH} "Do you want to read README?"
LangString LReadmeYN ${LANG_RUSSIAN} "������ ������ README?"

LicenseLangString LLicenseData ${LANG_ENGLISH} "{SPF-PATH}\docs\license\gpl.en.txt"
LicenseLangString LLicenseData ${LANG_RUSSIAN} "{SPF-PATH}\docs\license\gpl.ru.txt"

LangString LLicenseFile ${LANG_ENGLISH} "docs\license\gpl.en.txt"
LangString LLicenseFile ${LANG_RUSSIAN} "docs\license\gpl.ru.txt"

LangString LReadmeFile ${LANG_ENGLISH} "docs\readme.en.html"
LangString LReadmeFile ${LANG_RUSSIAN} "docs\readme.ru.html" 

LangString LWhatsnewFile ${LANG_ENGLISH} "docs\whatsnew.en.txt"
LangString LWhatsnewFile ${LANG_RUSSIAN} "docs\whatsnew.ru.txt" 

LangString LIntroFile ${LANG_ENGLISH} "docs\intro.en.html"
LangString LIntroFile ${LANG_RUSSIAN} "docs\intro.ru.html" 

LangString LDevelFile ${LANG_ENGLISH} "docs\devel.en.html"
LangString LDevelFile ${LANG_RUSSIAN} "docs\devel.ru.html" 

LangString LLinkLicense ${LANG_ENGLISH} "License"
LangString LLinkLicense ${LANG_RUSSIAN} "��������"

LangString LDocsAll ${LANG_ENGLISH} "Documentation"
LangString LDocsAll ${LANG_RUSSIAN} "Documentation"

LangString LViewReadmeText ${LANG_ENGLISH} "View README"
LangString LViewReadmeText ${LANG_RUSSIAN} "���������� README" 

;-------------
; Sections

LangString LSecUnRegValText ${LANG_ENGLISH} "Add/Remove"
LangString LSecUnRegValText ${LANG_RUSSIAN} "Add/Remove"

LangString LSecUnRegValDesc ${LANG_ENGLISH} "Register ${PROD_NAME} in system registry so you can manage it through Add/Remove Programs"
LangString LSecUnRegValDesc ${LANG_RUSSIAN} "���������������� ${PROD_NAME} � ��������� �������, ��� ��� �� ������� ����� �������� ��������� � ������� Add/Remove Programs"

LangString LSecAssociateText ${LANG_ENGLISH} "File extensions"
LangString LSecAssociateText ${LANG_RUSSIAN} "���������� ������"

LangString LSecAssociateDesc ${LANG_ENGLISH} "Associate *.spf, *.f file extensions with ${PROD_NAME}"
LangString LSecAssociateDesc ${LANG_RUSSIAN} "���������������� ���������� ������ *.spf � *.f �� ${PROD_NAME}"

LangString LSecShortcutsText ${LANG_ENGLISH} "Shortcuts"
LangString LSecShortcutsText ${LANG_RUSSIAN} "������"

LangString LSecShortcutsDesc ${LANG_ENGLISH} "Add shortcuts"
LangString LSecShortcutsDesc ${LANG_RUSSIAN} "�������� ������"

LangString LSecStartMenuText ${LANG_ENGLISH} "Start Menu"
LangString LSecStartMenuText ${LANG_RUSSIAN} "������� ����"

LangString LSecStartMenuDesc ${LANG_ENGLISH} "Add shortcuts to the Start Menu"
LangString LSecStartMenuDesc ${LANG_RUSSIAN} "�������� ������ � ������� ����"

LangString LSecDesktopText ${LANG_ENGLISH} "Desktop"
LangString LSecDesktopText ${LANG_RUSSIAN} "������� ����"

LangString LSecDesktopDesc ${LANG_ENGLISH} "Add shortcut to the Desktop"
LangString LSecDesktopDesc ${LANG_RUSSIAN} "�������� ����� �� ������� ����"

;-------------

LangString LSecSPFText ${LANG_ENGLISH} "${PROD_NAME}"
LangString LSecSPFText ${LANG_RUSSIAN} "${PROD_NAME}"

LangString LSecSPFDesc ${LANG_ENGLISH} "${PROD_NAME} executable, libraries, devel, documentation etc"
LangString LSecSPFDesc ${LANG_RUSSIAN} "${PROD_NAME}, ����������, ������������, devel ���"

LangString LAlreadyInstalledText ${LANG_ENGLISH} "It looks like ${PROD_NAME} is already present in '$INSTDIR'.$\r$\nOverwrite?$\r$\n(If you answer YES all the files will be overwritten.)"
LangString LAlreadyInstalledText ${LANG_RUSSIAN} "������, ��� ${PROD_NAME} ��� ���������� � '$INSTDIR'.$\r$\n������������ ������?$\r$\n(���� �� �������� ��, ��� ����� ����� ������������.)"

LangString LUninstall ${LANG_ENGLISH} "To uninstall ${PROD_NAME}, stop its services and click 'Remove' button."
LangString LUninstall ${LANG_RUSSIAN} "���� �� ������ ������� ${PROD_NAME}, ���������� ��� ������� � ������� '�������' ��� �����������."

LangString LWelcomeHeaderText ${LANG_ENGLISH} "Welcome to the ${PROD_NAME} Setup Wizard"
LangString LWelcomeHeaderText ${LANG_RUSSIAN} "��� ������������ ������ ��������� ${PROD_NAME}"

LangString LWelcomeMainText ${LANG_ENGLISH} "This wizard will install ${PROD_NAME} ${VER_MAJOR}.${VER_MINOR}.\r\n\r\nIf you have previously installed ${PROD_NAME} and it is currently running, please exit ${PROD_NAME} first before continuing this installation.\r\n\r\n$_CLICK"
LangString LWelcomeMainText ${LANG_RUSSIAN} "��� ��������� ��������� ${PROD_NAME} ${VER_MAJOR}.${VER_MINOR} �� ��� ���������.\r\n\r\n���� �� ����� ������������� ${PROD_NAME} � �� ������ �������, ���������� ��������� ${PROD_NAME} �� ������ ���������.\r\n\r\n$_CLICK"

LangString LAssocPresentWarn ${LANG_ENGLISH} "Extension '$R0' is already associated as '$R1'.$\r$\nDo you want to overwrite this association?"
LangString LAssocPresentWarn ${LANG_RUSSIAN} "���������� '$R0' ��� ����������������, ��� '$R1'.$\r$\n�� ������� ��� ������ ������������?"

;--------------------------------
; Installer Functions

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;Function onFinishRun
; nsExec::Exec '$INSTDIR\spf4.exe devel/~ygrek/prog/install/launcher.f'
;FunctionEnd

Function Associate
	; $R0 should contain the prefix to associate
	Push $R1
	ReadRegStr $R1 HKCR $R0 ""
	StrCmp $R1 "" Associate.doRegister
	StrCmp $R1 "spf" Associate.end
        MessageBox MB_YESNO "$(LAssocPresentWarn)" IDYES Associate.doRegister
        Goto Associate.end
Associate.doRegister:
	WriteRegStr HKCR $R0 "" "spf"
	WriteRegStr HKCR $R0 "Content Type" "text/plain"
Associate.end:
	pop $R1
FunctionEnd

Function un.unlink
	; $R0 should contain the prefix to unlink
	Push $R1
	ReadRegStr $R1 HKCR $R0 ""
	StrCmp $R1 "spf" un.unlink.doUnlink
	Goto un.unlink.end
un.unlink.doUnlink:
	; The extension is associated with SPF, so we must destroy it!
	DeleteRegKey HKCR $R0
un.unlink.end:	
	pop $R1
FunctionEnd

;--------------------------------
; Installer sections

;--------------------------------
; The stuff to install
Section "$(LSecSPFText)" SecSPF

  SectionIn RO ; obligatory

  IfFileExists $INSTDIR\spf4.exe 0 spf_clean_install
    MessageBox MB_YESNO "$(LAlreadyInstalledText)" IDYES spf_clean_install
    Abort

  spf_clean_install:

  SetOutPath $INSTDIR
  WriteUninstaller uninstall.exe

  {S" spf_cvs.nsi" FILE}

;     NSISdl::download http://www.forth.org.ru/bin.rar bin.rar
;       Pop $R0 ;Get the return value
;;       StrCmp $R0 "success" +3
;       MessageBox MB_OK "Download result: $R0"
;;       Quit

SectionEnd ; end the section

;--------------------------------
; File extensions associations
Section "$(LSecAssociateText)" SecAssociate

WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\spf.exe" "" '$INSTDIR\spf4.exe'
WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\spf.exe" "Path" '$INSTDIR'

WriteRegStr HKCR "spf" "" "SP-Forth file"
WriteRegStr HKCR "spf\Shell\open\command" "" '"$INSTDIR\spf4.exe" "%1"'
WriteRegStr HKCR "spf\DefaultIcon" "" '"$INSTDIR\spf4.exe",0'

push $R0
	StrCpy $R0 ".spf" 
	Call Associate
	
	StrCpy $R0 ".f"
	Call Associate
pop $R0

SectionEnd

SectionGroup /e "$(LSecShortcutsText)" SecShortcuts

;--------------------------------
; Start menu shortcuts
Section "$(LSecStartMenuText)" SecStartMenu

  SetOutPath $INSTDIR

  CreateDirectory "$SMPROGRAMS\${PROD_NAME}"

     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\SPF.lnk" "$INSTDIR\spf4.exe"

  ; hide uninstall in extra folder %)
  CreateDirectory "$SMPROGRAMS\${PROD_NAME}\Uninstall"

     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\Uninstall\Uninstall.lnk" "$INSTDIR\uninstall.exe"

  CreateDirectory "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)"

     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)\ReadMe.lnk" "$INSTDIR\$(LReadmeFile)"
     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)\License.lnk" "$INSTDIR\$(LLicenseFile)"
     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)\ChangeLog.lnk" "$INSTDIR\$(LWhatsnewFile)"
     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)\intro.lnk" "$INSTDIR\$(LIntroFile)"
     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)\devel.lnk" "$INSTDIR\$(LDevelFile)"
     CreateShortCut "$SMPROGRAMS\${PROD_NAME}\$(LDocsAll)\spf_help.lnk" "$INSTDIR\docs\papers\spf_help.chm"

;  ExecShell "open" "$SMPROGRAMS\${PROD_NAME}"

SectionEnd

;--------------------------------
; Desktop shortcut
Section "$(LSecDesktopText)" SecDesktop

   SetOutPath $INSTDIR
   CreateShortCut "$DESKTOP\${PROD_NAME}.lnk" "$INSTDIR\spf4.exe"

SectionEnd

SectionGroupEnd

;--------------------------------
; Uninstaller registry values
Section "$(LSecUnRegValText)" SecUnRegVal

  WriteRegStr HKLM "SOFTWARE\${PROD_VENDOR}\${PROD_NAME}" InstallLocation $INSTDIR
  WriteRegStr HKLM "SOFTWARE\${PROD_VENDOR}\${PROD_NAME}" VersionMajor ${VER_MAJOR}
  WriteRegStr HKLM "SOFTWARE\${PROD_VENDOR}\${PROD_NAME}" VersionMinor ${VER_MINOR}

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "UninstallString" '$INSTDIR\uninstall.exe'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "InstallLocation" '$INSTDIR'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "DisplayName" '${PROD_NAME}'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "DisplayIcon" '$INSTDIR\spf4.exe,0'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "DisplayVersion" '${VER_MAJOR}.${VER_MINOR}'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "VersionMajor" '${VER_MAJOR}'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "VersionMinor" '${VER_MINOR}'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "Publisher" '${PROD_VENDOR}'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "URLInfoAbout" 'http://www.forth.org.ru/'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "URLUpdateInfo" 'http://spf.sourceforge.net'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}" "NoRepair" 1

SectionEnd

;--------------------------------
; Sections' descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSPF}       "$(LSecSPFDesc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAssociate} "$(LSecAssociateDesc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcuts} "$(LSecShortcutsDesc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "$(LSecStartMenuDesc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop}   "$(LSecDesktopDesc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecUnRegVal}  "$(LSecUnRegValDesc)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller

UninstallText "$(LUninstall)"
UninstallIcon "${MUI_ICON}"

Section "Uninstall"

  SetDetailsPrint textonly
  DetailPrint "������� ${PROD_NAME}..."
  SetDetailsPrint listonly

  IfFileExists $INSTDIR\spf4.exe spf_installed
    MessageBox MB_YESNO "������, ��� ${PROD_NAME} �� ���������� � '$INSTDIR'.$\r$\n����������� ��� �����? (�� �������������)" IDYES spf_installed
    Abort "Uninstall �������"
  spf_installed:

  SetDetailsPrint textonly
  DetailPrint "������� ����� $INSTDIR\*..."
  SetDetailsPrint listonly

  RMDir /r "$SMPROGRAMS\${PROD_NAME}"
  RMDir /r $INSTDIR

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROD_NAME}"

  DeleteRegKey HKLM "SOFTWARE\${PROD_VENDOR}\${PROD_NAME}"

  push $R0
	StrCpy $R0 ".spf" 
	Call un.unlink
	
	StrCpy $R0 ".f"
	Call un.unlink
  pop $R0

  SetDetailsPrint both

SectionEnd
