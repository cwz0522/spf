\ ��������� ��� thread-safe
\ ~ac

REQUIRE [IF]   LIB/INCLUDE/TOOLS.F
REQUIRE MARKER ~clf/MARKER.F
REQUIRE /STRING LIB/INCLUDE/STRING.F
: D2* 2DUP D+ ;
: D- DNEGATE D+ ;

0 [IF]

THIS IS AND ANS FORTH  MD5 HASH ALGORITHM FILE HASHER.
MD5FILE WILL REQUEST THE NAME OF A FILE TO MD5 HASH.
IF YOU PUT IN AN INVALID FILE YOU WILL BE TOLD SO AND ASKED
TO TRY AGAIN. HIT N|N TO NOT TRY AGAIN, OTHER KEYS FOR YES.
IT DISPLAYS THE FILES DATASIZE IN BYTES.
IT DECREMENTS A FILE'S BYTECOUNT BY 2 TO PREVENT HASHING
THE CR|LF PAIR THAT END ASCII FILES.  YOU CAN EASILY
CHANGE THIS TO WORK WITH ANY PARTICULAR FILE CHARACTERISTICS.

JABARI ZAKIYA

[THEN]

\ MD5 HASH ROUTINE IN ANS FORTH
\ ORIGINAL CODE POSTED BY FREDERICK W. WARREN 02NOV2000
\ IN COMP.LANG.FORTH.
\ JABARI ZAKIYA 1/15/2001 -- JZAKIYA@MAIL.COM

\ =============================================================
\ MACRO WORDSET FROM WIL BADEN'S TOOL BELT SERIES IN
\ FORTH DIMENSIONS (FD) VOL. 19, NO. 2, JULY/AUGUST 1997
\ ORIGINAL CODE HAS BEEN MODIFIED TO MAKE MORE EFFICIENT
\ MACRO ALLOWS INSERTION OF PARAMETERS FOLLOWING THE MACRO
\ "\" REPRESENTS PLACE WHERE PARAMETER IS INSERTED
\ EXAMPLE:  MACRO  ??  " IF  \  THEN "
\ : FOO .. ?? EXIT .... ;  ?? COMPILES TO -- IF EXIT THEN

\ PLACE AND STRING FOR SYSTEM IF NEEDED
\ NOT NEEDED FOR SWIFTFORTH V 2.00.3, NEEDED FOR WIN32FORTH V 4.10
: PLACE  ( CADDR N ADDR -)  2DUP  C!  CHAR+  SWAP  CHARS  MOVE ;
: STRING ( CHAR "CCC" -) WORD COUNT HERE OVER 1+ CHARS ALLOT PLACE ;

\ VERSIONS OF /STRING AND ANEW IF SYSTEM DOESN'T HAVE THEM
\ : /STRING ( A N K - A+K N-K) ( OVER MIN) TUCK - >R CHARS + R> ;
: ANEW  >IN @ BL WORD FIND IF EXECUTE ELSE DROP THEN >IN ! MARKER ;
: SPLIT-AT-CHAR  ( A  N  CHAR  -  A  K  A+K  N-K)
  >R  2DUP
  BEGIN  DUP  WHILE  OVER  C@  R@  -
  WHILE  1 /STRING  REPEAT  THEN
  R> DROP  TUCK  2>R  -  2R>
;
: DOES>MACRO    \ COMPILE THE MACRO, INCLUDING EXTERNAL PARAMETERS
  DOES> COUNT BEGIN [CHAR]  \ SPLIT-AT-CHAR  2>R  EVALUATE  R@
              WHILE BL WORD COUNT EVALUATE 2R>  1 /STRING REPEAT
              2R>  2DROP
;

\ MACRO CREATION WORD WHICH ALLOWS PARAMETER INSERTION
: MACRO  CREATE  IMMEDIATE  CHAR  STRING  DOES>MACRO  ;

\ ======================  START MD5 CODE ======================
\  VARIABLE A   VARIABLE B   VARIABLE C   VARIABLE D  \ HASH VALUES
  USER A   USER B   USER C   USER D  \ HASH VALUES

\  VARIABLE MD5LEN           \ HOLDS MESSAGE LENGTH
  USER MD5LEN           \ HOLDS MESSAGE LENGTH

