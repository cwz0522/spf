REQUIRE EMBODY    ~pinka/spf/forthml/index.f

`envir.f.xml            FIND-FULLNAME2 EMBODY  xml-struct-hidden::start
`import-words.f.xml     FIND-FULLNAME2 EMBODY
`tc-host.f.xml          FIND-FULLNAME2 EMBODY


WARNING @ WARNING 0!
: EXECUTE  EXECUTE ;
: ?DUP     ?DUP    ;
: >R       R> 2>R  ;
: R>       2R> >R  ;
: RDROP    R> RDROP >R ;
: 2R>      R> 2R> ROT >R ;

\ ������ ����� ��������������, �.�. ��� ����� ����������� �����������,
\ � ��� ����������� ����������� ��� ��������� � ������� ���������,
\ � ��� ���� ���������� � �������, ����� ����� �� ������� �� ���������.
WARNING !


\ TC-WL NLIST
\ TC-WL ALSO!

\ 50 TO TRACE-HEAD-SIZE

`index.f.xml FIND-FULLNAME2 EMBODY

  TC-WL ALSO!
  .( >>>>> Welcome to the target system ) CR ORDER quit
