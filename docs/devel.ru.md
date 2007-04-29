[SP-Forth](readme.ru.html): �������������� ����������
=====================================================

<title>SP-Forth: �������������� ����������</title>

<small>$Date$</small>

<!-- $Revision$ -->

*REQUIRE ��� ����� ������������ ����, �� ������ ����������������, ��� ��� ����� ������������ ���� ������ ��� ���� ��� ��� ���������� ��� :)*

----

[[�������](devel.ru.html)] [[����������](devel.en.html)]

----

[[����](#net)] [[�������](#graph)] [[����������](#arc)] [[������� ������](#list)] [[������](#record)] [[��������� ������](#data)] [[���������� � �����](#sort-n-search)] [[Techniques](#techniques)] [[�������](#debug)] [[��������� �����](#random)] [[�������������� �������](#hash)] [[��� �������](#hash-func)] [[��������� ������� ����������](#compiletime-const)] [[Windows GUI](#WinGUI)] [[Windows COM](#WinCOM)] [[������(�������) Windows](#services)] [[���� � �����](#datetime)] [[���� ������](#db)] [[������](#threads)] [[������ � INI Windows](#ini-registry)] [[������](#str)] [[�����](#files)] [[XML](#xml)] [[OOP](#oop)] [[�������](#vocs)] [[������](#mem)] [[������](#misc)] 

----

<a id="net"/>
### \\ ���� 
* REQUIRE CreateSocket <a href='../devel/~ac/lib/win/winsock/sockets.f'>~ac/lib/win/winsock/sockets.f</a> \\ ������� ��������� TCP/IP 
* REQUIRE SslInit <a href='../devel/~ac/lib/win/winsock/ssl.f'>~ac/lib/win/winsock/ssl.f</a> \\ ������� ��������� SSL/TLS 
* REQUIRE SslClientSocket <a href='../devel/~ac/lib/win/winsock/sockets_ssl.f'>~ac/lib/win/winsock/sockets_ssl.f</a> \\ SSL/TLS-������ 
* REQUIRE SocketLine <a href='../devel/~ac/lib/win/winsock/socketline2.f'>~ac/lib/win/winsock/socketline2.f</a> \\ ���������� ���������������� ������ ������� 
* REQUIRE ReadFrom <a href='../devel/~ac/lib/win/winsock/sockname.f'>~ac/lib/win/winsock/sockname.f</a> \\ ������ � UDP 
* REQUIRE fsockopen <a href='../devel/~ac/lib/win/winsock/psocket.f'>~ac/lib/win/winsock/psocket.f</a> \\ ���������� ������ � �������� 
* REQUIRE ForEachIP <a href='../devel/~ac/lib/win/winsock/foreach_ip.f'>~ac/lib/win/winsock/foreach_ip.f</a> \\ ���������� ��������� �������� ��� ������� IP ����� 
* REQUIRE SendDnsQuery <a href='../devel/~ac/lib/win/winsock/dns_q.f'>~ac/lib/win/winsock/dns_q.f</a> \\ ������ � DNS-��������� 
* REQUIRE PutFileTr <a href='../devel/~ac/lib/win/winsock/transmit.f'>~ac/lib/win/winsock/transmit.f</a> \\ ��������� ���������������������� �������� ������ � Windows 
* REQUIRE SnmpInit <a href='../devel/~ac/lib/win/snmp/snmp.f'>~ac/lib/win/snmp/snmp.f</a> \\ ��������� SNMP 
* REQUIRE GET-FILE-VIAPROXY <a href='../devel/~ac/lib/lin/curl/curl.f'>~ac/lib/lin/curl/curl.f</a> \\ cURL-wrapper - ��������� ������/�������� �� HTTP/FTP/etc) 
* \\ ~nn/lib/net/ \\ HTTP, POP3, FTP, etc 

<a id="graph"/>
### \\ ������� 
* REQUIRE GLWindow <a href='../devel/~ygrek/lib/joopengl/GLWindow.f'>~ygrek/lib/joopengl/GLWindow.f</a> \\ <a href='http://wiki.forth.org.ru/OpenGL'>OpenGL</a> ������ joop 

<a id="arc"/>
### \\ ����������
* REQUIRE gzip_write <a href='../devel/~ac/lib/win/arc/gzip/zlib.f'>~ac/lib/win/arc/gzip/zlib.f</a> \\ �������� � ���������� GZip-�������������������
* REQUIRE zip-pack <a href='../devel/~profit/lib/7zip-dll.f'>~profit/lib/7zip-dll.f</a> \\ �������� � ���������� � zip/7zip ������

<a id="list"/>
### \\ ��������� ������ - ������ 
* REQUIRE ListNode <a href='../devel/~day/joop/lib/list.f'>~day/joop/lib/list.f</a> \\ ����������� ������ 
* REQUIRE AddNode <a href='../devel/~ac/lib/list/STR_LIST.f'>~ac/lib/list/STR_LIST.f</a> \\ ����������� ������ 
* REQUIRE LINK, <a href='../devel/~day/common/link.f'>~day/common/link.f</a> \\ ����������� ������ (���������� � ��������) 
* REQUIRE firstNode <a href='../devel/~day/lib/staticlist.f'>~day/lib/staticlist.f</a> \\ ����������� ������, ����� ���� 
* REQUIRE list+s <a href='../devel/~pinka/lib/list_ext.f'>~pinka/lib/list_ext.f</a> \\ ����������� ������ 
* REQUIRE cons <a href='../devel/~ygrek/lib/list/core.f'>~ygrek/lib/list/core.f</a> \\ ������ cons pair, ������� �����
* REQUIRE lst( <a href='../devel/~ygrek/lib/list/ext.f'>~ygrek/lib/list/ext.f</a> \\ ������� ������ � ���� lst( 1 % 2 % 3 % )lst
* REQUIRE reduce-this <a href='../devel/~ygrek/lib/list/more.f'>~ygrek/lib/list/more.f</a> \\ �������������� �������� ��� ������� - reduce, equal?, list-remove-dublicates
* REQUIRE write-list <a href='../devel/~ygrek/lib/list/write.f'>~ygrek/lib/list/write.f</a> \\ ���������� ������, ������� ������������ ��������� ��� ������������ EVALUATE
* REQUIRE write-list <a href='../devel/~ygrek/lib/list/all.f'>~ygrek/lib/list/all.f</a> \\ ��� ���� ��� cons pair �������

<a id="record"/>
### \\ ��������� ������ - ������ 
* REQUIRE STRUCT: <a href='../lib/ext/struct.f'>lib/ext/struct.f</a> \\ ������� ���������(������) 
* REQUIRE f: <a href='../devel/~af/lib/struct.f'>~af/lib/struct.f</a> \\ ���������� ��������, ���������� ��������-������� 
* REQUIRE f: <a href='../devel/~af/lib/struct-t.f'>~af/lib/struct-t.f</a> \\ ���������� ��������, ���������� ��������-�������, �� ��������� ������� 

<a id="data"/>
### \\ ��������� ������ - ������ 
* REQUIRE Stack <a href='../devel/~day/joop/lib/stack.f'>~day/joop/lib/stack.f</a> \\ ���� 
* REQUIRE New-Queue <a href='../devel/~pinka/lib/queue_pr.f'>~pinka/lib/queue_pr.f</a> \\ ������� � ������������ 
* REQUIRE x.mask <a href='../devel/~mlg/SrcLib/bitfield.f'>~mlg/SrcLib/bitfield.f</a> \\ ������� ���������
* REQUIRE RATIO <a href='../devel/~pinka/lib/BigMath.f'>~pinka/lib/BigMath.f</a> \\ ������������ ����� (������� �����)

<a id="sort-n-search"/>
### \\ ���������� � �����
* REQUIRE HeapSort <a href='../devel/~mlg/SrcLib/hsort.f'>~mlg/SrcLib/hsort.f</a>  \\ ������������� ����������
* REQUIRE quick_sort <a href='../devel/~pinka/samples/2003/common/qsort.f'>~pinka/samples/2003/common/qsort.f</a> \\ "�������" ����������
* REQUIRE binary-search <a href='../devel/~profit/lib/binary-search.f'>~profit/lib/binary-search.f</a> \\ �������� �����

<a id="techniques"/>
### \\ Programming techniques 
* REQUIRE { <a href='../lib/ext/locals.f'>lib/ext/locals.f</a> \\ ��������� ���������� 
* REQUIRE LAMBDA{ <a href='../devel/~pinka/lib/lambda.f'>~pinka/lib/lambda.f</a> \\ :NONAME �� ������ �������������� ����������� 
* REQUIRE (: <a href='../devel/~yz/lib/inline.f'>~yz/lib/inline.f</a> \\ ������ ������-����������� 
* REQUIRE CONT <a href='../devel/~profit/lib/bac4th.f'>~profit/lib/bac4th.f</a> \\ ����������, �������� � <a href='../devel/~mlg/index.html#bacforth'>~mlg/#bacforth</a> 

<a id="debug"/>
### \\ �������� ������� 
* REQUIRE HeapEnum <a href='../devel/~ac/lib/memory/heap_enum2.f'>~ac/lib/memory/heap_enum2.f</a> \\ ������������ ���������� ������ ������ �� ���� 
* REQUIRE mem\_stub <a href='../devel/~day/lib/mem_sanity.f'>~day/lib/mem_sanity.f</a> \\ �������� ������������ �������� (� ������� ���������� ��������) 
* REQUIRE MemReport <a href='../devel/~day/lib/memreport.f'>~day/lib/memreport.f</a> \\ ����� �� ������� � ����������� ����� (������������ ���������������) 
* REQUIRE ACCERT( <a href='../lib/ext/debug/accert.f'>lib/ext/debug/accert.f</a> \\ �������� ����������, ������ ��� �������� 
* REQUIRE TRACER <a href='../lib/ext/debug/tracer.f'>lib/ext/debug/tracer.f</a> \\ ��������� ������������ ���������� 
* REQUIRE EXC-DUMP2 <a href='../devel/~pinka/spf/exc-dump.f'>~pinka/spf/exc-dump.f</a> \\ ���������� ���� ������ ����������
* REQUIRE TESTCASES <a href='../devel/~ygrek/lib/testcase.f'>~ygrek/lib/testcase.f</a> \\ TESTCASES by ~day
* REQUIRE /TEST <a href='../devel/~profit/lib/testing.f'>~profit/lib/testing.f</a> \\ ���������� ������ � ���� ���������� �� INCLUDED-DEPTH (������� ���������)

<a id="random"/>
### \\ ��������� ����� 
* REQUIRE RANDOM <a href='../lib/ext/rnd.f'>lib/ext/rnd.f</a> \\ �������-������������ ��������� 
* REQUIRE RANDOM <a href='../devel/~day/common/rnd.f'>~day/common/rnd.f</a> \\ �������-������������ ��������� 
* REQUIRE RANDOM <a href='../devel/~af/lib/random.f'>~af/lib/random.f</a> \\ �������-������������ ��������� 
* REQUIRE RANDOM <a href='../devel/~nn/lib/ran4.f'>~nn/lib/ran4.f</a> \\ RAN4 
* REQUIRE GENRAND <a href='../devel/~ygrek/lib/neilbawd/mersenne.f'>~ygrek/lib/neilbawd/mersenne.f</a> \\ Mersenne twister - ������� � ������������ ��������� ��������� ����� � ����� ������� �������� 

<a id="hash"/>
### \\ ���-������� 
* REQUIRE new-hash <a href='../devel/~pinka/lib/hash-table.f'>~pinka/lib/hash-table.f</a> 
* REQUIRE ListAllocate <a href='../devel/~af/lib/simple_hash.f'>~af/lib/simple_hash.f</a> 
* REQUIRE HASH-TABLE <a href='../devel/~yz/lib/hash.f'>~yz/lib/hash.f</a> 

( ��������� �������������� � <a href='../devel/~pinka/samples/2003/test-hash/'>~pinka/samples/2003/test-hash/</a>)

* REQUIRE HASH <a href='../devel/~day/common/hash.f'>~day/common/hash.f</a> \\ ������� ���������� ���� 

<a id="hash-func"/>
### \\ ���-������� (�����������������) 
* REQUIRE MD5 <a href='../devel/~clf/md5.f'>~clf/md5.f</a> 
* REQUIRE MD5 <a href='../devel/~clf/md5-ts.f'>~clf/md5-ts.f</a> \\ thread safe 
* REQUIRE SHAbuffer <a href='../devel/~nn/lib/security/SHA256.f'>~nn/lib/security/SHA256.f</a> 
* REQUIRE MD5 <a href='../lib/alg/md5-jz.f'>lib/alg/md5-jz.f</a> 

<a id="compiletime-const"/>
### \\ ��������� ������� ���������� 
* REQUIRE LOAD-CONSTANTS <a href='../devel/~yz/lib/const.f'>~yz/lib/const.f</a> \\ ����������� �������� - ����� W: ���� ��������� 
* REQUIRE ADD-CONST-VOC <a href='../devel/~day/wincons/wc.f'>~day/wincons/wc.f</a> \\ ����������� �������� - �������������� NOTFOUND 
* REQUIRE BEGIN-CONST <a href='../devel/~day/wincons/compile.f'>~day/wincons/compile.f</a> \\ ���������� *.const ������ 
* \\ <a href='../devel/~day/wincons/h2f.f'>~day/wincons/h2f.f</a> \\ ��������� �������� ����� �� ������ *.h ������ 
* \\ <a href='../devel/~yz/cons/'>~yz/cons/</a> \\ ���������������� ��������� sql, commctrl, windows 
* \\ <a href='../devel/~ygrek/lib/data/'>~ygrek/lib/data/</a> \\ farplugin, opengl 

<a id="WinGUI"/>
### \\ Windows GUI 
* REQUIRE WINDOWS... <a href='../devel/~yz/lib/winlib.f'>~yz/lib/winlib.f</a> \\ WinLib - ���������� ���������� Windows. ����� ����������� ����� � �������� � ���. ������� ���� ���� ��� �������� ������ ���������, � ������� ���������� � ����� - ���-���! ������� <a href='http://www.forth.org.ru/~yz/winlib.html'>������������</a>. 
* REQUIRE FrameWindow <a href='../devel/~day/joop/win/'>~day/joop/win/framewindow.f</a> \\ ������� ���������� ������ joop 
* \\ <a href='../devel/~ac/lib/win/window/'>~ac/lib/win/window/</a> \\ ������� � ��������� ���������� 

<a id="WinCOM"/>
### \\ Windows COM 
* REQUIRE ComInit <a href='../devel/~ac/lib/win/com/com.f'>~ac/lib/win/com/com.f</a> \\ ������� ��������� COM 
* REQUIRE Extends <a href='../devel/~ac/lib/win/com/com_server.f'>~ac/lib/win/com/com_server.f</a> \\ COM-������ 

<a id="services"/>
### \\ ��������� ������� 
* REQUIRE CreateService <a href='../devel/~ac/lib/win/service/service.f'>~ac/lib/win/service/service.f</a> \\ ������� � NT 
* REQUIRE InstallService95 <a href='../devel/~ac/lib/win/service/service95.f'>~ac/lib/win/service/service95.f</a> \\ "�������" � Win9x/ME 

<a id="datetime"/>
### \\ ���� � ����� 
* REQUIRE DateTime# <a href='../devel/~ac/lib/win/date/date-int.f'>~ac/lib/win/date/date-int.f</a> \\ ����/����� � ��������� �������� 
* REQUIRE UNIXDATE <a href='../devel/~ac/lib/win/date/unixdate.f'>~ac/lib/win/date/unixdate.f</a> \\ ��������� Unixdate 
* REQUIRE FileDateTime# <a href='../devel/~ac/lib/win/file/filetime.f'>~ac/lib/win/file/filetime.f</a> \\ ����/����� � �������� ������� 
* REQUIRE parse-date? <a href='../devel/~ygrek/lib/spec/sdate.f'>~ygrek/lib/spec/sdate.f</a> \\ ������ ���� � ���� S" Tue, 19 Dec 2006 19:55:16 +0300"
* REQUIRE parse-num-unixdate <a href='../devel/~ygrek/lib/spec/sdate2.f'>~ygrek/lib/spec/sdate2.f</a> \\ ������ ���� � ���� S" 2007-01-27T17:40:36+03:00"
* REQUIRE DateTime>Num <a href='../devel/~ygrek/lib/spec/unixdate.f'>~ygrek/lib/spec/unixdate.f</a> \\ unix timestamp � ���� � ��������

<a id="db"/>
### \\ ���� ������ 
* REQUIRE StartSQL <a href='../devel/~yz/lib/odbc.f'>~yz/lib/odbc.f</a> \\ ������ � ��������������� ������� 
* REQUIRE StartSQL <a href='../devel/~ac/lib/win/odbc/'>~ac/lib/win/odbc/odbc.f</a> \\ ODBC, ������ � ������� �� ���� ��� �� �������� 
* REQUIRE ExecSQLTxt <a href='../devel/~pinka/lib/win/odbc/odbc-txt.f'>~pinka/lib/win/odbc/odbc-txt.f</a> \\ ��������� DELETE � UPDATE � ������ ������������� Text File Driver 
* REQUIRE db3_open <a href='../devel/~ac/lib/lin/sql/sqlite3.f'>~ac/lib/lin/sql/sqlite3.f</a> \\ SQLite 
* REQUIRE MyQuery <a href='../devel/~day/lib/mysql.f'>~day/lib/mysql.f</a> \\ MySQL wrapper 

<a id="threads"/>
### \\ ��������, ������, ����� ������� etc
* \\ <a href='../devel/~ac/lib/win/process/'>~ac/lib/win/process/</a> 
* REQUIRE GetProcessACL <a href='../devel/~ac/lib/win/access/nt_access.f'>~ac/lib/win/access/nt_access.f</a> \\ ����� ������� 
* REQUIRE IsapiRunExtension <a href='../devel/~ac/lib/win/isapi/isapi.f'>~ac/lib/win/isapi/isapi.f</a> \\ ��������� ISAPI-����������� ���������� 
* REQUIRE CREATE-CP <a href='../devel/~ac/lib/win/thread/pool.f'>~ac/lib/win/thread/pool.f</a> \\ ��������� ���� ������� � Win200x 
* REQUIRE CREATE-MUTEX <a href='../lib/win/mutex.f'>lib/win/mutex.f</a> \ �������
* REQUIRE ENTER-CS <a href='../devel/~pinka/lib/multi/critical.f'>~pinka/lib/multi/critical.f</a> \ Critical sections
* REQUIRE WaitAll <a href='../devel/~pinka/lib/multi/synchr.f'>~pinka/lib/multi/synchr.f</a> \ ������������� ������� - "�������� ������", "�������� ����"

<a id="ini-registry"/>
### \\ ������ � ini Windows 
* REQUIRE RG_CreateKey <a href='../devel/~ac/lib/win/registry2.f'>~ac/lib/win/registry2.f</a> 
* REQUIRE IniFile@ <a href='../devel/~ac/lib/win/ini.f'>~ac/lib/win/ini.f</a> 

<a id="str"/>
### \\ ������ 
* REQUIRE STR@ <a href='../devel/~ac/lib/str5.f'>~ac/lib/str5.f</a> \\ ������������ ������ 
* REQUIRE BNF <a href='../devel/~ac/lib/transl/BNF.f'>~ac/lib/transl/BNF.f</a> \\ �������� ���� ������ BNF 
* REQUIRE CHECK-SET <a href='../devel/~day/common/sbnf.f'>~day/common/sbnf.f</a> \\ ������� BNF ������ 
* REQUIRE WildCMP-U <a href='../devel/~pinka/lib/mask.f'>~pinka/lib/mask.f</a> \\ ��������� ������ � ����� � ������������� * � ? 
* REQUIRE ULIKE <a href='../devel/~pinka/lib/like.f'>~pinka/lib/like.f</a> \\ ��������� ������ � ����� � ������������� * � ? 
* REQUIRE re_start <a href='../devel/~nn/lib/re.f'>~nn/lib/re.f</a> \\ regexp'� 
* REQUIRE PcreMatch <a href='../devel/~ac/lib/string/regexp.f'>~ac/lib/string/regexp.f</a> \\ PCRE wrapper 
* REQUIRE BregexpMatch <a href='../devel/~ac/lib/string/bregexp/bregexp.f'>~ac/lib/string/bregexp/bregexp.f</a> \\ bregexp.dll wrapper 
* REQUIRE debase64 <a href='../devel/~ac/lib/string/conv.f'>~ac/lib/string/conv.f</a> \\ base64, win-koi, urlencode � ��. 
* REQUIRE UPPERCASE <a href='../devel/~ac/lib/string/uppercase.f'>~ac/lib/string/uppercase.f</a> \\ ������� � ������� ������� 
* REQUIRE COMPARE-U <a href='../devel/~ac/lib/string/compare-u.f'>~ac/lib/string/compare-u.f</a> \\ ���������������� � �������� ��������� 
* REQUIRE GetParam <a href='../devel/~ac/lib/string/get_params.f'>~ac/lib/string/get_params.f</a> \\ ������ ������ URL-���������� 
* REQUIRE SPLIT- <a href='../devel/~pinka/samples/2005/lib/split.f'>~pinka/samples/2005/lib/split.f</a> \\ ��������� ������ �� �����, ������ "�� �����"
* REQUIRE replace-str- <a href='../devel/~pinka/samples/2005/lib/replace-str.f'>~pinka/samples/2005/lib/replace-str.f</a> \\ ������ � ������
* REQUIRE FINE-HEAD <a href='../devel/~pinka/samples/2005/lib/split-white.f'>~pinka/samples/2005/lib/split-white.f</a> \\ �������� �������� � ���� ������
* REQUIRE TYPE>STR <a href='../devel/~ygrek/lib/typestr.f'>~ygrek/lib/typestr.f</a> \\ ��������������� ����� TYPE ������ � ������

<a id="files"/>
### \\ ����� 
* REQUIRE OPEN-FILE-SHARED-DELETE <a href='../devel/~ac/lib/win/file/share-delete.f'>~ac/lib/win/file/share-delete.f</a> \\ �������� ����� � "������" ���������� �������� 
* REQUIRE LAY-PATH <a href='../devel/~pinka/samples/2005/lib/lay-path.f'>~pinka/samples/2005/lib/lay-path.f</a> \\ �������� ��������� ���� 
* REQUIRE ATTACH <a href='../devel/~pinka/samples/2005/lib/append-file.f'>~pinka/samples/2005/lib/append-file.f</a> \\ ���������� ������ � ����
* REQUIRE SPEAK-WITH <a href='../devel/~pinka/samples/2005/ext/tank.f'>~pinka/samples/2005/ext/tank.f</a> \\ ���������� �������� ������, ���������� xt � ���������������� ������ � ���� 

<a id="xml"/>
### \\ XML
* REQUIRE XML\_Evaluate <a href='../devel/~ac/lib/lin/xml/expat.f'>~ac/lib/lin/xml/expat.f</a> \\ ��������� XML ����� libexpat
* REQUIRE XML\_READ\_DOC <a href='../devel/~ac/lib/lin/xml/xml.f'>~ac/lib/lin/xml/xml.f</a> \\ ��������� XML ����� LibXml2 
* REQUIRE XSLT <a href='../devel/~ac/lib/lin/xml/xslt.f'>~ac/lib/lin/xml/xslt.f</a> \\ ��������� XSLT ����� LibXslt 

<a id="oop"/>
### \\ ��� ���������� 
* REQUIRE CLASS: <a href='../devel/~day/joop/oop.f'>~day/joop/oop.f</a> \\ just oop � ����� �������� 
* REQUIRE CLASS: <a href='../devel/~af/mc/microclass.f'>~af/mc/microclass.f</a> \\ microclass 
* REQUIRE CLASS: <a href='../devel/~day/mc/microclass.f'>~day/mc/microclass.f</a> \\ microclass 
* REQUIRE CLASS <a href='../devel/~day/hype3/hype3.f'>~day/hype3/hype3.f</a> \\ Hype 3, ������� <a href='../devel/~day/hype3/reference.pdf'>������������</a>

<a id="vocs"/>
### \\ �������
* REQUIRE InVoc{ <a href='../devel/~ac/lib/transl/vocab.f'>~ac/lib/transl/vocab.f</a> \\ ���������� ������ ����������� ��������� (������ MODULE:) 
* REQUIRE ForEach <a href='../devel/~ac/lib/ns/iterators.f'>~ac/lib/ns/iterators.f</a> \\ ��������� � ����������� �������� 
* REQUIRE ForEach-Word <a href='../devel/~pinka/lib/Words.f'>~pinka/lib/Words.f</a> \\ ForEach-Word 
* REQUIRE QuickSWL-Support <a href='../devel/~pinka/spf/quick-swl2.f'>~pinka/spf/quick-swl2.f</a> \\ ������� ����� �� ������� (�� ���� �����������) 
* REQUIRE DLOPEN <a href='../devel/~ac/lib/ns/dlopen.f'>~ac/lib/ns/dlopen.f</a> \\ ����������� � Unix-������� SPF ������ �������� WindowsDLL/UnixSO 
* \\ <a href='../devel/~ac/lib/ns/'>~ac/lib/ns/</a> \\ ����������� ������� ����������� �������� �� ����-������� 

<a id="mem"/>
### \\ ������ 
* REQUIRE STACK\_MEM <a href='../devel/~ac/lib/memory/mem_stack.f'>~ac/lib/memory/mem_stack.f</a> \\ "��������" ���������� ������� 
* REQUIRE LowMemory? <a href='../devel/~ac/lib/memory/low_memory.f'>~ac/lib/memory/low_memory.f</a> \\ ������������ ����������� ����������� ������ 
* REQUIRE PAllocSupport <a href='../devel/~af/lib/pallocate.f'>~af/lib/pallocate.f</a> \\ ��������� ������ � �������� ������������ �������� (����� ��� �������) 
* REQUIRE LOCALLOC <a href='../devel/~mak/lalloc.f'>~mak/lalloc.f</a> \\ ��������� ���������� ������� (�� ����� ���������) 
* REQUIRE ALLOCATE2 <a href='../devel/~pinka/spf/mem2.f'>~pinka/spf/mem2.f</a> \\ ������������ ������ � ����� ������ � ���������� 
* REQUIRE LoadDelphiMM <a href='../devel/~ss/lib/borlndmm.f'>~ss/lib/borlndmm.f</a> \\ ����������� ��������� ������ �� Borland 
* REQUIRE INIT-TASK-VALUES <a href='../devel/~ss/lib/task-values.f'>~ss/lib/task-values.f</a> \\ ���������� ���������� ������ 
* REQUIRE PROTECT-RETURN-STACK <a href='../devel/~ss/ext/stack-quard.f'>~ss/ext/stack-quard.f</a> \\ ������ ����� ��������� �� ��������� ������ ������ 
* REQUIRE GMEM <a href='../devel/~yz/lib/gmem.f'>~yz/lib/gmem.f</a> \\ ���������� ������ ����������� ����� ��������

<a id="misc"/>
### \\ ������
* REQUIRE CONST <a href='../devel/~micro/lib/const/const.f'>~micro/lib/const/const.f</a> \\ ������������ �������� 
* REQUIRE ENUM <a href='../devel/~ygrek/lib/enum.f'>~ygrek/lib/enum.f</a> \\ ������������ �������� ���� 
* REQUIRE enqueueNOTFOUND <a href='../devel/~pinka/samples/2006/core/trans/nf-ext.f'>~pinka/samples/2006/core/trans/nf-ext.f</a> \\ ���������� � ������ ������������ (NOTFOUND)
