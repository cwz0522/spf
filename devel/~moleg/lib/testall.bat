@rem 31-05-2007 ~mOleg
@rem Copyright [C] 2007 mOleg mininoleg@yahoo.com
@rem ���஢���� ������⥪

@rem ������ ���஢���� ��室���� � ᠬ�� ����㥬�� ������⥪�
@rem ��� ������ �஢������ ᮡ�ࠥ����� ������⥪� ��� ⥪�饩
@rem ᡮમ� ���.

@rem ᮡ�ࠥ� ⥪���� ����� ���, �᫨ �� �� ᮡ࠭�
@IF NOT EXIST ..\..\..\spf4.exe @CALL makespf.bat
@IF EXIST ..\..\..\spf4.exe CD ..\..\..\

@rem ����� ⥪�饣� ��ਠ�� ���
@FOR %%f IN ( .\spf4*.exe ) DO set spf=%%f

@rem ����㥬 � ������� ᫥���饩 �������窨:
@%spf% devel\~moleg\lib\testing\smal-test.f

@st.exe .S" devel\~moleg\lib\util\ifdef.f"              TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\addr.f"               TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\bytes.f"              TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\compile.f"            TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\ifnot.f"              TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\doloop.f"             TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\double.f"             TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\iw.f"                 TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\shades.f"             TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\ansi-esc.f"           TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\useful.f"             TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\on-error.f"           TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\ifcolon.f"            TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\run.f"                TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\control.f"            TESTED CR BYE
@st.exe .S" devel\~moleg\lib\util\for-next.f"           TESTED CR BYE

@st.exe .S" devel\~moleg\lib\arrays\arrays.f"           TESTED CR BYE
@st.exe .S" devel\~moleg\lib\arrays\buff.f"             TESTED CR BYE

@st.exe .S" devel\~moleg\lib\parsing\number.f"          TESTED CR BYE
@st.exe .S" devel\~moleg\lib\parsing\xWord.f"           TESTED CR BYE

@st.exe .S" devel\~moleg\lib\postscript\dsadd.f"        TESTED CR BYE
@st.exe .S" devel\~moleg\lib\postscript\ps{}.f"         TESTED CR BYE

@st.exe .S" devel\~moleg\lib\strings\messages.f"        TESTED CR BYE
@st.exe .S" devel\~moleg\lib\strings\sconst.f"          TESTED CR BYE
@st.exe .S" devel\~moleg\lib\strings\string.f"          TESTED CR BYE
@st.exe .S" devel\~moleg\lib\strings\subst.f"           TESTED CR BYE

@st.exe .S" devel\~moleg\lib\struct\struct.f"           TESTED CR BYE

@st.exe .S" devel\~moleg\lib\drafts\vars.f"             TESTED CR BYE
@st.exe .S" devel\~moleg\lib\drafts\mem.f"              TESTED CR BYE

@st.exe .S" devel\~moleg\lib\newfind\clear.f"           TESTED CR BYE
@st.exe .S" devel\~moleg\lib\newfind\new_find.f"        TESTED CR BYE
@st.exe .S" devel\~moleg\lib\newfind\spf_find.f"        TESTED CR BYE

@st.exe .S" devel\~moleg\lib\testing\testing.f"         TESTED CR BYE
@st.exe .S" devel\~moleg\lib\testing\say.f"             TESTED CR BYE

@rem @st.exe .S" devel\~moleg\lib\\" TESTED CR BYE




@del st.exe







