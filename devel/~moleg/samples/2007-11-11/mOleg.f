\ 11-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �ਬ�� �襭�� ����窨 � ��㬠
\ http://fforum.winglion.ru/viewtopic.php?t=1022&start=0&postdays=0&postorder=asc&highlight=

 REQUIRE FOR  devel\~mOleg\lib\util\for-next.f

\ �ந����� ॢ��� ��� 㪠������� �᫠
: revcell ( u --> u )
          0 32 FOR 2* OVER 1 AND OR
                   SWAP 2/ SWAP
               TILL NIP ;

\ ��� ���ᨢ� addr # �ந����� ��⮢� ॢ���
: revarr ( addr # --> )
         FOR DUP @ revcell OVER !
             CELL +
         TILL DROP ;

