\ ������ ������������ ��� Eserv'�...
\ � ���� � x86 ������� "���������" ��������, ��� � ARM? :)

: >ENDIAN<  ( x1 -- x2 )
  >R
  R@       0xFF AND 24 LSHIFT
  R@     0xFF00 AND  8 LSHIFT OR
  R@   0xFF0000 AND  8 RSHIFT OR
  R> 0xFF000000 AND 24 RSHIFT OR
;
