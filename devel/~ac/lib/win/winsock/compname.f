WINAPI: GetComputerNameExA KERNEL32.DLL

0 CONSTANT ComputerNameNetBIOS \ ��� ����� ����������
1 CONSTANT ComputerNameDnsHostname \ ��� ����� ���������
2 CONSTANT ComputerNameDnsDomain \ ��� ������ ��������� (���� ��������, ����� �����)
3 CONSTANT ComputerNameDnsFullyQualified \ ��� ����� � ������ ���������
4 CONSTANT ComputerNamePhysicalNetBIOS
5 CONSTANT ComputerNamePhysicalDnsHostname
6 CONSTANT ComputerNamePhysicalDnsDomain
7 CONSTANT ComputerNamePhysicalDnsFullyQualified

: GetCompName ( n -- addr u )
  504 ALLOCATE THROW >R
  500 R@ ! R@ R@ CELL+ ROT GetComputerNameExA
  IF R@ CELL+ R> @ ELSE R> CELL+ 0 THEN
;
: GetDnsDomain ( -- addr u )
  ComputerNameDnsDomain GetCompName
;
: GetDnsHostName ( -- addr u )
  ComputerNameDnsHostname GetCompName
;
: GetDnsFQ ( -- addr u )
  ComputerNameDnsFullyQualified GetCompName
;

\EOF

GetDnsDomain TYPE CR
GetDnsHostName TYPE CR
GetDnsFQ TYPE CR
ComputerNamePhysicalDnsFullyQualified GetCompName TYPE CR