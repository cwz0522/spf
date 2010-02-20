REQUIRE CapStart  ~ac/lib/win/mm/cam.f 
REQUIRE CreatePng ~ac/lib/lin/zlib/png.f 

: SaveSamplePNG { lBufferSize pBuffer dblSampleTime2 dblSampleTime1 this -- }
  dblSampleTime1 dblSampleTime2 D. pBuffer . lBufferSize . CR
  lBufferSize 2 / 0 DO \ �������� bottom-up-���������� � �����
    pBuffer I + DUP C@
    pBuffer lBufferSize + I - 1- DUP C@ ROT ROT C! SWAP C!
  LOOP
  pBuffer lBufferSize S" test.png" this @ CB.width @ CreatePng
;
: TEST { \ cap -- }
  ['] SaveSamplePNG CapOpen -> cap
  cap CapStart
  2000 PAUSE \ ������� �������� �����
  cap CapStop
;
\ S" vtest.exe" SAVE BYE
TEST
