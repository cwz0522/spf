( gzip [ addr u -- addr2 u2 ] - ����� ���������� �����
  � ������� ������� GZIP [RFC1952].
  ��� ���������� ���������� �������� �������� 
  ��������� ������ ����������� ������� zlib->gzip.
  ��� ������ ����������� ������ � ���� ���������� �������
  .gz ���� [��� �������� ����� � ���� ��������� �����,
  �.�. ��������� �� ����, � �����]
  ��� ������ � ����� ������������� ������������
  Content-Encoding: gzip, �.�. ��������������� �����
  ����������� � ���� http-������.

  gzip_write [ addr u -- ] - ��� ������������� ������ 
  WRITE-FILE, WriteSocket ��� TYPE
  - ������� ���������� ����� � ���������� � ������� GZIP [RFC1952]
  ��� ������ ������������ ����� VECT gzip_write_function,
  ������� �� ��������� ��������� TYPE.
  gzip_write ���������, ��� gzip[] �� ���� ����������
  �������� ����������� � ������ � ��������� �������������� ������.

  zlib_compress � zlib_uncompress [ addr u -- addr2 u2 ]
  ���������� ������ zlib deflate [RFC1950]

  [���������� 01.10.2007] dll ������ � CVS. ���� �� ������ �����,
  ��� �������, �� ����� ������: http://www.forth.org.ru/ext/zlib.dll [2003�]
)

WINAPI: compress   zlib.dll
WINAPI: uncompress zlib.dll
WINAPI: crc32      zlib.dll

\ int compress (Bytef *dest, uLongf *destLen, const Bytef *source, uLong sourceLen); 
\ Compresses the source buffer into the destination buffer. 
\ sourceLen is the byte length of the source buffer. Upon entry, 
\ destLen is the total size of the destination buffer, which must 
\ be at least 0.1% larger than sourceLen plus 12 bytes. Upon exit, 
\ destLen is the actual size of the compressed buffer.
\ This function can be used to compress a whole file at once if the 
\ input file is mmap'ed.
\ compress returns Z_OK if success, Z_MEM_ERROR if there was not 
\ enough memory, Z_BUF_ERROR if there was not enough room in the 
\ output buffer.

 0 CONSTANT Z_OK
-4 CONSTANT Z_MEM_ERROR
-5 CONSTANT Z_BUF_ERROR

: zlib_compress ( addr u -- addr2 u2 )
  SWAP OVER 110 100 */ 12 +
  DUP ALLOCATE THROW DUP >R SWAP >R
  RP@ SWAP
  compress >R 2DROP 2DROP R>
  Z_OK = IF 2R> ELSE 2R> DROP FREE THROW S" " THEN
;
: zlib_uncompress ( addr u -- addr2 u2 )
  SWAP OVER 2000 100 */
  DUP ALLOCATE THROW DUP >R SWAP >R
  RP@ SWAP
  uncompress >R 2DROP 2DROP R>
  Z_OK = IF 2R> ELSE 2R> DROP FREE THROW S" " THEN
;
: CRC32 ( addr u -- crc32 )
  SWAP 0 crc32 >R DROP 2DROP R> \ crc32
;
CREATE gzip_header
0x1F C, 0x8B C, \ gzip_id
08 C,           \ compression=deflate
0 C,            \ flags 1=text, 2=hcrc, 4=extra, 8=fname, 16=comment
0 ,             \ unix mtime
0 C,            \ xfl
0 C,            \ OS: win=0, unix=3
HERE gzip_header - CONSTANT /gzip_header

VECT gzip_write_function ' TYPE TO gzip_write_function

: gzip
  DUP >R
  2DUP CRC32 >R
  zlib_compress OVER >R \ ����� ���������
  6 - SWAP 2+ SWAP      \ ������ ����
  DUP /gzip_header + 2 CELLS + DUP >R \ ������ ������� gzip
  ALLOCATE THROW >R
  gzip_header R@ /gzip_header CMOVE
  R@ /gzip_header + SWAP CMOVE
  R> R> R> FREE THROW
  2DUP + R> OVER 8 - ! R> SWAP 4 - !
;
: gzip_write ( addr u -- )
  DUP >R
  2DUP CRC32 >R
  gzip_header /gzip_header gzip_write_function
  zlib_compress
  6 - SWAP 2+ SWAP \ �������� 2 ����� � ������ � 4 � ����� (deflate-specific?)
  gzip_write_function
  RP@ 4 gzip_write_function \ crc
  RDROP RP@ 4 gzip_write_function \ size
  RDROP
;

(
REQUIRE STR@                ~ac/lib/str2.f
: TEST
  H-STDOUT >R
  S" test.gz" R/W CREATE-FILE THROW TO H-STDOUT
  S" rfc2616.txt" FILE gzip TYPE \ gzip_write
  H-STDOUT CLOSE-FILE THROW
  R> TO H-STDOUT
; TEST
)
