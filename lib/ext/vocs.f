

\ ����������� ������ ��������.
: VOCS
        VOC-LIST
        BEGIN @ DUP WHILE
                DUP CELL+ VOC-NAME.
                DUP 3 CELLS + @ \ wid ������
                ?DUP IF ."  defined in "  VOC-NAME.
                     ELSE ."  is the main vocabulary"
                     THEN CR
        REPEAT
        DROP
;

