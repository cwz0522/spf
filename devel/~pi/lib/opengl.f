\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   OpenGl for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ��� ࠡ��� � opengl v0.01
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|
\ -----------------------------------------------------------------------------
S" lib\include\float2.f" INCLUDED
MODULE: HIDDEN

WINAPI: CreateWindowExA		USER32.DLL
WINAPI: GetSystemMetrics	USER32.DLL
WINAPI: GetDC			USER32.DLL
WINAPI: ReleaseDC		USER32.DLL
WINAPI: ShowCursor		USER32.DLL
WINAPI: GetAsyncKeyState	USER32.DLL

WINAPI: ChoosePixelFormat	GDI32.DLL
WINAPI: SetPixelFormat		GDI32.DLL
WINAPI: SwapBuffers		GDI32.DLL

WINAPI: wglCreateContext	OPENGL32.DLL
WINAPI: wglMakeCurrent		OPENGL32.DLL
WINAPI: glHint			OPENGL32.DLL
WINAPI: glMatrixMode		OPENGL32.DLL
WINAPI: glClear			OPENGL32.DLL
WINAPI: glLoadIdentity		OPENGL32.DLL
WINAPI: glTranslated		OPENGL32.DLL
WINAPI: glPointSize		OPENGL32.DLL
WINAPI: glBegin			OPENGL32.DLL
WINAPI:	glVertex2d		OPENGL32.DLL
WINAPI:	glEnd			OPENGL32.DLL
WINAPI: glColor3b		OPENGL32.DLL
WINAPI: glRotated		OPENGL32.DLL
WINAPI: glLineWidth		OPENGL32.DLL
WINAPI: glPolygonMode		OPENGL32.DLL
WINAPI: glEnable		OPENGL32.DLL
WINAPI: glDisable		OPENGL32.DLL

WINAPI: gluPerspective		GLU32.DLL

0
2 -- nSize
2 -- nVersion
CELL -- dwFlags
1 -- iPixelType
1 -- cColorBits
1 -- cRedBits
1 -- cRedShift
1 -- cGreenBits
1 -- cGreenShift
1 -- cBlueBits
1 -- cBlueShift
1 -- cAlphaBits
1 -- cAlphaShift
1 -- cAccumBits
1 -- cAccumRedBits
1 -- cAccumGreenBits
1 -- cAccumBlueBits
1 -- cAccumAlphaBits
1 -- cDepthBits
1 -- cStencilBits
1 -- cAuxBuffers
1 -- iLayerType
1 -- bReserved
CELL -- dwLayerMask
CELL -- dwVisibleMask
CELL -- dwDamageMask
CONSTANT PIXELFORMATDESCRIPTOR
0 VALUE pfd		\ ������� ��� opengl
PIXELFORMATDESCRIPTOR ALLOCATE THROW TO pfd
0x25 pfd dwFlags !
32 pfd cColorBits C! 
pfd FREE THROW

0 VALUE glhandle	\ 奭�� ����
0 VALUE glhdc		\ 奭�� ���⥪��


EXPORT

\ ���� ����ࠦ���� �࠭� � ���ᥫ��
: VScreen ( -> n )
	1 GetSystemMetrics ;

\ ��ਭ� ����ࠦ���� �࠭� � ���ᥫ��
: HScreen ( -> n )
	0 GetSystemMetrics ;

\ ��᫮ float � �⥪� float �� �⥪ ������
: F>FL  ( -> f ) ( F: f -> )
	[                 
	0x8D C, 0x6D C, 0xFC C, 
	0xD9 C, 0x5D C, 0x00 C, 
	0x87 C, 0x45 C, 0x00 C, 
	0xC3 C, ] ;

\ ��᫮ double � �⥪� float �� �⥪ ������
: F>DL ( -> d ) ( F: f -> )
	FLOAT>DATA SWAP ;

\ ��४������஢��� �᫮ �� �⥪� �� float
: S>FL ( n -> f )
	DS>F F>FL ;

\ ��४������஢��� �᫮ �� �⥪� � double
: S>DL ( n -> d )
	DS>F F>DL ;

\ �ᯥ�� ᮮ⭮襭�� �ਭ� � �����
: AScreen ( -> d )
	HScreen DS>F VScreen S>D D>F F/ F>DL ;

