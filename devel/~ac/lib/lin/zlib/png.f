\ $Id$
\ ������ � ���������� ������ �/�� PNG-�������.
\ ������ ������������ SPF/4.20 � ���� ��������:
\ http://www.forth.org.ru/~ac/spf-builds/SPF4.20/

\ �������� ������� - CreatePng � ReadPng.
\ ������������ PNG-����� � ������������� ������� addr u ������:
\ ( addr u ) S" test.png" 800 CreatePng
\ ���������� �������:
\ S" test.png" ReadPng ( addr u2 )

\ ������� �������� � ������ PNG-������ ��. � ����� ������.

( ����������� ����������:

  LibPNG �� ������������.

  �������� ������ ���� �������������, ������� ������ �������� ������
  ��� ������ ����������� �� ��������� x*3, ��� x - �������� ��������������
  ������ �������� � �������� [� ����� ������ 3 ����� - truecolor-����],
  ���������� ������. �������� [�������������] ������ ������ �� ������������,
  �������, ���� ��� ���������� ������ ������ ������ �����, �� ��� �������� 
  ������ �������� ������ ����� ������ ������ ������, � ��� ������� �����
  ��� ���������� ������ ������ DROP ASCIIZ>.

  � �����-������� 4 ����� �� ������, ����������� uPngPP.

  ������ �������� ������ �������� � ������ ���� [zlib deflate], �������
  ��������� �������� ������/���������� ������ �� ��������� - ��� ��������
  �������������.
)

REQUIRE zlib_uncompress ~ac/lib/lin/zlib/zlib.f 
REQUIRE STR@            ~ac/lib/str5.f

CREATE PNGSIG 137 C, 80 C, 78 C, 71 C, 13 C, 10 C, 26 C, 10 C,

0
4 -- png.ChunkSize
4 -- png.ChunkType
0 -- png.ChunkData
CONSTANT /PngChunk

0
\ The IHDR chunk must appear FIRST. It contains:
4 -- IHDR.Width
4 -- IHDR.Height
1 -- IHDR.BitDepth          \ 8 (per sample or per palette index)
1 -- IHDR.ColorType         \ 2 (1 (palette used), 2 (color used), and 4 (alpha channel used).)
1 -- IHDR.CompressionMethod \ 0 (deflate/inflate compression with a sliding window of at most 32768 bytes)
1 -- IHDR.FilterMethod      \ 0 (adaptive filtering with five basic filter types)
1 -- IHDR.InterlaceMethod   \ 0 (0 (no interlace) or 1 (Adam7 interlace))
CONSTANT /IHDR

USER-CREATE PNGCHUNK /PngChunk USER-ALLOT
USER-CREATE PNGCRC   4 USER-ALLOT
CREATE tIHDR1        0 C, 0 C, 0 C, 1  C, 0 C, 0 C, 0 C, 1 C,  8 C, 2 C, 0 C, 0 C, 0 C,
USER-CREATE tIHDR   13 USER-ALLOT

: BIGENDIAN@  ( A1 -- N1 )
  DUP >R  C@  8 LSHIFT R@  1 +  C@  +  8 LSHIFT
  R@  2+  C@  +  8 LSHIFT  R>  3 + C@  +
;
USER uIDAT
USER pngDA USER pngDU

: ReadPng ( addr u -- da du )
\ ������� �� ���������� PNG-����� ������, ������� � ������ IDAT-������ (�.�. ������ �������� ��� ��� ������ ����)

  "" uIDAT ! pngDA 0! pngDU 0!
  R/O OPEN-FILE THROW >R
  tIHDR 8 R@ READ-FILE THROW tIHDR SWAP PNGSIG 8 COMPARE IF R> CLOSE-FILE THROW ." PNG signature mismatch" CR S" " EXIT THEN
  BEGIN
    PNGCHUNK /PngChunk R@ READ-FILE THROW /PngChunk =
  WHILE
    PNGCHUNK png.ChunkType 4 TYPE SPACE
    PNGCHUNK png.ChunkSize BIGENDIAN@ DUP .
    DUP CELL+ ALLOCATE THROW ( size mem )
    PNGCHUNK png.ChunkType @ OVER !
    DUP CELL+ ROT ( mem mem+ size)
    R@ READ-FILE THROW ( mem size )
    2DUP SWAP CELL+ SWAP
    PNGCHUNK png.ChunkType 4 SFIND IF EXECUTE CR ELSE CR TYPE ."  -- unknown png chunk type" CR 32 MIN DUMP CR THEN
    2DUP CELL+ CRC32 >R
    DROP FREE THROW
    R>
    PNGCRC 4 R@ READ-FILE THROW DROP PNGCRC BIGENDIAN@ <> IF ." -- png CRC mismatch" CR THEN
    PNGCHUNK png.ChunkType 4 S" IEND" COMPARE 0= IF R> CLOSE-FILE THROW pngDA @ pngDU @ EXIT THEN
  REPEAT
  R> CLOSE-FILE THROW
  pngDA @ pngDU @
