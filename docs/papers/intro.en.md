<a id="start"/>

SPF peculiarities
=================

<title>SPF peculiarities</title>

<i>A short introduction, for those already familiar with some
Forth-system and ANS'94 standard.</i>

<small>Last update: $Date$</small>

<!-- Translated from intro.md (rev. 1.14) -->

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

SPF has modules, which hide the internal implementation and leave visible the
words of the outer interface.

	MODULE: john-lib
	\ inner words
	EXPORT
    \ interface words, compiled to the outer vocabulary, thus seen from the external world
	DEFINITIONS
	\ inner words again
	EXPORT
	\ you get the idea :)
	;MODULE
You can write `MODULE: john-lib` several times - all the consequent code will
compile to the existing module, not overwriting it. Actually, the word defined
by `MODULE:` is a simple [vocabulary](#voc).


----
<a id="case"/>
###[Case sensitivity][start]

SPF is case-sensitive, i.e. the words `CHAR`, `Char` and `char` are different
words. Switching to case-insensitive mode is as simple as including file
`lib/ext/caseins.f`. 


----
<a id="numbers"/>
###[Inputing numbers][start]

You can input the hexadecimal numbers at any time not depending on the current
BASE in the following manner:
 
	0x7FFFFFFF
Flaot numbers are recognized in form `[+|-][dddd][.][dddd]e[+|-][dddd]` after
including `lib\include\float2.f`.


----
<a id="struct"/>
###[Structures, records][start]

Records are created with the `--` word (the same as `FIELD`). Example:

	0
	CHAR -- flag
	CELL -- field
	10 CELLS -- arr
	CONSTANT struct

The words `flag`, `field` � `arr` will add their offset to the address on the
stack when executed. and the `struct` constant contains the size of the whole
structure. Consider:

    struct ALLOCATE THROW TO s \ requested memory from heap for the single struct instance
	1 s flag �!  10 s field ! \ set the struct fields' values
	s arr 10 CELLS DUMP \ output the contents of the array in struct
	s FREE THROW \ free memory

Structures can be inherited:

	0
	CELL -- x
	CELL -- y
	CONSTANT point \ point owns two fields
	
	point
	CELL -- radius
	CONSTANT circle \ circle owns: x, y, radius
	
	point
	CELL -- w
	CELL -- h
	CONSTANT rect \ rect owns: x, y, w, h

----
<a id="forget"/>
###[Where is FORGET?][start]

No `FORGET`. But we have `MARKER ( "name" -- )` (use `lib\include\core-ext.f`).


----
<a id="cls"/>
###[How to clear the stack with one word?][start]

Input `lalala`. Or `bububu`. Error occurs and the stack is cleared. Actually,
the stack is emptied with `ABORT`, which is called when the interpreter cant
find the word. And the proper way to clear stack is: `S0 @ SP!`

__To FAQ__


----
<a id="debug"/>
###[Debugging facilities][start]

`STARTLOG` starts the logging of all console output to the `spf.log` file in
the current directory. `ENDLOG`, respectively, stops such behaviour.


__Need more!__


----
<a id="comments"/>
###[Comments][start]

Cooments to the end of line are ` \ `. There are also bracket-comments, which
are multiline. So:

	\ comment till the eol
	( comment
	and here too )
The word `\EOF` comments out everything till the end of file. It is useful to
separate the library code from testing or examples of usage at the end of same
file.

	word1 word2
	\EOF
	comment till eof


----
<a id="string"/>
###[Strings][start]

SPF � �������� ������������ ������ �� ��������� �� ����� - �.�. ��� ��������
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

`SAVE ( a u -- )` will save the whole system, including all the wordlists
(except temporary ones!) to the executable file, with the path specified with
as `a u`. Entry point is set with VALUE `<MAIN>` for the console mode and
VARIABLE `MAINX`  for GUI. The mode itself is defined with either `?CONSOLE`
or `?GUI`. `SPF-INIT?` controls interpretation of the command-line and
auto-including spf4.ini:

	0 TO SPF-INIT?
	' ANSI>OEM TO ANSI><OEM
	TRUE TO ?GUI
	' NOOP TO <MAIN>
	' run MAINX !
	S" gui.exe" SAVE  

or

    ' run TO <MAIN>
	S" console.exe" SAVE


----
<a id="locals"/>
###[Local and temporary variables][start]

Not available in the kernel, but included.

	REQUIRE { lib/ext/locals.f
	
	\ sample usage
    : test { a b | c d }  \ a b get their values from the stack, c and d are zeroes
	  a -> c
	  b TO d
	  c . d . ;
	1 2 test
	>1 2
	> Ok
Full description and more examples available in the library itself.


----
<a id="dll"/>
###[Using external DLLs][start]

Example:

	WINAPI: SevenZip 7-zip32.dll
If you need to automatically use all dll exported functions as forth words,
use either:

	REQUIRE UseDLL ~nn/lib/usedll.f
	UseDLL "DLL name"

or:

	REQUIRE DLL ~ac/lib/ns/dll-xt.f
	DLL NEW: "DLL name" 

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