\  CREATE BUF[]  64 ALLOT    \ HOLDS MESSAGE BLOCK
  USER-CREATE BUF[]  64 USER-ALLOT    \ HOLDS MESSAGE BLOCK

  0 VALUE  LITVAL
: ]L  S" TO LITVAL LITVAL ] LITERAL " EVALUATE ; IMMEDIATE
\ ���������� :) LITVAL ����� � �� ����� ����� (~ac)

  1 A !     \ FOR ENDIAN TESTING
  A C@ [IF] \ IF LITTLE ENDIAN CPU
: ENDIAN@  ( A1 - N1 )  S" @ " EVALUATE ; IMMEDIATE
: ENDIAN!  ( N A1 -- )  S" ! " EVALUATE ; IMMEDIATE

  [ELSE] \ BIG ENDIAN CPUS (E.G. MACS)
: ENDIAN@  ( A1 -- N1 )
  DUP >R  3  +  C@  8 LSHIFT R@  2  +  C@  +  8 LSHIFT
  R@  1+  C@  +  8 LSHIFT  R>  C@  +
;

: ENDIAN!  ( N1 A1 - )
  >R  256 /MOD  SWAP  R@  C!  256 /MOD  SWAP  R@  1+  C!
  256 /MOD  SWAP  R@  2  +  C!  R>  3  +  C!
;
  [THEN]

\ MACROS INSERTS 4 VARIABLE NAMES AT THE '\' LOCATIONS
MACRO F() " \ @ DUP >R INVERT \ @ AND R> \ @ AND OR \ @ + "
MACRO G() " \ @ DUP >R INVERT \ @ AND R> \ @ AND OR \ @ + "
MACRO H() " \ @ \ @ XOR \ @ XOR \ @ + "
MACRO I() " \ @ INVERT \ @ OR \ @ XOR \ @ + "

  32 CONSTANT CELLSIZE
MACRO ROL  " DUP [ CELLSIZE \ TUCK - ]L RSHIFT SWAP LITERAL LSHIFT OR "
MACRO M[]+ " R@  \  CELLS +  ENDIAN@  + "

 HEX
: TRANSFORM ( ADR -- )
  >R  A @  D @  C @  B @

\ ROUND1 ( -- )   F(B,C,D) = (B&C)|(~B&D)
  F() B D C A  0D76AA478 +  M[]+ 00  ROL 07  B @ +  A !  \ 1
  F() A C B D  0E8C7B756 +  M[]+ 01  ROL 0C  A @ +  D !  \ 2
  F() D B A C  0242070DB +  M[]+ 02  ROL 11  D @ +  C !  \ 3
  F() C A D B  0C1BDCEEE +  M[]+ 03  ROL 16  C @ +  B !  \ 4
  F() B D C A  0F57C0FAF +  M[]+ 04  ROL 07  B @ +  A !  \ 5
  F() A C B D  04787C62A +  M[]+ 05  ROL 0C  A @ +  D !  \ 6
  F() D B A C  0A8304613 +  M[]+ 06  ROL 11  D @ +  C !  \ 7
  F() C A D B  0FD469501 +  M[]+ 07  ROL 16  C @ +  B !  \ 8
  F() B D C A  0698098D8 +  M[]+ 08  ROL 07  B @ +  A !  \ 9
  F() A C B D  08B44F7AF +  M[]+ 09  ROL 0C  A @ +  D !  \ 10
  F() D B A C  0FFFF5BB1 +  M[]+ 0A  ROL 11  D @ +  C !  \ 11
  F() C A D B  0895CD7BE +  M[]+ 0B  ROL 16  C @ +  B !  \ 12
  F() B D C A  06B901122 +  M[]+ 0C  ROL 07  B @ +  A !  \ 13
  F() A C B D  0FD987193 +  M[]+ 0D  ROL 0C  A @ +  D !  \ 14
  F() D B A C  0A679438E +  M[]+ 0E  ROL 11  D @ +  C !  \ 15
  F() C A D B  049B40821 +  M[]+ 0F  ROL 16  C @ +  B !  \ 16

