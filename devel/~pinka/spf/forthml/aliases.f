\ 17.Feb.2007

\ ����� ��������� ��� ��������� ���������� � xml

REQUIRE NAMING- ~pinka/spf/compiler/index.f

\ & ( c-addr u -- xt )

: aka ( olda oldu newa newu -- ) 2SWAP  &  NAMING  ;

`<>  `NEQ   aka
`=   `EQ    aka
`0<  `0LT   aka
`0<> `0NEQ  aka
`0=  `0EQ   aka
`U<  `ULT   aka
`U>  `UGT   aka
`D0= `D0EQ  aka
