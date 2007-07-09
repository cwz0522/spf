\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   graph for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ���������� ������ ������� �� ����. �������
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.2
\ -----------------------------------------------------------------------------
REQUIRE wincon	~pi/lib/wincon/wincon.f

WINAPI: SetPixel		GDI32.DLL
WINAPI: MoveToEx		GDI32.DLL
WINAPI: LineTo			GDI32.DLL
WINAPI: Ellipse			GDI32.DLL
WINAPI: RoundRect		GDI32.DLL

\ ���������� ����� ������ ��������� ��� Draw
: MoveTo ( x y -> )
	0 -ROT SWAP phdc MoveToEx DROP ;

\ ������ ����� �� ������ ����� ���������
: Draw ( x y -> )
	SWAP phdc LineTo DROP ;

\ ���������� �����
: Point ( x y -> )
	SWAP color -ROT phdc SetPixel DROP ;

\ ���������� �����
: Line ( x y x1 y1 -> )
	2SWAP MoveTo Draw ;

\ ���������� ����
: Circle ( x y d -> )
	>R SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc Ellipse DROP ;

\ ���������� �����
: Ellips ( x y x1 y1 -> )
	SWAP 2SWAP SWAP phdc Ellipse DROP ;

\ ���������� �������
: Square ( x y l -> )
	>R SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc Rectangle DROP ;

\ ���������� �������������
: Rect ( x y x1 y1 -> )
         SWAP 2SWAP SWAP phdc Rectangle DROP ;

\ ���������� ������������� c ����������� �������
: RRect ( x y x1 y1 ll lh -> )
         SWAP 2SWAP SWAP 2>R 2SWAP SWAP 2R> 2SWAP phdc RoundRect DROP ;

\ ���������� �������  c ����������� �������
: RSquare ( x y l ll lh-> )
	SWAP 2SWAP >R -ROT 2SWAP SWAP 2DUP R@ + SWAP R> + SWAP 2SWAP phdc RoundRect DROP ;


\EOF

Point		( x y -> ) - ���������� �����
MoveTo		( x y -> ) - ���������� ����� ������ ��������� ��� Draw
Draw		( x y -> ) - ������ ����� �� ������ ����� ���������
Line		( x y x1 y1 -> ) - ���������� �����
Square		( x y l -> ) - ���������� �������
Rect 		( x y x1 y1 -> ) - ���������� �������������
Ellips		( x y x1 y1 -> ) - ���������� �����
Circle		( x y d -> ) - ���������� ����
RRect		( x y x1 y1 h l -> ) - ���������� ������������� c ����������� �������
RSquare		( x y l ll lh-> ) - ���������� �������  c ����������� �������
