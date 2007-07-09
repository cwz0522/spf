\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   graph for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� �뢮�� ��䨪� �� ���. ���᮫�
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.3
\ -----------------------------------------------------------------------------
REQUIRE wincon	~pi/lib/wincon/wincon.f

WINAPI: SetPixel		GDI32.DLL
WINAPI: MoveToEx		GDI32.DLL
WINAPI: LineTo			GDI32.DLL
WINAPI: Ellipse			GDI32.DLL
WINAPI: RoundRect		GDI32.DLL
WINAPI: LoadImageA		USER32.DLL
WINAPI: StretchBlt		GDI32.DLL
WINAPI: GetObjectA		GDI32.DLL

0
CELL -- bmType
CELL -- bmWidth
CELL -- bmHeight
CELL -- bmWidthBytes
2 -- bmPlanes
2 -- bmBitsPixel
CELL -- bmBits
CONSTANT BITMAP
0 VALUE bitmap
BITMAP ALLOCATE THROW TO bitmap


\ ��६�頥� ��� ��砫� �ᮢ���� ��� Draw
: MoveTo ( x y -> )
	0 -ROT SWAP phdc MoveToEx DROP ;

\ ����� ����� �� ⥪�� �窨 �ᮢ����
: Draw ( x y -> )
	SWAP phdc LineTo DROP ;

\ ���ᮢ��� ���
: Point ( x y -> )
	SWAP color -ROT phdc SetPixel DROP ;

\ ���ᮢ��� �����
: Line ( x y x1 y1 -> )
	2SWAP MoveTo Draw ;

\ ���ᮢ��� ���
: Circle ( x y d -> )
	>R SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc Ellipse DROP ;

\ ���ᮢ��� ���
: Ellips ( x y x1 y1 -> )
	SWAP 2SWAP SWAP phdc Ellipse DROP ;

\ ���ᮢ��� ������
: Square ( x y l -> )
	>R SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc Rectangle DROP ;

\ ���ᮢ��� ��אַ㣮�쭨�
: Rect ( x y x1 y1 -> )
         SWAP 2SWAP SWAP phdc Rectangle DROP ;

\ ���ᮢ��� ��אַ㣮�쭨� c ��㣫���묨 ���栬�
: RRect ( x y x1 y1 ll lh -> )
         SWAP 2SWAP SWAP 2>R 2SWAP SWAP 2R> 2SWAP phdc RoundRect DROP ;

\ ���ᮢ��� ������  c ��㣫���묨 ���栬�
: RSquare ( x y l ll lh-> )
	SWAP 2SWAP >R -ROT 2SWAP SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc RoundRect DROP ;

\ �뢥�� ����ࠦ���� bmp �� 䠩�� �� ���᮫�
: Image ( addr u x y -> )
	{ x y | hbitmap bhdc pbhdc }
	DROP >R 0x10 0 0 0 R> hwdwin LoadImageA TO hbitmap
	bitmap 24 hbitmap GetObjectA DROP
	phdc CreateCompatibleDC TO bhdc
	hbitmap bhdc SelectObject TO pbhdc
	0xCC0020 bitmap bmHeight @ bitmap bmWidth @ 0 0 bhdc
	bitmap bmHeight @ bitmap bmWidth @ y x phdc StretchBlt DROP
	hbitmap DeleteObject DROP
	bhdc DeleteDC DROP ;

\EOF

Point		( x y -> ) - ���ᮢ��� ���
MoveTo		( x y -> ) - ��६�頥� ��� ��砫� �ᮢ���� ��� Draw
Draw		( x y -> ) - ���� ����� �� ⥪�� �窨 �ᮢ����
Line		( x y x1 y1 -> ) - ���ᮢ��� �����
Square		( x y l -> ) - ���ᮢ��� ������
Rect 		( x y x1 y1 -> ) - ���ᮢ��� ��אַ㣮�쭨�
Ellips		( x y x1 y1 -> ) - ���ᮢ��� ���
Circle		( x y d -> ) - ���ᮢ��� ���
RRect		( x y x1 y1 h l -> ) - ���ᮢ��� ��אַ㣮�쭨� c ��㣫���묨 ���栬�
RSquare		( x y l ll lh-> ) - ���ᮢ��� ������  c ��㣫���묨 ���栬�
Image		( addr u x y -> ) - �뢥�� ����ࠦ���� bmp �� 䠩�� �� ���᮫�
