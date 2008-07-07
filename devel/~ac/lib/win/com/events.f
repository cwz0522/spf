\ COM-�������.
\ ������ ������������� ~yz/comevents.f, �� ��� ������������� �����������
\ (� ��������� SpamProtexx) ��� ����� �������� ������ ����������� ��������������
\ ����������.
\ � ~day ��� � �� �������� � wfl �������� ����� ������� �����������
\ � �������� �������� (����� ~yz/comevents.f). ��� ��� �������� ����� ������ ;)

\ � ������� �� ���������� ~yz ��� ���������� ������������ �� � ������ �����
\ ������ ����� �����������, � �� ��������� IID. �.�. � ������������ ���������
\ �� ���������, �� ���, ��� ����������, ������ � MS-��������� ��������,
\ ��������� ����������� ����� ��-������.

\ ��� ��������� �������� ��������� ������������ ������ ������ com_server2.f.

REQUIRE Class:        ~ac/lib/win/com/com_server.f 
REQUIRE SPF.IDispatch ~ac/lib/win/com/com_server2.f
REQUIRE {             lib/ext/locals.f

IID_IUnknown
Interface: IID_IConnectionPointContainer {B196B284-BAB4-101A-B69C-00AA00341D07}
  Method: ::EnumConnectionPoints ( *ienum -- ?) 
  Method: ::FindConnectionPoint  ( *ipoint iid -- ?)
Interface;

IID_IUnknown
Interface: IID_IConnectionPoint {B196B286-BAB4-101A-B69C-00AA00341D07}
  Method: ::GetConnectionInterface ( *iid -- ?)
  Method: ::GetConnectionPointContainer ( *iconnpoint -- ?)
  Method: ::Advise ( *unk *cookie -- ?)
  Method: ::Unadvise ( cookie -- ?)
  Method: ::EnumConnections ( *ienumconn -- ?)
Interface;

IID_IUnknown Interface: IID_IEnumVariant {00020404-0000-0000-C000-000000000046}
  Method: ::Next  ( count *var *returned -- hres )
  Method: ::Skip  ( count -- hres)
  Method: ::Reset ( -- hres )
  Method: ::Clone ( *enum )
Interface;

IID_IEnumVariant
Interface: IID_IEnumConnectionPoints {B196B285-BAB4-101A-B69C-00AA00341D07}
( �� �� �����, ��� � IID_IEnumVariant, ������� ��������� ������������)
\  Method: ::Next (  /* [in] */ ULONG cConnections,
\            /* [length_is][size_is][out] */ LPCONNECTIONPOINT *ppCP,
\            /* [out] */ ULONG *pcFetched)
\  Method: ::Skip ( 
\            /* [in] */ ULONG cConnections)
\  Method: ::Reset ( void)
\  Method: ::Clone ( /* [out] */ IEnumConnectionPoints **ppEnum)
Interface;

: EnumVariant { xt ienum \ var n -- n }
  BEGIN
    0 ^ var 1 ienum ::Next 0=
  WHILE
    var xt EXECUTE
    n 1+ -> n
  REPEAT
  n
;
: EnumConnectionPoints { xt iface \ cpointcont cpe cpoint --  }
  ^ cpointcont IID_IConnectionPointContainer iface ::QueryInterface THROW
  COM-DEBUG @ IF ." SP: CPC OK " cpointcont . CR THEN
  ^ cpe cpointcont ::EnumConnectionPoints THROW
  COM-DEBUG @ IF ." SP: CPE OK " cpe . CR THEN
  xt cpe EnumVariant
;
: (ListConnectionPoints) ( cpi -- )
  ." cp=" PAD SWAP ::GetConnectionInterface THROW PAD 16 DUMP CR
  PAD @ HEX U. DECIMAL CR CR
;
: ListConnectionPoints ( iface -- ) \ ����������� IID ���� ���������� �����������
  ['] (ListConnectionPoints) SWAP EnumConnectionPoints
;
: ConnectInterface { idisp iid iface \ cpointcont cpe cpoint cookie -- }
\ ���������� ���������� idisp � �������� � ����������� iid ������� iface
\ idisp - ���������� ���������� IDispatch � ����� ���������
\ ��� ������������� ������� ������ ����� �������� ��� ������
\ ������: SPF.IDispatch IID_IWebBrowserEvents2 bro ConnectInterface

  ^ cpointcont IID_IConnectionPointContainer iface ::QueryInterface THROW
  COM-DEBUG @ IF ." SP: CPC OK " cpointcont . CR THEN
  ^ cpoint iid cpointcont ::FindConnectionPoint THROW
  COM-DEBUG @ IF ." SP: CP OK " cpoint . CR THEN
  ^ cookie idisp cpoint ::Advise THROW
  COM-DEBUG @ IF ." SP: CP.advice OK " cookie . CR THEN
;