\ �������� ����� �� �࠭�
: ShowCursore ( -> )
	1 ShowCursor DROP ;

\ ������� ����� c �࠭�
: HideCursore ( -> )
	0 ShowCursor DROP ;

\ ��室
: glClose ( -> )
	glhdc glhandle ReleaseDC 0 ExitProcess ;

\ �஢���� ����� �� ������ �� ��������� ����
: key ( n -- flag )
	GetAsyncKeyState ;

\ ���樠������ gl����
: glOpen ( -> )
 0 0 0 0 VScreen HScreen 0 0 0x90000000 S" edit" DROP DUP 8 CreateWindowExA
 DUP TO glhandle GetDC TO glhdc
 pfd DUP glhdc ChoosePixelFormat glhdc SetPixelFormat DROP
 glhdc wglCreateContext glhdc wglMakeCurrent DROP
 0x1102 0xC50 glHint DROP
 0x1701 glMatrixMode DROP
 100 S>DL 1 DS>F 10 DS>F F/ F>DL AScreen 90 S>DL gluPerspective DROP
 0x1700 glMatrixMode DROP ;

\ ������ ���� ����ࠦ����
: Cls ( -> )
	0x4000 glClear DROP ;

\ ����� ���� ����ࠦ���� (��� �ᮢ���)
: View ( -> )
	glhdc SwapBuffers DROP ;

\ �����筠� �����
: SingleMatrix ( -> )
	glLoadIdentity DROP ;

\ �믮���� ᤢ�� ⥪�饩 ������ �� ����� (x, y, z).
: ShiftMatrix ( F: f f f -> )
	F>DL F>DL F>DL glTranslated DROP ;

\ ������ �窨
: PointSize ( n -> )
	S>FL glPointSize DROP ;

\ �뢥�� 2D ��� �� �࠭ (x,y)
: Point ( F: f f -> )
	0 glBegin DROP F>DL F>DL glVertex2d DROP glEnd DROP ;

\ ��⠭����� 梥� (B G R)
: Color ( n n n -> )
	glColor3b DROP ;

\ �����稢��� ⥪���� ������ �� ������� 㣮� ����� ��������� �����.
\ z y x angle
: RotatedMatrix ( F: f f f f -> )
	F>DL F>DL F>DL F>DL glRotated DROP ;

\ �뢥�� 2D ����� (X Y L H)
: Line ( F: f f f f -> )
	1 glBegin DROP
	F>DL F>DL glVertex2d DROP
	F>DL F>DL glVertex2d DROP
	glEnd DROP ;

\ ��ਭ� �����
: LineSize ( n -> )
	S>FL glLineWidth DROP ;

\ �뢥�� 2D ��㣮�쭨� (X Y X1 Y1 X2 Y2)
: Triangle ( F: f f f f f f -> )
	4 glBegin DROP
	F>DL F>DL glVertex2d DROP
	F>DL F>DL glVertex2d DROP
	F>DL F>DL glVertex2d DROP
	glEnd DROP ;

\ ��ᮢ���� 䨣�� �஢����� �⨫��
: GlLine ( -> )
	0x1B01 0x408 glPolygonMode DROP ;

\ ��ᮢ���� 䨣�� ����襭�� �⨫��
: GlFill ( -> )
	0x1B02 0x408 glPolygonMode DROP ;

\ 2D ��אַ㣮�쭨� (X Y L H)
: Rectangle ( F: f f f f -> )
	7 glBegin DROP
	F>DL 2DUP F>DL 2DUP 2>R glVertex2d DROP
	F>DL 2DUP 2R> glVertex2d DROP
	F>DL 2DUP 2>R glVertex2d DROP
	2R> glVertex2d DROP
	glEnd DROP ;

\ �����������
: Smoothing ( -> )
	0xB10 glEnable DROP ;

\ ����� ᣫ��������
: NoSmoothing ( -> )
	0xB10 glDisable DROP ;


STARTLOG

;MODULE