\ ROUND2 ( -- )   G(B,C,D) = (D&B)|(~D&C)
  G() D C B A  0F61E2562 +  M[]+ 01  ROL 05  B @ +  A !  \ 1
  G() C B A D  0C040B340 +  M[]+ 06  ROL 09  A @ +  D !  \ 2
  G() B A D C  0265E5A51 +  M[]+ 0B  ROL 0E  D @ +  C !  \ 3
  G() A D C B  0E9B6C7AA +  M[]+ 00  ROL 14  C @ +  B !  \ 4
  G() D C B A  0D62F105D +  M[]+ 05  ROL 05  B @ +  A !  \ 5
  G() C B A D  002441453 +  M[]+ 0A  ROL 09  A @ +  D !  \ 6
  G() B A D C  0D8A1E681 +  M[]+ 0F  ROL 0E  D @ +  C !  \ 7
  G() A D C B  0E7D3FBC8 +  M[]+ 04  ROL 14  C @ +  B !  \ 8
  G() D C B A  021E1CDE6 +  M[]+ 09  ROL 05  B @ +  A !  \ 9
  G() C B A D  0C33707D6 +  M[]+ 0E  ROL 09  A @ +  D !  \ 10
  G() B A D C  0F4D50D87 +  M[]+ 03  ROL 0E  D @ +  C !  \ 11
  G() A D C B  0455A14ED +  M[]+ 08  ROL 14  C @ +  B !  \ 12
  G() D C B A  0A9E3E905 +  M[]+ 0D  ROL 05  B @ +  A !  \ 13
  G() C B A D  0FCEFA3F8 +  M[]+ 02  ROL 09  A @ +  D !  \ 14
  G() B A D C  0676F02D9 +  M[]+ 07  ROL 0E  D @ +  C !  \ 15
  G() A D C B  08D2A4C8A +  M[]+ 0C  ROL 14  C @ +  B !  \ 16

\ ROUND3 ( -- )   H(B,C,D) = B^C^D
  H() B C D A  0FFFA3942 +  M[]+ 05  ROL 04  B @ +  A !  \ 1
  H() A B C D  08771F681 +  M[]+ 08  ROL 0B  A @ +  D !  \ 2
  H() D A B C  06D9D6122 +  M[]+ 0B  ROL 10  D @ +  C !  \ 3
  H() C D A B  0FDE5380C +  M[]+ 0E  ROL 17  C @ +  B !  \ 4
  H() B C D A  0A4BEEA44 +  M[]+ 01  ROL 04  B @ +  A !  \ 5
  H() A B C D  04BDECFA9 +  M[]+ 04  ROL 0B  A @ +  D !  \ 6
  H() D A B C  0F6BB4B60 +  M[]+ 07  ROL 10  D @ +  C !  \ 7
  H() C D A B  0BEBFBC70 +  M[]+ 0A  ROL 17  C @ +  B !  \ 8
  H() B C D A  0289B7EC6 +  M[]+ 0D  ROL 04  B @ +  A !  \ 9
  H() A B C D  0EAA127FA +  M[]+ 00  ROL 0B  A @ +  D !  \ 10
  H() D A B C  0D4EF3085 +  M[]+ 03  ROL 10  D @ +  C !  \ 11
  H() C D A B  004881D05 +  M[]+ 06  ROL 17  C @ +  B !  \ 12
  H() B C D A  0D9D4D039 +  M[]+ 09  ROL 04  B @ +  A !  \ 13
  H() A B C D  0E6DB99E5 +  M[]+ 0C  ROL 0B  A @ +  D !  \ 14
  H() D A B C  01FA27CF8 +  M[]+ 0F  ROL 10  D @ +  C !  \ 15
  H() C D A B  0C4AC5665 +  M[]+ 02  ROL 17  C @ +  B !  \ 16

\ ROUND4 ( -- )   I(B,C,D) = C^(B|~D)
  I() D B C A  0F4292244 +  M[]+ 00  ROL 06  B @ +  A !  \ 1
  I() C A B D  0432AFF97 +  M[]+ 07  ROL 0A  A @ +  D !  \ 2
  I() B D A C  0AB9423A7 +  M[]+ 0E  ROL 0F  D @ +  C !  \ 3
  I() A C D B  0FC93A039 +  M[]+ 05  ROL 15  C @ +  B !  \ 4
  I() D B C A  0655B59C3 +  M[]+ 0C  ROL 06  B @ +  A !  \ 5
  I() C A B D  08F0CCC92 +  M[]+ 03  ROL 0A  A @ +  D !  \ 6
  I() B D A C  0FFEFF47D +  M[]+ 0A  ROL 0F  D @ +  C !  \ 7
  I() A C D B  085845DD1 +  M[]+ 01  ROL 15  C @ +  B !  \ 8
  I() D B C A  06FA87E4F +  M[]+ 08  ROL 06  B @ +  A !  \ 9
  I() C A B D  0FE2CE6E0 +  M[]+ 0F  ROL 0A  A @ +  D !  \ 10
  I() B D A C  0A3014314 +  M[]+ 06  ROL 0F  D @ +  C !  \ 11
  I() A C D B  04E0811A1 +  M[]+ 0D  ROL 15  C @ +  B !  \ 12
  I() D B C A  0F7537E82 +  M[]+ 04  ROL 06  B @ +  A !  \ 13
  I() C A B D  0BD3AF235 +  M[]+ 0B  ROL 0A  A @ +  D !  \ 14
  I() B D A C  02AD7D2BB +  M[]+ 02  ROL 0F  D @ +  C !  \ 15
  I() A C D B  0EB86D391 +  M[]+ 09  ROL 15  C @ +  B !  \ 16

  B +!  C +!  D +!  A +!  R> DROP  \ UPDATE HASH VALUES
;

: MD5INT ( -- )
  067452301 A !  0EFCDAB89 B !
  098BADCFE C !  010325476 D !
;

 DECIMAL

: SETLEN ( -- )
  MD5LEN @  DUP  29 RSHIFT  BUF[] 60 + ! \ [ BUF[] 60 + ]L !
  3 LSHIFT  BUF[] 56 + ! \ [ BUF[] 56 + ]L !
;

\ DO ALL 64 BYTE BLOCKS LEAVING REMAINDER BLOCK
: DOFULLBLOCKS ( ADR1 COUNT1 --  ADR2 COUNT2 )
  DUP  -64  AND  ( COUNT 63 > - ?)
  IF  DUP >R  6 RSHIFT  ( COUNT/64)
      0 DO  DUP  TRANSFORM  64 +  LOOP  R> 63 AND
  THEN
;

: DOFINAL ( ADDR COUNT -- )  \ HASH PARTIAL|LAST BLOCK
  DUP >R  BUF[]  DUP >R  SWAP  CMOVE
  R> R@ +  128  OVER  C! CHAR+  55 R@ -  R> 55 >
  IF  8 + 0 FILL  BUF[]  TRANSFORM  BUF[] 56  THEN
  0 FILL  SETLEN  BUF[]  TRANSFORM
;

\ COMPUTE MD5 FROM A COUNTED BUFFER OF TEXT
: MD5FULL ( ADDR COUNT -- )
  MD5INT  DUP  MD5LEN !  DOFULLBLOCKS  DOFINAL
;



\ FUNCTIONS FOR CREATING OUTPUT STRING
CREATE DIGIT$  \ ARRAY OF DIGITS 0123456789ABCDEF
  48 C, 49 C, 50 C, 51 C, 52 C, 53 C, 54 C, 55 C, 56 C, 57 C,
  97 C, 98 C, 99 C, 100 C, 101 C, 102 C,

: INTDIGITS ( -- )  0 PAD ! ;
: SAVEDIGIT ( N -- )  PAD C@ 1+ DUP PAD C! PAD + C! ;
: BYTEDIGITS ( N1 -- )
  DUP 4 RSHIFT DIGIT$ + C@ SAVEDIGIT 15 AND DIGIT$ + C@ SAVEDIGIT
;

 A C@ [IF] \ LITTLE ENDIAN
: CELLDIGITS ( A1 -- )  DUP 4 + SWAP DO I C@ BYTEDIGITS LOOP ; [ELSE]
: CELLDIGITS ( A1 -- )  DUP 3 + DO I C@ BYTEDIGITS -1  +LOOP ;
 [THEN]

