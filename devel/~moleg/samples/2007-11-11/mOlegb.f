 REQUIRE FOR            devel\~mOleg\lib\util\for-next.f
 REQUIRE B@             devel\~mOleg\lib\util\bytes.f

\ �ந����� ॢ��� ��� 㪠������� ����
: revbyte ( b --> b )
          0 8 FOR 2* OVER 1 AND OR
                  SWAP 2/ SWAP
              TILL NIP ;

\ ���ᨢ � ������஢���묨 ���⠬�
CREATE brarr  256 FOR 256 R@ - revbyte B, TILL

\ �ந����� ॢ��� �祩��
: revcell ( u --> u )
          0 4 FOR 8 LSHIFT
                  OVER 0xFF AND brarr + B@ OR
                  SWAP 8 RSHIFT SWAP
              TILL NIP ;

\ ��� ���ᨢ� addr # �ந����� ��⮢� ॢ���
: revarr ( addr # --> ) FOR DUP @ revcell OVER ! CELL + TILL DROP ;
