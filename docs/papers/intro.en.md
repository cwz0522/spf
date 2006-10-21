<a id="start"/>

SPF peculiarities
=================

<title>SPF peculiarities</title>

<i>A short introduction, for those already familiar with some
Forth-system and ANS'94 standard.</i>

<small>Last update: $Date$</small>

<!-- Translated from intro.md (rev. 1.13) -->

----

##Contents

* [Installed SPF4. And whats next?](#devel)
* [Optimizer](#opt)
* [ANS support](#ans)
* [How to run and include forth code?](#include)
* [REQUIRE](#require)
* [Modules](#module)
* [Case sensitivity](#case)
* [Inputing numbers](#numbers)
* [Structures, records](#struct)
* [Where is FORGET?](#forget)
* [How to clear the stack with one word?](#cls)
* [Debugging facilities](#debug)
* [Comments](#comments)
* [Strings](#string)
* [Creating executable modules](#save)
* [Local and temporary variables](#locals)
* [Using extrnal DLLs](#dll)
* [NOTFOUND](#notfound)
* [Scattered colons](#scatcoln)
* [Multitasking](#task)
* [Vocabularies](#voc)

----
<a id="devel"/>
###[Installed SPF4. And whats next?][start]

The first and the most important thing - placement of your working files. In
the SPF directory there is a subdir DEVEL for the developers' code (including
yours). Create a subdir there, for example ~john. Now you can refer to your files
in short form, `~john\prog\myprog.f`. Thus, the mutual access to contributed
code is simplified. The general adopted convention is to place libraries in
the subdirectory named lib, and example programs in prog.

The devel directory contains the contributed code of other SP-Forth'ers, the
short(very short) list is available online:
<http://wiki.forth.org.ru/SPF_DEVEL>, or you can scan the directory yourself.


----
<a id="opt"/>
###[Optimizer][start]

SPF uses the subroutine threaded code, i.e. the compiled code looks like the
chains of `CALL <word-cfa-address>`. This code can be ran directly, but by
default it is processed with the optimizer to gain a speedup at runtime. It
performs inlining and peephole-optimization. More on ForthWiki (in russian):
"[Optimizing compiler](http://wiki.forth.org.ru/optimizer)".

**NB**: If suddenly your program fails to compile or behaves strangely, try to
temporarily turn off the optimizer using `DIS-OPT` (turn on with `SET-OPT`),
maybe (unlikely!) it is a bug in the optimizer. If so - cut the piece of code
where it occurs and send to the author.

You can observer the result of the word compilation as a native code with a
disassembler:

	REQUIRE SEE lib/ext/disasm.f
	SEE word-in-interest

or get the line-by-line listing

	REQUIRE INCLUDED_L ~mak/listing2.f
	S" file, with the code in interest"  INCLUDED_L
	\ the listing will be places in the file near to the file included


----
<a id="ans"/>
###[ANS support][start]

Maximum ANS conformity is achieved by including `lib/include/ansi.f`.
Additional words are defined, some of them dummies, etc. Also, a tricky
behaviour of the FILE words is corrected - `OPEN-FILE`, `CREATE-FILE` and
other such words implicitly treat the input string as zero-ended (ignoring the
length parameter), though according to the standard it is a string buffer with
the counter on the stack.

----
<a id="include"/>
###[How to run and include forth code?][start]

Running the file from the command line is fairly simple, just provide it's path as
a parameter for SPF, 

	spf.exe ~john/prog/myprog.f
Note, that include path can be either absolute or relative to the
[devel](#devel) directory. 

In SPF console (interpretation mode) just type in the name of the file:

	~john/prog/myprog.f
For the compatibility reasons, it is better to include it in a standard way:

	S" ~vasya/prog/myprog.f" INCLUDED

But the recommended approach is to use `REQUIRE` word.


----
<a id="require"/>
###[REQUIRE][start]

SPF has a non-standard word `REQUIRE ("word" "file" -- )`, where `word` should
be the one defined in `file`. If this word is already present in the 
system, `REQUIRE` will consider the library already loaded. In this way, the
duplicated loading of libraries is avoided.
For example:

	REQUIRE CreateSocket ~ac/lib/win/winsock/sockets.f
	REQUIRE ForEach-Word ~pinka/lib/words.f
	REQUIRE ENUM ~nn/lib/enum.f



----
<a id="module"/>
###[Modules][start]

� SPF ���� ������, ������� ��������� �������� ��������� ���������� �����
��������� ������ ������ ������ ����� ��� ��������������.

	MODULE: vasya-lib
	\ ���������� �����
	EXPORT
	\ ����� ��������������, ������ �������, ������������� �� ������� �������.
	DEFINITIONS
	\ ����� ���������� �����
	EXPORT
	\ �� �� ������ :)
	;MODULE
��� `MODULE: vasya-lib` ����� ������ ����� ��� - ����������� ������ �����
��������������� ����� � ��� �� ������. �� ����� ���� ����� ����������� �����
`MODULE:` ��� ������� [�������](#voc).


----
<a id="case"/>
###[Case sensitivity][start]

SPF ���������������, �� ���� � ���� ������ ��� ���� ����� `CHAR` , `Char` � `char` -
��� ������ �����. ���� ����� ����� ��������� ������������ �����
`lib/ext/caseins.f`.



----
<a id="numbers"/>
###[Inputing numbers][start]

SPF ��������� ������� ����������������� ����� ��� ����������� �� ������� �������
��������� (�������� ���������� `BASE`) ���:
 
	0x7FFFFFFF
������������ ����� ����� ������� � ������� `[+|-][dddd][.][dddd]e[+|-][dddd]`
��������� ���� `lib\include\float2.f`.


----
<a id="struct"/>
###[Structures, records][start]

��������� � SPF ��������� ����� ����� `--` (��� �� `FIELD`). ������:

	0
	CHAR -- flag
	CELL -- field
	10 CELLS -- arr
	CONSTANT struct

����� `flag`, `field` � `arr` ����� ���������� � ������ ��� �������� 
������������ ������ ���������. � � `struct` ������� ����� ������
���� ���������. �� ����, �����:

	struct ALLOCATE THROW TO s \ ����� ������ �� ���� ��� ���� ��������� struct
	1 s flag �!  10 s field ! \ �������� �������� � ���� ���������
	s arr 10 CELLS DUMP \ ������ ���������� ������� � ���������
	s FREE THROW \ ����� ��������� struct

��������� ����� �����������:

	0
	CELL -- x
	CELL -- y
	CONSTANT point \ � point ��� ����
	
	point
	CELL -- radius
	CONSTANT circle \ � circle ��� ����: x, y, radius
	
	point
	CELL -- w
	CELL -- h
	CONSTANT rect \ � rect ������ ����: x, y, w, h

----
<a id="forget"/>
###[Where is FORGET?][start]

`FORGET` ���. �� ���� `MARKER ( "name" -- )` (� `lib\include\core-ext.f` ��� � `~clf/marker.f`).



----
<a id="cls"/>
###[How to clear the stack with one word?][start]

�������� `lalala`. ��� `bububu`. ��� `����������`. ��������� ������ � ���� ���������.
�� ����� ���� ���� ������� ����� `ABORT`, ������� ����� ������� ���� �������������
�� ����� �������� �����. �� � �� �����-����� ���� - ��� �������� ���: `S0 @ SP!`

__� FAQ__


----
<a id="debug"/>
###[Debugging facilities][start]

����� `STARTLOG` �������� ������ ����� ����������� ������ � ���-����
`spf.log` � ������� �����. `ENDLOG` �������������� ��������� ����� ���������.


__���������!__


----
<a id="comments"/>
###[Comments][start]

� SPF ���� ����������� �� ����� ������ ` \ `. ���� � �������, ���������, �����������,
������� � ���� �� ��� � �������������. �� ����:

	\ ����������� �� ����� ������
	( �����������
	� ���� � ��������� ����� )
���� ����� `\EOF` ������� ������ ������������ �� ������ ����� ���� � �����. �����
������� ������ �������� ������� ������������� ���������� �� ����� ����������.

	word1 word2
	\EOF
	����������� �� ����� �����



----
<a id="string"/>
###[Strings][start]

� SPF � �������� ������������ ������ �� ��������� �� ����� - �.�. ��� ��������
`(addr u)`. ��� ������ ��������� ��������� (��������� ��������) ������������
����� `S"`, ������� � ����������� �� �������� ������ ��������� ��������� ������
��������:

* � ������ ������������� ������ ��������� �� ��������� ��������� ������ ������� (`TIB`),
� ��������������, �������� ������ � �������� ����� ������.

* � ������ ���������� ������ �������������� ��������������� � ����� ��� ������������� �����.

��� �������� ������ � WinAPI � ����� ����� ����������� ��������������, �����������
������� ����.

����� `S"` ������ �. �. ����������� ������, ��� ��������� ��� � ������, ��� � ���������
��������� SPF. ��� ������ �� ������������� ��������, ������� ������������� � "����" � ���������
������ ���� ���������� `~ac\lib\str4.f`. ������ � �������������:

	REQUIRE STR@ ~ac/lib/str4.f
	"" VALUE r \ ������ ������ ������
	" ����, ����, " VALUE m
	" ��� � ���� ������?" VALUE w
	m r S+  w r S+
	r STYPE
	> ����, ����, ��� � ���� ������?

����� ������������ ����� ����� ������������ � ����������� (� ��� ����� � ������ �����):

	" 2+2={2 2 +}" STYPE
	> 2+2=4

������������� �������� � ����� ��������� ������� ��. � ����� ����������.

���� ����� �������� ��� � SPF �������������� ������� ���� `S-` � ��������� `-ED`.

`S-` �������� ��� ����� �������� �� �������� �� ��������� (�������� ����
`SFIND` � ���� ����������� `FIND`, ���� `SLITERAL` � `LITERAL`).

`-ED` ���� � ������ `CREATED`, `INCLUDED`, `REQUIRED`, `ALIGNED`. �� ���������� ��� ���
�����, � ������� �� ������ "�����", ����� ������� ���������� �� �����, � �� ����� ��� ��
�������� ������ (��� �� ���������� ����������, ��� � ������ � `ALIGN` � `ALIGNED`).

��������, ����������� `CREATE` ���� ���� �������� �� �������� ������, ����� ��� `CREATED`
���� �������� �������� �� ����� ������ � ���� ������ ������ � � �����.

----
<a id="save"/>
###[Producing executable modules][start]

����� `SAVE ( a u -- )` ��������� ��� ����-�������, ������� ��� ���������
��������� (����� ���������!) � ����������� ������ ���� � �������� �������
������� `a u`. ����� ����� ������������ value-���������� `<MAIN>` ���
����������� ������ � ���������� `MAINX` ��� GUI. ����� ������������
value-����������� `?CONSOLE` � `?GUI`. `SPF-INIT?` ������������� �������������
���������� ������ � ����������� spf4.ini:

	0 TO SPF-INIT?
	' ANSI>OEM TO ANSI><OEM
	TRUE TO ?GUI
	' NOOP TO <MAIN>
	' run MAINX !
	S" gui.exe" SAVE  

���

    ' run TO <MAIN>
	S" console.exe" SAVE


----
<a id="locals"/>
###[Local and temporary variables][start]

�� ������ � ����, �� ������������:

	REQUIRE { lib/ext/locals.f
	
	\ ������ �������� �������������
	: test { a b | c d }  \ a b ��������������� �� �����, c � d ������
	  a -> c
	  b TO d
	  c . d . ;
	1 2 test
	>1 2
	> Ok
��������� �������� � ������� ������������� �������� � ����� ����������.



----
<a id="dll"/>
###[Using external DLLs][start]

������:

	WINAPI: SevenZip 7-zip32.dll
���� ����� ���������� ��� ������� �� dll-����� �� ����� ������������
����:

	REQUIRE UseDLL ~nn/lib/usedll.f
	UseDLL "���_����������"

���:

	REQUIRE DLL ~ac/lib/ns/dll-xt.f
	DLL NEW: "���_����������" 

----
<a id="notfound"/>
###[NOTFOUND][start]

���� �� ����� ����� `INTERPRET` �� �����
������� ��������� ����� �� �������� ������ - � ������� ������� ������ �
���������� ����� `NOTFOUND ( a u -- )`. ���� `NOTFOUND` �� ������������ ������
����� - �� ������ ���������� � �����������. ����� ���������, ��� �����
���������� � ���������� ������������. �� ��������� ����� `NOTFOUND` �����������
������������� �����, � ������ � ��������� �������� � ����:

	vocname1:: wordname

������� �������� ���� - ��� ��������������� `NOTFOUND` ������� ������� ���
������ �������, � ���� �� �� ��������� �� ���������� - ��������� ����
��������. ������:

	 : MY? ( a u -- ? ) S" !!" SEARCH >R 2DROP R> ;
	 : DO-MY ( a u -- ) ." My NOTFOUND: " TYPE CR ;

	 : NOTFOUND ( a u -- )
	   2DUP 2>R ['] NOTFOUND CATCH 
	   IF
	     2DROP
	     2R@ MY? IF 2R@ DO-MY ELSE -2003 THROW THEN
	   THEN
	   RDROP RDROP
	   ;
��� ���:

	 : NOTFOUND ( a u -- )
	   2DUP MY? IF DO-MY EXIT THEN
	   ( a u )
	   NOTFOUND
	   ;


----
<a id="scatcoln"/>
###[Scattered colons][start]

����������� ����� (�������� �������: "[Scattering a Colon Definition][scatter]", �� ���������� �����). 
��������� ��� ����� ����������� ����� ��������� � ���� ����� ��������.

	: INIT ... do1 ; 
	\ ���� ������� INIT ����� �� ���������� do1
	..: INIT do2 ;.. 
	\ ���� ����� - �� do1 � do2 ������ � ����� �������
	..: INIT do3 ;.. 
	\ � ��� �����

��������� ������� ����� �������� � � ������� ��������, �� ��� ������� �������.

����� scattered colons � SPF ����������� ����� `AT-THREAD-STARTING` �
`AT-PROCESS-STARTING`, ������� ���������� ��� ������ ������ � ��� ������
�������� ��������������. �������� ���������� `lib\include\float2.f` ��������� �
`AT-THREAD-STARTING` �������� �� ������������� ���������� ����������.

[scatter]: http://www.forth.org.ru/~mlg/ScatColn/ScatteredColonDef.html

----
<a id="task"/>
###[Multitasking][start]

������ ��������� ������ `TASK: ( xt -- task)` � ����������� ������ 
`START ( u task -- tid )`, 
`xt` ��� ���������� ����� ������� ������� ���������� ��� ������ ������ �
�� ����� ����� ���������������� �������� `u`. ������������ �������� `tid`
������������ ��� ��������� ������ ������� ������ `STOP ( tid -- )`.
������������� ����� �� �������� ����� ����� ������ `PAUSE ( ms -- )`.
������:

	REQUIRE { lib/ext/locals.f

	:NONAME { u \ -- }
	   BEGIN
	   u .
	   u 10 * 100 + PAUSE
	  AGAIN
	; TASK: thread
	
	: go
	  10 0 DO I thread START LOOP
	  2000 PAUSE
	  ( tid1 tid2 ... tid10 )
	  10 0 DO STOP LOOP
	;

	go

������� ���������� (`VARIABLE`, `VALUE`) ����� ��������� ��� �������� �����
��������. ���� �� ���������� ������ ���� ��������� ��� ������ - �������
���������� � ������ `USER ( "name" -- )` ��� `USER-VALUE ( "name" -- )`.
USER-���������� ��� ������ ������ ���������������� ����.


----
<a id="voc"/>
###[Vocabularies][start]

������� ��������� ���� ����������� `VOCABULARY ( "name" -- )` 
���� ������ `WORDLIST ( -- wid )`. 
������, `WORDLIST` ��� ����� ����� ������� - ������ ������ ����. ����
����� ����� `TEMP-WORDLIST ( -- wid)` ��������� ��������� �������, ������� ��
��������� ������ ���� ���������� �� ������ ������ `FREE-WORDLIST`, ����������
���������� ������� �� ������ � ����� ������� ��� ������������� ����� `SAVE`.
����� `{{ ( "name" -- )` ������� ������� name �����������, � ����� `}}` ����� ���
����. ������:

	MODULE: my
	: + * ;
	;MODULE
	{{ my 2 3 + . }}
���������� 6, � �� 5.


[start]: #start

----
----

<title>����������� SPF</title>