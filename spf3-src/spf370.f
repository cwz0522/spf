WARNING 0! \ ����� �� ���� ��������� isn't unique

S" lib\ext\spf-asm.f"                INCLUDED
S" src\tc_spf370.f"                  INCLUDED

\ ==============================================================
\ ������ ��������� ������ ����-�������
\ � ������ ������� CALL ������������ �������������.
\ �������� �� ������������ �� ����� - ����� �� �����
\ ��������� ����� �������������� ��� fixups.

HERE
HERE TC-CALL,

\ ==============================================================
\ �������� �������������� ����� �����,
\ ����������� �� ������������ �������

S" src\spf_forthproc.f"              INCLUDED
S" src\spf_defkern.f"                INCLUDED
S" src\spf_forthproc_hl.f"           INCLUDED

\ ==============================================================
\ �������� ������ ������� Win32 � ������
\ ������� Windows, ������������ ����� SP-Forth

S" src\win\spf_win_api.f"            INCLUDED
S" src\win\spf_win_proc.f"           INCLUDED
S" src\win\spf_win_const.f"          INCLUDED

\ ==============================================================
\ ���������� �������

S" src\win\spf_win_memory.f"         INCLUDED

\ ==============================================================
\ ����������������� ��������� ���������� (��.����� init)

S" src\spf_except.f"                 INCLUDED
S" src\win\spf_win_except.f"         INCLUDED

\ ==============================================================
\ �������� � ���������� ����-����� (Windows-���������)

S" src\win\spf_win_io.f"             INCLUDED
S" src\win\spf_win_conv.f"           INCLUDED
S" src\win\spf_win_con_io.f"         INCLUDED
S" src\spf_con_io.f"                 INCLUDED

\ ==============================================================
\ ������ �����
\ ��� ������.

S" src\spf_print.f"                  INCLUDED
S" src\win\spf_win_module.f"         INCLUDED

\ ==============================================================
\ ������ ��������� ������ ����-��������
S" src\compiler\spf_parser.f"        INCLUDED
S" src\compiler\spf_read_source.f"   INCLUDED

\ ==============================================================
\ ���������� ����� � ����� � �������.
\ �������� ��������� ������.
\ ����� ���� � ��������.
\ ������ ��������.

S" src\compiler\spf_compile.f"       INCLUDED
S" src\compiler\spf_wordlist.f"      INCLUDED
S" src\compiler\spf_find.f"          INCLUDED
S" src\compiler\spf_words.f"         INCLUDED

\ ==============================================================
\ ���������� �������� �������.
\ ��������� ������.
\ ������������ �����.
\ �������� ��������.
\ ���������� �����������.
\ ���������� ����������� ��������.

S" src\compiler\spf_error.f"         INCLUDED
S" src\compiler\spf_translate.f"     INCLUDED
S" src\compiler\spf_defwords.f"      INCLUDED
S" src\compiler\spf_immed_transl.f"  INCLUDED
S" src\compiler\spf_immed_lit.f"     INCLUDED
S" src\compiler\spf_literal.f"       INCLUDED
S" src\compiler\spf_immed_control.f" INCLUDED
S" src\compiler\spf_immed_loop.f"    INCLUDED

\ ==============================================================
\ ��������� (environment).
\ ������������ ����� ��� Windows.
\ ���������������.
\ CGI

S" src\win\spf_win_envir.f"          INCLUDED
S" src\win\spf_win_defwords.f"       INCLUDED
S" src\win\spf_win_mtask.f"          INCLUDED
S" src\win\spf_win_cgi.f"            INCLUDED

\ ==============================================================
\ ���������� ������� � exe-�����.

S" src\win\spf_pe_save.f"            INCLUDED

\ ==============================================================
\ ������������� ����������, startup

S" src\spf_init.f"                   INCLUDED

\ ==============================================================

: DONE
  S" src\done.f" INCLUDED
;

TC-LATEST-> FORTH-WORDLIST
HERE ' (DP) ( ������� DP) EXECUTE !
TC-WINAPLINK @ ' WINAPLINK EXECUTE !

CR .( =============================================================)
CR .( Done. Saving the system.)
CR .( =============================================================)
CR
\ DUP  HERE OVER - S" spf.bin" R/W CREATE-FILE THROW WRITE-FILE THROW

\ ���������� "DONE" � ��������� ������
S"  DONE " GetCommandLineA ASCIIZ> S"  " SEARCH 2DROP SWAP 1+ MOVE

\ �� ����� - token ����� INIT ������� �������, ��������� � ���
\ ���� ����� ��� ���� ���� ��������� � spf37x.exe ����������� ����� DONE,
\ ����������� �� � ��������� ������
EXECUTE
