 \ �ந����� ॢ��� ��� 㪠������� �᫠

 REQUIRE FOR   devel\~mOleg\lib\util\for-next.f
 REQUIRE ROL   shift.f

\ �ந����� ॢ��� ��� 㪠������� �᫠
: revcell ( u --> u )
          BSWAP
          DUP 0xF0F0F0F0 AND 4 RSHIFT SWAP 0x0F0F0F0F AND 4 LSHIFT OR
          DUP 0xCCCCCCCC AND 2 RSHIFT SWAP 0x33333333 AND 2 LSHIFT OR
          DUP 0xAAAAAAAA AND 1 RSHIFT SWAP 0x55555555 AND 1 LSHIFT OR
          ;

\ ��� ���ᨢ� addr # �ந����� ��⮢� ॢ���
: revarr ( addr # --> )
         FOR DUP @ revcell OVER !
             CELL +
         TILL DROP ;
