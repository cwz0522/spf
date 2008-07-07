REQUIRE EnumConnectionPoints ~ac/lib/win/com/events.f

\ COM-������� ������� ����� �������� � �������� ����� IID_IWebBrowserEvents2
\ ����, ���� �� ������� ���������� � ��������� ���� IID, �� ��� �������
\ �������������� ������� IID_IDispatch.

IID_IDispatch
Interface: IID_IWebBrowserEvents2 {34A715A0-6587-11D0-924A-0020AFC7AC4D}
\ ������ ����� ���������� �� ����������, �.�. �� "��������" -
\ ��� ����������� ������� ID ���� ������� ���������� ������ IDispatch::Invoke
Interface;

IID_IWebBrowserEvents2
Class: SPF.IWebBrowserEvents2 {C6DFBA32-DF7B-4829-AA3B-EE4F90ED5961} \ ���� clsid �����
Extends SPF.IDispatch
\ ORDER
Class;

: {34A715A0-6587-11D0-924A-0020AFC7AC4D} ( ppvObject iid oid -- hresult )
\ ������������ ����������. ��. ::QueryInterface
  COM-DEBUG @ IF ." SPF.IWebBrowserEvents2 - OK!" THEN
  2DROP SPF.IWebBrowserEvents2 SWAP ! 0
;

\ � ��� ���������� ����������� � �������� (connection points) ������������ IE7

\ uuid(34A715A0-6587-11D0-924A-0020AFC7AC4D), // IID_DWebBrowserEvents2
\ helpstring("Web Browser Control events interface"),

\ uuid(EAB22AC2-30C1-11CF-A7EB-0000C05BAE0B), // DIID_DWebBrowserEvents
\ helpstring("Web Browser Control Events (old)"),

\ uuid(9BFBBC02-EFF1-101A-84ED-00AA00341D07),
\ interface IPropertyNotifySink : IUnknown
