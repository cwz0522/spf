\ ������ JSON:
\ JS-������� �������������� � ���� �������� �����
\ JS-������� �������������� � ���� �������� ����� �� �������� ������� ����� � �������� ���
\ JS-������ �������������� � ���� str5-����� �����
\ JS-����� �������������� � ���� str5-����� �����
\ JS-null/bool �������������� � ���� ����� �����
\ � ������� �� ���� �������� ����������� ���������-���, �.�. ������ �������� JS
\ �������� � ����� ��� "x t", ��� x - ������ ����� (��� ������� ����),
\ � t - ��������� js_* (������� ����)
\ � ������� ��� ������������� ��� "C, ," � ���� CREATE-������.

REQUIRE BNF ~ac/lib/transl/BNF.F

0 CONSTANT js_null
1 CONSTANT js_bool
2 CONSTANT js_number
3 CONSTANT js_string
4 CONSTANT js_array
5 CONSTANT js_object
-1 CONSTANT js_error

: SkipWL
  Look @ IsDelimiter IF SkipDelimiters BNF THEN
;
: JsonWord ( -- n t )
  S" true"  SkipString  IF TRUE  js_bool EXIT THEN
  S" false" SkipString  IF FALSE js_bool EXIT THEN
  S" null"  SkipString  IF 0     js_null EXIT THEN
  1 js_error
;
: JsonNumber { \ s -- str t }
  "" -> s
  BEGIN
    Look @ IsDigit
    Look @ [CHAR] - = OR
    Look @ [CHAR] + = OR
    Look @ [CHAR] . = OR
    Look @ [CHAR] e = OR
    Look @ [CHAR] E = OR
  WHILE
    Look 1 s STR+
    GetNextChar
  REPEAT
  s js_number
;
: JsonString { \ s -- str t }
  Look @ [CHAR] " = IF GetQuoted js_string EXIT THEN
  "" -> s
  BEGIN
    Look @ DUP IsQUOTED_CHAR
    OVER IsDelimiter 0= AND
    SWAP [CHAR] : <> AND
  WHILE
    Look 1 s STR+
    GetNextChar
  REPEAT
  s js_string
;
VECT vJsonValue
: JsonVal@
  DUP CHAR+ @ SWAP C@
;
: JsonDOES
  DOES> JsonVal@
;
: JsonArray ( -- wid t )
  TEMP-WORDLIST ALSO CONTEXT ! WARNING @ >R WARNING 0!
  SkipWL
  S" ]" SkipString IF CONTEXT @ PREVIOUS js_array R> WARNING ! EXIT THEN
  GET-CURRENT >R DEFINITIONS
  \ ������ ������ ��� ������ ��������
  \ ������� ��� ��� ������� �� ������� � ������� ������� �����
  BEGIN
    >IN @ #TIB @ <
  WHILE
    SkipWL
    S" " CREATED vJsonValue C, , \ JsonDOES
    SkipWL
    S" ]" SkipString IF R> SET-CURRENT CONTEXT @ PREVIOUS js_array R> WARNING ! EXIT THEN
    [CHAR] , Match
    SkipWL
  REPEAT
  R> SET-CURRENT CONTEXT @ PREVIOUS js_array R> WARNING !
;
: JsonObject ( -- wid t )
  TEMP-WORDLIST ALSO CONTEXT !
  SkipWL
  S" }" SkipString IF CONTEXT @ PREVIOUS js_object EXIT THEN
  GET-CURRENT >R DEFINITIONS
  \ ������ ������ ���� ���� ����-��������
  BEGIN
    >IN @ #TIB @ <
  WHILE
    JsonString js_string <> IF DROP 2 js_error EXIT THEN \ key
    SkipWL
    [CHAR] : Match \ throwable
    STR@ ( 2DUP TYPE ." :" ) CREATED vJsonValue C, , \ JsonDOES
    SkipWL
    S" }" SkipString IF R> SET-CURRENT CONTEXT @ PREVIOUS js_object EXIT THEN
    [CHAR] , Match
    SkipWL
  REPEAT
  R> SET-CURRENT CONTEXT @ PREVIOUS js_object
;
: JsonValue ( -- x t )
  SkipWL
  S" {" SkipString  IF JsonObject EXIT THEN
  S" [" SkipString  IF JsonArray  EXIT THEN
  Look @ [CHAR] " = IF JsonString EXIT THEN
  Look @ [CHAR] - = IF JsonNumber EXIT THEN
  Look @ IsDigit    IF JsonNumber ELSE JsonWord THEN
;
' JsonValue TO vJsonValue

: (JsonParse)
  SkipDelimiters BNF JsonValue
;
: JsonParse ( addr u -- x t )
  ['] (JsonParse) EVALUATE-WITH
;
: JsonPrint { x t \ i -- }
  t js_null = IF ." null" EXIT THEN
  t js_bool = IF x IF ." true" ELSE ." false" THEN EXIT THEN
  t js_number = IF x STR@ TYPE EXIT THEN
  t js_string = IF x STR@ [CHAR] " EMIT TYPE [CHAR] " EMIT EXIT THEN
  t js_array = IF 0 -> i ." [" x @ BEGIN DUP WHILE i IF ." ," CR THEN DUP NAME> ( EXECUTE) >BODY JsonVal@ RECURSE CDR ^ i 1+! REPEAT DROP ." ]" EXIT THEN
  t js_object = IF 0 -> i ." {" x @ BEGIN DUP WHILE i IF ." ," CR THEN DUP ID. ." :" DUP NAME> >BODY JsonVal@ RECURSE CDR ^ i 1+! REPEAT DROP ." }" EXIT THEN
  ." JsonPrint ERR:" . . CR
;

\EOF

: TEST
\  S" json-test.js" FILE JsonParse JsonPrint
  S" json-test2.js" FILE JsonParse JsonPrint
\  S' {key:"value",key2:"value2"}' JsonParse JsonPrint
\  S'  { key : "value" , "key2" : "value2", key3 : { key4 : "value4" },key5:"value5", key6:["value6","value7","value8"] } ' JsonParse JsonPrint
;
TEST

\EOF
\ � ���� JSON-������ �� ������������ AWS ���� ��� ������ :), ������ ��� �����
{"TableName":"Table1",
	"Limit":2,
	"ConsistentRead":true,
	"HashKeyValue":{"S":"AttributeValue1"},
	"RangeKeyCondition": {"AttributeValueList":[{"N":"AttributeValue2"}],"ComparisonOperator":"GT"},
	"ScanIndexForward":true,
	"ExclusiveStartKey":{
		"HashKeyElement":{"S":"AttributeName1"},
		"RangeKeyElement":{"N":"AttributeName2"}
	},
    "AttributesToGet":["AttributeName1", "AttributeName2", "AttributeName3"]},
}