;
: WritePngChunk { da du ta tu h \ mem crc -- }
  du 12 + ALLOCATE THROW -> mem
  da mem png.ChunkData du MOVE
  ^ du BIGENDIAN@ mem png.ChunkSize !
  ta mem png.ChunkType 4 MOVE
  mem png.ChunkType du 4 + CRC32 -> crc
  ^ crc BIGENDIAN@ mem png.ChunkData du + !
  mem du 12 + h WRITE-FILE THROW
;
USER uPngWidth
USER uPngHeight
USER uPngPP
: AlphaPng 6 uPngPP ! ;

: PngPP ( -- n ) \ 3 ��� 4 - ����� ���� �� ������
  uPngPP @ 4 AND
  IF 4 ELSE 3 THEN
;
: RasterizeData { da du x \ xx lines mem u2 -- a2 u2 y x }
  x PngPP * -> xx
  du xx 1- + xx / DUP -> lines \ ����� �� x �����
  xx 1+ * DUP -> u2 ALLOCATE THROW -> mem \ ������ ������ �������� ���� "filter-type" (0 ��� 1), ��. 2.3. Image layout
  lines 0 DO
    da  mem I xx 1+ * + 1+  du xx MIN  MOVE
    da xx + -> da
    du xx - 0 MAX -> du
  LOOP
  mem u2
  lines x
;
: DerasterizeData { da du x \ xx lines mem u2 m -- a2 u2 y x }
  x PngPP * -> xx
  du xx 1+ / DUP -> lines \ ����� �� x �����, ������� �� ���� ������ � du ("filter-type" � ������ ������)
  du SWAP - DUP -> u2 ALLOCATE THROW -> mem
  lines 0 DO
    da I xx 1+ * + 1+  mem I xx * +  xx MOVE
  LOOP
  mem u2
  lines x
;
: BIGENDIAN! { x addr -- }
  x addr ! addr BIGENDIAN@ addr !
;
: CreatePng { da du fa fu x \ h -- }
\ �������� ������ da du � PNG-���� � ������ fa fu.
\ ���� ��������� ��������� ����� � rgb, 24pp, ������ �������� x ��������.

  fa fu R/W CREATE-FILE THROW -> h
  PNGSIG 8 h WRITE-FILE THROW
  tIHDR1 tIHDR 13 MOVE
  uPngPP @ 0= IF 2 uPngPP ! THEN
  da du x RasterizeData
  tIHDR IHDR.Width BIGENDIAN!
  tIHDR IHDR.Height BIGENDIAN!
  uPngPP @ tIHDR IHDR.ColorType C!
  tIHDR 13 S" IHDR" h WritePngChunk
\  S" 123456" 2DUP ERASE S" tRNS" h WritePngChunk \ ������ ���� ����� ����������, ���� �� ����� ������� �������� ���� :)
\ pHYs 9
\ gAMA 4
   zlib_compress S" IDAT" h WritePngChunk
  S" " S" IEND" h WritePngChunk
  h CLOSE-FILE THROW
;

: IHDR ( addr u -- ) \ 00 00 00 10  00 00 00 10  08 02 00 00  00
  OVER IHDR.Width BIGENDIAN@ DUP uPngWidth ! . ." x "
  OVER IHDR.Height BIGENDIAN@ DUP uPngHeight ! .
  OVER IHDR.BitDepth C@ ." @ " .
  OVER IHDR.ColorType C@ DUP uPngPP ! ." & " .
  2DROP
;
: pHYs ( addr u -- ) \ 00 00 0E C3  00 00 0E C3  01  ...�...�. \  Physical pixel dimensions
  2DROP
\   Pixels per unit, X axis: 4 bytes (unsigned integer)
\   Pixels per unit, Y axis: 4 bytes (unsigned integer)
\   Unit specifier:          1 byte (1: unit is the meter)
;
: gAMA ( addr u -- ) \ 00 00 B1 8F \ Image gamma
  2DROP
;

: IDAT ( addr u -- ) \ 38 4F 63 FC  FF FF 3F 03  49 00 A8 81  24 C0 00 54 8O ....
                     \ actual image data
  uIDAT @ STR+       \ The compressed datastream is then the concatenation of the contents of all the IDAT chunks.
;
: IEND ( addr 0 -- )
  2DROP
  uIDAT @ STR@
  CR ." comp=" DUP .
  uPngWidth @ uPngHeight @ * PngPP *  uPngHeight @ + \ ���.���� �� ������ ����-������
DUP .
  zlib_uncompress_l ." uncomp=" DUP .
  DUP IF
    uPngWidth @ DerasterizeData ." x*y=" . .
    ." dr=" DUP .
    2DUP 40 MIN DUMP
  THEN
  pngDU ! pngDA !
  uIDAT @ STRFREE uIDAT 0!
;
\ �� ������� �����:
: sRGB ( addr 1 -- ) \ 00 \ Standard RGB color space (0: Perceptual)
  2DROP
