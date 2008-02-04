\ 01.2008
\ ���������� ���������� ����������,
\ ����������� � ���������� �� ����� ������ ������ MODULE: ... EXPORT ... ;MODULE

REQUIRE Require   ~pinka/lib/ext/requ.f

Require >CS control-stack.f \ ����������� ����



: PUSH-SCOPE ( wid -- )
  ALSO CONTEXT !
;
: POP-SCOPE ( -- wid )
  CONTEXT @ PREVIOUS
;
: DROP-SCOPE ( -- )
  POP-SCOPE DROP
;
: PUSH-DEVELOP ( wid -- )
  GET-CURRENT >CS DUP SET-CURRENT PUSH-SCOPE
;
: POP-DEVELOP ( -- wid )
  POP-SCOPE CS> SET-CURRENT
;
: DROP-DEVELOP ( -- )
  POP-DEVELOP DROP
;
: BEGIN-EXPORT ( -- )
  GET-CURRENT CS@ SET-CURRENT >CS
;
: END-EXPORT ( -- )
  CS> SET-CURRENT
;


\EOF

\ old ideas:
: DEVELOP ( wid -- ) ( CS: -- wid-prev )
  GET-CURRENT >CS
  ALSO CONTEXT ! DEFINITIONS
;
: FURL ( -- ) ( CS: wid-prev -- )
  PREVIOUS CS> SET-CURRENT
;
