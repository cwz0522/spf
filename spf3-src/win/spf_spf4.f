: SEEN-ERR  ( -- )
\ ���������� ����, ��� ������ ������.
\  0 ERR-DATA err.notseen C!
;
: ERR-LINE# ( -- num ) \ ����� ������������ ������
\  ERR-DATA err.line# @
  CURSTR @
;
: ERR-IN#   ( -- num ) \ ��������� ����������� ����� >IN
\  ERR-DATA err.in#   @
  >IN @
;