;
: cHRM ( addr u -- ) \  00 00 7A 26  00 00 80 84  00 00 FA 00  00 00 80 E8 ... \ Primary chromaticities
  2DROP
;
\ �� �����������:
: PLTE ( addr u -- ) \ contains from 1 to 256 palette entries, each a three-byte (RGB) series
  2DROP
;
: tRNS ( addr u -- ) \ Transparency
  2DROP
;
: iCCP ( addr u -- ) \ Embedded ICC profile
  2DROP
;
: tEXt ( addr u -- ) \ Textual data
\   Keyword:        1-79 bytes (character string)
\   Null separator: 1 byte
\   Text:           n bytes (character string)
  TYPE CR
;
: zTXt ( addr u -- ) \ Compressed textual data
  DROP ASCIIZ> TYPE
\   Keyword:            1-79 bytes (character string)
\   Null separator:     1 byte
\   Compression method: 1 byte
\   Compressed text:    n bytes
;
: iTXt ( addr u -- ) \ International textual data
  DROP ASCIIZ> TYPE
\   Keyword:             1-79 bytes (character string)
\   Null separator:      1 byte
\   Compression flag:    1 byte
\   Compression method:  1 byte
\   Language tag:        0 or more bytes (character string)
\   Null separator:      1 byte
\   Translated keyword:  0 or more bytes
\   Null separator:      1 byte
\   Text:                0 or more bytes
;

(
The following keywords are predefined and should be used where appropriate:

   Title            Short [one line] title or caption for image
   Author           Name of image's creator
   Description      Description of image [possibly long]
   Copyright        Copyright notice
   Creation Time    Time of original image creation
   Software         Software used to create the image
   Disclaimer       Legal disclaimer
   Warning          Warning of nature of content
   Source           Device used to create the image
   Comment          Miscellaneous comment; conversion from
                    GIF comment
)

: bKGD ( addr u -- ) \ Background color
  2DROP
;
: sBIT ( addr u -- ) \ Significant bits
  2DROP
;
: sPLT ( addr u -- ) \ Suggested palette
  2DROP
;
: hIST ( addr u -- ) \ Palette histogram
  2DROP
;
: tIME ( addr u -- ) \ Image last-modification time
  2DROP
\   Year:   2 bytes (complete; for example, 1995, not 95)
\   Month:  1 byte (1-12)
\   Day:    1 byte (1-31)
\   Hour:   1 byte (0-23)
\   Minute: 1 byte (0-59)
\   Second: 1 byte (0-60)    (yes, 60, for leap seconds; not 61, a common error)
;

(
  Applications can use PNG private chunks to carry information that need not be understood by other applications.
  Such chunks must be given names with lowercase second letters, to ensure that they can never conflict with any 
  future public chunk definition. Note, however, that there is no guarantee that some other application will not 
  use the same private chunk name. If you use a private chunk type, it is prudent to store additional identifying 
 information at the beginning of the chunk data. 
)

\ ������������� APNG (������������� PNG, �������������� FF3 � ������9.5)
\ https://wiki.mozilla.org/APNG_Specification
\ http://en.wikipedia.org/wiki/APNG

: acTL ( addr u -- ) \ The Animation Control Chunk
  2DROP
;
: fcTL ( addr u -- ) \ The Frame Control Chunk
  2DROP
;
: fdAT ( addr u -- ) \ The Frame Data Chunk
\ The `fdAT` chunk has the same purpose as an `IDAT` chunk. It has the same structure as an `IDAT` chunk, except preceded by a sequence number. 
  2DROP
;

\EOF
\ � ������ ������� �������� ������ ���������, ����� �������� ���� �������� :)
\ � ����� ��� ���������� �������� ������������� ������

S" E:\dl\spf4-20-setup.exe" FILE zlib_compress S" spf4_pic.png" 1024 CreatePng
S" spf4_pic.png" ReadPng zlib_uncompress S" spf4-fromPNG.exe" WFILE

S" F:\spf4\src\spf_forthproc.f" FILE S" spf_forthproc.png" 100 CreatePng
S" spf_forthproc.png" ReadPng S" spf4-forthproc-fromPNG.f" WFILE

\ ���������� ������� png-����� (10-50% - �� ���� ���������� "������" ������ � ������ "���������" IDAT ����� �������)
S" C:\Users\ac\Pictures\black.png" ReadPng S" black.bin" WFILE
S" black.bin" FILE S" black.png" uPngWidth @ CreatePng

\ ���������� ������������� ������� �������� �� �������� �� ���� �������������� ���������� ����� (�����)
\ ������ png-����� ���� �����������, �� �� ��������� ���� �������� - �� ���� ���������� �-�� filter-byte,
\ ������� per line.
AlphaPng
S" E:\dl\spf4-20-setup.exe" FILE zlib_compress S" spf4_pic2.png" 1024 CreatePng
S" spf4_pic2.png" ReadPng zlib_uncompress S" spf4-fromPNG.exe" WFILE