0 VALUE msec					\ ��� ᨭ�࠭���樨
0 VALUE msei
0.0E FVALUE theta				\ 㣮� ������ ������
: main
 glOpen						\ ���樠������ opengl
 GlLine						\ ��㥬 �஢����� �⨫��
 Smoothing					\ ᣫ�������� �祪
 HideCursore					\ ������ �����
 0x1B key DROP					\ ��������� �� ���� ��ࠡ�⠥�
 BEGIN
  TIMER@ DROP TO msei				\ ᨭ�஭�����
  msei msec <> IF
   msei TO msec
   Cls						\ ���⪠ �࠭�
   SingleMatrix					\ ��⠭���� �������� ������
   0.0E 0.0E -5.0E ShiftMatrix			\ �⮤������ ������
   10 PointSize					\ ࠧ��� �窨
   theta 0.0E 0.0E 1.0E RotatedMatrix           \ ���⨬ ������ ����� �ᥩ
   0 0 100 Color				\ ��⠭���� ���� 梥�
   0.0E 0.0E Point				\ ����㥬 �窨
   0.0E 1.0E Point
   0.0E 2.0E Point
   0.0E 3.0E Point
   0.0E 4.0E Point
   0 100 0 Color				\ ��⠭���� ������ 梥�
   3 LineSize                                   \ �ਭ� �����
   0.0E 0.0E 4.0E 0.0E Line                     \ ����㥬 �����
   100 0 0 Color				\ ��⠭���� ᨭ�� 梥�
   0.0E 0.0E 0.5E 2.0E 2.0E 1.5E Triangle
   -4.0E 4.0E -1.0E -2.0E Rectangle
   View						\ ������� �� ���ᮢ���
   theta 0.5E F+ FTO theta
  THEN
 0x1B key UNTIL					\ 横� ���� �� ����� ESC
 glClose					\ ����뢠�� opengl �ਫ������
;

main


\EOF

glOpen		( -> ) - ���樠������ gl����
glClose		( -> ) - ��室
key		( n -> flag ) - ����� �� ������ �� ��������� ����

--- ��࠭ ---
VScreen		( -> n ) - ���� ����ࠦ���� �࠭� � ���ᥫ��
HScreen		( -> n ) - �ਭ� ����ࠦ���� �࠭� � ���ᥫ��
AScreen		( -> d ) - �ᯥ�� ᮮ⭮襭�� �ਭ� � �����
ShowCursore	( -> ) - �������� ����� �� �࠭�
HideCursore	( -> ) - ������ ����� c �࠭�
Cls		( -> ) - ������ ���� ����ࠦ����
View		( -> ) - ����� ���� ����ࠦ���� (��� �ᮢ���)
SingleMatrix	( -> ) - �����筠� �����
ShiftMatrix	( F: f f f -> ) - �믮���� ᤢ�� ⥪�饩 ������ �� �����
				(x, y, z).
RotatedMatrix	( F: f f f f -> ) - �����稢��� ⥪���� ������ �� ������� 㣮�
				����� ��������� ����� z y x angle.

--- float ---
F>FL		( -> f ) (F: f -- ) - �᫮ float � �⥪� float �� �⥪ ������
S>FL		( n -> f ) - ��४������஢��� �᫮ �� �⥪� �� float
F>DL		( -> d ) ( F: f -> ) - �᫮ double � �⥪� float �� �⥪ ������
S>DL		( n -> d ) - ��४������஢��� �᫮ �� �⥪� � double

--- �������� ---

Point		( F: f f -> ) - 2D �窠 �� �࠭ (x,y)
Line		( F: f f f f -> ) - 2D ����� (x,y,l,h)
Triangle	( F: f f f f f f -> ) - 2D ��㣮�쭨� (X Y X1 Y1 X2 Y2)
Rectangle	( F: f f f f -> ) - 2D ��אַ㣮�쭨� (X Y L H)

--- �����⢠ ����⮢ ---
Color		( n n n -> ) - ��⠭����� 梥� (B G R)
PointSize	( n -> ) - ࠧ��� �窨
GlLine		( -> ) - �ᮢ���� 䨣�� �஢����� �⨫��
GlFill		( -> ) - �ᮢ���� 䨣�� ����襭�� �⨫��
Smoothing	( -> ) - ᣫ��������
NoSmoothing	( -> ) - ���� ᣫ��������

