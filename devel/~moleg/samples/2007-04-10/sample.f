\ 10-04-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �ਬ�� �祭� ���⮩ ��ࠡ�⪨ 䠩��.

VOCABULARY process
           ALSO process DEFINITIONS

      \ � �� �� NOTFOUND, �� � ������ �ਬ�� �� ����.
      : NOTFOUND ( asc # --> ) 2DROP
                 0 >IN !
                 0x0D PARSE
                 TYPE CR ;

PREVIOUS DEFINITIONS

\ ��-㬮�砭�� ��࠭塞 � STDLOG
: sample ( srcZ # --> )
         ONLY process
         GetCommandLineA ASCIIZ> SOURCE! NextWord 2DROP
         NextWord INCLUDED
         KEY DROP BYE ;

' sample MAINX !

S" sample.exe" SAVE CR S" passed " CR BYE

\ �ਬ�� �ᯮ�짮�����:
\ sample file.name >result.file

\ �����塞 ���������� ��᫥����⥫쭮��� ��ப� 0x0D 0x0D 0x0A
\ �� �ਭ���� � ������ �� ( ��� win ������� 0x0D 0x0A ��� linux - 0x0A )
\ ����� ��ப� 㤠������.
