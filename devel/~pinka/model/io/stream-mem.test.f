REQUIRE EMBODY    ~pinka/spf/forthml/index.f

`../data/list-plain.f.xml EMBODY

`stream-mem.L1.f.xml EMBODY

( ������� ������� ����� ������ � ����������� �������������� ������.
  ��� ���������� ���������� ����� ������ ��������� ����� ����,
  ����� ����������� � ������. ������ ������� ���������� �����
  ������������ ��� ����� ������ ��� ���������� ������ ����� ������.
  ��� ������ ��������� ���������� ����� �������������.
  ����� ������ ������ ������ -- ����� ������������ 0.
)


 \ stream-mem-hidden ALSO!

 S" abc" write
 HERE 100 readout TYPE CR

 HERE 10000 write
 HERE 10000 write
 HERE 50000 readout SWAP . . CR
 HERE 50000 readout SWAP . . CR
 HERE 50000 readout SWAP . . CR
 HERE 50000 readout SWAP . . CR
 CR
 HERE 10000 write
 HERE 10000 write
 next-chunk SWAP . . CR
 next-chunk SWAP . . CR
 next-chunk SWAP . . CR