: MD5STRING ( -- ADR COUNT ) \ RETURN ADDRESS OF COUNTED MD5 STRING
  INTDIGITS  D  C  B  A  4 0 DO  CELLDIGITS  LOOP
  PAD COUNT
;

\ =====================  MD5 TEST SUITE  ======================
: QUOTESTRING ( ADR COUNT -- )  [CHAR] " EMIT  TYPE  [CHAR] " EMIT ;
: .MD5 ( ADR COUNT -- )
  CR CR 2DUP MD5FULL MD5STRING TYPE SPACE QUOTESTRING ;

\ : MD5TEST ( -- )
(  ." MD5 TEST SUITE RESULTS:"
  S" "  .MD5
  S" A" .MD5
  S" ABC" .MD5
  S" ABCDEFGHIJKLMNOPQRSTUVWXYZ" .MD5
  S" ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
.MD5
  S" 12345678901234567890123456789012345678901234567890123456789012345678901234567890"
  .MD5
; )

\ ====================  FILE HASH WORDSET  ====================

  USER  RFILEID     \ HOLDS FILEID NUMBER OF INPUT FILE

: INPUTFILENAME  ( -- IOR)
  CR  CR  ." FILENAME: "  PAD  DUP  80  ACCEPT ( ADR #)
( ~ac) 2DUP + 0 SWAP C!
  R/O  OPEN-FILE  SWAP  RFILEID !  ( IOR)
;

: TRYAGAIN?  ( -- ?)
  CR CR ." INVALID IPUT FILE, TRY AGAIN? (Y/N)"
  KEY  DUP  EMIT  DUP [CHAR] N =  SWAP [CHAR] N = OR
;

\ READ N BYTES FROM INPUT FILE, STORE AT ADDR ARRAY
: BYTES@  ( ADR N - )  RFILEID @  READ-FILE  2DROP ;
: STORELEN  ( LO HI - )
  D2*  D2*  D2*  
  BUF[] 60 + ! BUF[] 56 + !
\ [ BUF[] 60 + ]L !  [ BUF[] 56 + ]L !
;



: GETPARTIAL ( CNT -- BUF[] CNT2 ?)
  BUF[] 2DUP  SWAP  DUP >R  BYTES@     ( CNT1 ADR1  )
  + 128 OVER C! CHAR+ 55 R@ - R> 55 >  ( ADR2 CNT2 ?)
;

MACRO BLOCK@    " BUF[]  64  BYTES@ "
MACRO MD5TRANS  " BUF[]  TRANSFORM  "

: MD5FILE ( -- )
  BEGIN  INPUTFILENAME  ( IOR)          \ ENTER FILENAME
  WHILE  TRYAGAIN? IF  EXIT  THEN       \ NOT VALID, TRY (NOT) AGAIN
  REPEAT MD5INT                         \ VALID FILE, INIT TRANSFORM
  RFILEID @  FILE-SIZE  DROP  ( UD )    \ GET BYTESIZE OF INPUT FILE
  2 0  D-                               \ DEC CNT BY 2 FOR CR|LF EOF
  CR ." BYTESIZE: " 2DUP  D.            \ DISPLAY FILESIZE TO SCREEN
  2DUP  2>R                             \ SAVE MESSAGE CNT ON RETURN
  64  UM/MOD  ( REMBYTES NBLOCKS )      \ COMPUTE NBLOCKS & REMBYTES
  0 ?DO  BLOCK@  MD5TRANS  LOOP         \ DO N FULL BLOCKS
  ( REMBYTES)  GETPARTIAL ( ADR CNT ?)  \ READ REMAINING BYTES
  IF 8 + 0 FILL MD5TRANS BUF[] 56 THEN  \ DO IF REMBYTES > 55
  0 FILL  2R> STORELEN  MD5TRANS        \ DO LAST BLOCK
  CR  ." MD5 HASH: " MD5STRING TYPE CR  \ SHOW MD5 HASH FOR FILE
  RFILEID @  CLOSE-FILE  DROP           \ CLOSE THE INPUT FILE
;

: MD5 ( addr u -- addr2 u2 ) MD5FULL MD5STRING ;
