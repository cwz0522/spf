
 REQUIRE FOR   devel\~mOleg\lib\util\for-next.f

\ �ந����� ॢ��� ��� 㪠������� �᫠
: revcell ( u - u ) 0  32 0 DO  SWAP 0 D2*  I LSHIFT ROT +  LOOP  NIP ;

\ ��� ���ᨢ� addr # �ந����� ��⮢� ॢ���
: revarr ( addr # --> )
         FOR DUP @ revcell OVER !
             CELL +
         TILL DROP ;

