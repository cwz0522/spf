\ ������������ � ���������� � ���������� ����� ����������

~profit\lib\bac4th-iterators.f 
: a S" abcdef" iterateByBytes DUP @ SWAP CHAR+ SWAP EMIT ; a

CR

: b S" abcdef" 0 iterateBy
\              ^-- �������� ������ �� �������� � �� ������
\                  ������� -- �� ���� ����� ��� ������
DUP @ SWAP CHAR+ SWAP EMIT ; b

\ ����� ��������� ��� ���� ����������� ������� �������� ����
\ ���������: �� ������ ����� ��������������