\ timestamp � ����

REQUIRE d01011970 ~ac/lib/win/date/unixdate.f

: Num>Date ( n -- s m h d m1 y )
   60 /MOD \ �������
   60 /MOD \ ������
   24 /MOD \ ����
   100 * 36525 /MOD
   >R
   100 / \ ���� �� ������ ����
   ��������� \ ���� �����
   R> 1970 + \ ���
   ;
