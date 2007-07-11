REQUIRE CLSID, ~ac/lib/win/com/com.f

0x80020006 CONSTANT DISP_E_UNKNOWNNAME
0x8002000E CONSTANT DISP_E_BADPARAMCOUNT
0x80020009 CONSTANT DISP_E_EXCEPTION
         4 CONSTANT DISPATCH_PROPERTYPUT

: Class. ( oid -- oid )
  CR DUP WordByAddr TYPE R@ WordByAddr TYPE SPACE
;

: Class: ( implement_interface "name" "clsid" -- current class_int )
  CREATE 
    HERE SWAP
    BL WORD COUNT CLSID, 
    DUP ,               \ ������
    Methods#            \ �-�� ������� ������
    DUP ,               \ ���� ������ (�-��)
    LATEST ,            \ ��� ���
    HERE CELL+ ,        \ oid ������ (��������� �� Vtable)
    1+ CELLS HERE SWAP DUP ALLOT ERASE     \ VTABLE
    -1 ,
    GET-CURRENT WORDLIST SET-CURRENT SWAP
  DOES> 7 CELLS + ( oid )
;

: Class; DROP SET-CURRENT ;

: Class ( oid -- class_int ) 7 CELLS - ;

: Extends ( class_int -- class_int )
  DUP
  ' EXECUTE             \ oid ������, �� �������� �������� VTABLE
  DUP 2 CELLS - @ CELLS \ ������� ����������
  ( class_int class_int oid n )
  SWAP @                \ ������ ����������
  ROT 8 CELLS +         \ ����
  ROT MOVE
;

: ToVtable ( class_int xt -- class_int )
  OVER >R
  LAST @ FIND
  IF >BODY @ ( ����� ������ � VTABLE )
     8 + \ �������� VTABLE � ����������� ������
     CELLS R> + !
  ELSE -321 THROW THEN
;
: METHOD ( class_int -- class_int )
  LAST @ NAME> TASK ToVtable
;
