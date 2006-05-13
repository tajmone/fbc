''	FreeBASIC - 32-bit BASIC Compiler.
''	Copyright (C) 2004-2006 Andre Victor T. Vicentini (av1ctor@yahoo.com.br)
''
''	This program is free software; you can redistribute it and/or modify
''	it under the terms of the GNU General Public License as published by
''	the Free Software Foundation; either version 2 of the License, or
''	(at your option) any later version.
''
''	This program is distributed in the hope that it will be useful,
''	but WITHOUT ANY WARRANTY; without even the implied warranty of
''	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
''	GNU General Public License for more details.
''
''	You should have received a copy of the GNU General Public License
''	along with this program; if not, write to the Free Software
''	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA.


'' symbol table module for keywords
''
'' chng: sep/2004 written [v1ctor]
''		 jan/2005 updated to use real linked-lists [v1ctor]

option explicit
option escape

#include once "inc\fb.bi"
#include once "inc\fbint.bi"
#include once "inc\hash.bi"
#include once "inc\list.bi"

type SYMBKWD
	name			as zstring ptr
	id				as integer
    class			as integer
end type

	'' keywords: name, id (token), class
const SYMB_MAXKEYWORDS = 210

	dim shared kwdTb( 0 to SYMB_MAXKEYWORDS-1 ) as SYMBKWD => _
	{ _
		(@"AND"		, FB_TK_AND				, FB_TKCLASS_OPERATOR), _
        (@"OR"		, FB_TK_OR				, FB_TKCLASS_OPERATOR), _
        (@"XOR"		, FB_TK_XOR				, FB_TKCLASS_OPERATOR), _
        (@"EQV"		, FB_TK_EQV				, FB_TKCLASS_OPERATOR), _
        (@"IMP"		, FB_TK_IMP				, FB_TKCLASS_OPERATOR), _
        (@"NOT"		, FB_TK_NOT				, FB_TKCLASS_OPERATOR), _
        (@"MOD"		, FB_TK_MOD				, FB_TKCLASS_OPERATOR), _
        (@"SHL"		, FB_TK_SHL				, FB_TKCLASS_OPERATOR), _
        (@"SHR"		, FB_TK_SHR				, FB_TKCLASS_OPERATOR), _
        (@"REM"		, FB_TK_REM				, FB_TKCLASS_KEYWORD), _
        (@"DIM"		, FB_TK_DIM				, FB_TKCLASS_KEYWORD), _
        (@"STATIC"	, FB_TK_STATIC			, FB_TKCLASS_KEYWORD), _
        (@"SHARED"	, FB_TK_SHARED			, FB_TKCLASS_KEYWORD), _
        (@"BYTE"	, FB_TK_BYTE			, FB_TKCLASS_KEYWORD), _
        (@"UBYTE"	, FB_TK_UBYTE			, FB_TKCLASS_KEYWORD), _
        (@"SHORT"	, FB_TK_SHORT			, FB_TKCLASS_KEYWORD), _
        (@"USHORT"	, FB_TK_USHORT			, FB_TKCLASS_KEYWORD), _
        (@"INTEGER"	, FB_TK_INTEGER			, FB_TKCLASS_KEYWORD), _
        (@"UINTEGER", FB_TK_UINT			, FB_TKCLASS_KEYWORD), _
        (@"LONG"	, FB_TK_LONG			, FB_TKCLASS_KEYWORD), _
        (@"LONGINT"	, FB_TK_LONGINT			, FB_TKCLASS_KEYWORD), _
        (@"ULONGINT", FB_TK_ULONGINT		, FB_TKCLASS_KEYWORD), _
        (@"SINGLE"	, FB_TK_SINGLE			, FB_TKCLASS_KEYWORD), _
        (@"DOUBLE"	, FB_TK_DOUBLE			, FB_TKCLASS_KEYWORD), _
        (@"STRING"	, FB_TK_STRING			, FB_TKCLASS_KEYWORD), _
        (@"ZSTRING"	, FB_TK_ZSTRING			, FB_TKCLASS_KEYWORD), _
        (@"WSTRING"	, FB_TK_WSTRING			, FB_TKCLASS_KEYWORD), _
        (@"CALL"	, FB_TK_CALL			, FB_TKCLASS_KEYWORD), _
        (@"BYVAL"	, FB_TK_BYVAL			, FB_TKCLASS_KEYWORD), _
        (@"INCLUDE"	, FB_TK_INCLUDE			, FB_TKCLASS_KEYWORD), _
        (@"DYNAMIC"	, FB_TK_DYNAMIC			, FB_TKCLASS_KEYWORD), _
        (@"AS"		, FB_TK_AS				, FB_TKCLASS_KEYWORD), _
        (@"DECLARE"	, FB_TK_DECLARE			, FB_TKCLASS_KEYWORD), _
        (@"GOTO"	, FB_TK_GOTO			, FB_TKCLASS_KEYWORD), _
        (@"GOSUB"	, FB_TK_GOSUB			, FB_TKCLASS_KEYWORD), _
        (@"DEFBYTE"	, FB_TK_DEFBYTE			, FB_TKCLASS_KEYWORD), _
        (@"DEFUBYTE", FB_TK_DEFUBYTE		, FB_TKCLASS_KEYWORD), _
        (@"DEFSHORT", FB_TK_DEFSHORT		, FB_TKCLASS_KEYWORD), _
        (@"DEFUSHORT", FB_TK_DEFUSHORT		, FB_TKCLASS_KEYWORD), _
        (@"DEFINT"	, FB_TK_DEFINT			, FB_TKCLASS_KEYWORD), _
        (@"DEFUINT"	, FB_TK_DEFUINT			, FB_TKCLASS_KEYWORD), _
        (@"DEFLNG"	, FB_TK_DEFLNG			, FB_TKCLASS_KEYWORD), _
        (@"DEFLONGINT", FB_TK_DEFLNGINT		, FB_TKCLASS_KEYWORD), _
        (@"DEFULONGINT", FB_TK_DEFULNGINT	, FB_TKCLASS_KEYWORD), _
        (@"DEFSNG"	, FB_TK_DEFSNG			, FB_TKCLASS_KEYWORD), _
        (@"DEFDBL"	, FB_TK_DEFDBL			, FB_TKCLASS_KEYWORD), _
        (@"DEFSTR"	, FB_TK_DEFSTR			, FB_TKCLASS_KEYWORD), _
        (@"CONST"	, FB_TK_CONST			, FB_TKCLASS_KEYWORD), _
        (@"FOR"		, FB_TK_FOR				, FB_TKCLASS_KEYWORD), _
        (@"STEP"	, FB_TK_STEP			, FB_TKCLASS_KEYWORD), _
        (@"NEXT"	, FB_TK_NEXT			, FB_TKCLASS_KEYWORD), _
        (@"TO"		, FB_TK_TO				, FB_TKCLASS_KEYWORD), _
        (@"TYPE"	, FB_TK_TYPE			, FB_TKCLASS_KEYWORD), _
        (@"END"		, FB_TK_END				, FB_TKCLASS_KEYWORD), _
        (@"SUB"		, FB_TK_SUB				, FB_TKCLASS_KEYWORD), _
        (@"FUNCTION", FB_TK_FUNCTION		, FB_TKCLASS_KEYWORD), _
        (@"CDECL"	, FB_TK_CDECL			, FB_TKCLASS_KEYWORD), _
        (@"STDCALL"	, FB_TK_STDCALL			, FB_TKCLASS_KEYWORD), _
        (@"ALIAS"	, FB_TK_ALIAS			, FB_TKCLASS_KEYWORD), _
        (@"LIB"		, FB_TK_LIB				, FB_TKCLASS_KEYWORD), _
        (@"LET"		, FB_TK_LET				, FB_TKCLASS_KEYWORD), _
        (@"EXIT"	, FB_TK_EXIT			, FB_TKCLASS_KEYWORD), _
        (@"DO"		, FB_TK_DO				, FB_TKCLASS_KEYWORD), _
        (@"LOOP"	, FB_TK_LOOP			, FB_TKCLASS_KEYWORD), _
        (@"RETURN"	, FB_TK_RETURN			, FB_TKCLASS_KEYWORD), _
        (@"ANY"		, FB_TK_ANY				, FB_TKCLASS_KEYWORD), _
        (@"PTR"		, FB_TK_PTR				, FB_TKCLASS_KEYWORD), _
        (@"POINTER"	, FB_TK_POINTER			, FB_TKCLASS_KEYWORD), _
        (@"VARPTR"	, FB_TK_VARPTR			, FB_TKCLASS_KEYWORD), _
        (@"WHILE"	, FB_TK_WHILE			, FB_TKCLASS_KEYWORD), _
        (@"UNTIL"	, FB_TK_UNTIL			, FB_TKCLASS_KEYWORD), _
        (@"WEND"	, FB_TK_WEND			, FB_TKCLASS_KEYWORD), _
        (@"CONTINUE", FB_TK_CONTINUE		, FB_TKCLASS_KEYWORD), _
        (@"CBYTE"	, FB_TK_CBYTE			, FB_TKCLASS_KEYWORD), _
        (@"CSHORT"	, FB_TK_CSHORT			, FB_TKCLASS_KEYWORD), _
        (@"CINT"	, FB_TK_CINT			, FB_TKCLASS_KEYWORD), _
        (@"CLNG"	, FB_TK_CLNG			, FB_TKCLASS_KEYWORD), _
        (@"CLNGINT"	, FB_TK_CLNGINT			, FB_TKCLASS_KEYWORD), _
        (@"CUBYTE"	, FB_TK_CUBYTE			, FB_TKCLASS_KEYWORD), _
        (@"CUSHORT"	, FB_TK_CUSHORT			, FB_TKCLASS_KEYWORD), _
        (@"CUINT"	, FB_TK_CUINT			, FB_TKCLASS_KEYWORD), _
        (@"CULNGINT", FB_TK_CULNGINT		, FB_TKCLASS_KEYWORD), _
        (@"CSNG"	, FB_TK_CSNG			, FB_TKCLASS_KEYWORD), _
        (@"CDBL"	, FB_TK_CDBL			, FB_TKCLASS_KEYWORD), _
        (@"CSIGN"	, FB_TK_CSIGN			, FB_TKCLASS_KEYWORD), _
        (@"CUNSG"	, FB_TK_CUNSG			, FB_TKCLASS_KEYWORD), _
        (@"CPTR"	, FB_TK_CPTR			, FB_TKCLASS_KEYWORD), _
        (@"CAST"	, FB_TK_CAST			, FB_TKCLASS_KEYWORD), _
        (@"IF"		, FB_TK_IF				, FB_TKCLASS_KEYWORD), _
        (@"THEN"	, FB_TK_THEN			, FB_TKCLASS_KEYWORD), _
        (@"ELSE"	, FB_TK_ELSE			, FB_TKCLASS_KEYWORD), _
        (@"ELSEIF"	, FB_TK_ELSEIF			, FB_TKCLASS_KEYWORD), _
        (@"SELECT"	, FB_TK_SELECT			, FB_TKCLASS_KEYWORD), _
        (@"CASE"	, FB_TK_CASE			, FB_TKCLASS_KEYWORD), _
        (@"IS"		, FB_TK_IS				, FB_TKCLASS_KEYWORD), _
        (@"UNSIGNED", FB_TK_UNSIGNED		, FB_TKCLASS_KEYWORD), _
        (@"REDIM"	, FB_TK_REDIM			, FB_TKCLASS_KEYWORD), _
        (@"ERASE"	, FB_TK_ERASE			, FB_TKCLASS_KEYWORD), _
        (@"LBOUND"	, FB_TK_LBOUND			, FB_TKCLASS_KEYWORD), _
        (@"UBOUND"	, FB_TK_UBOUND			, FB_TKCLASS_KEYWORD), _
        (@"UNION"	, FB_TK_UNION			, FB_TKCLASS_KEYWORD), _
        (@"PUBLIC"	, FB_TK_PUBLIC			, FB_TKCLASS_KEYWORD), _
        (@"PRIVATE"	, FB_TK_PRIVATE			, FB_TKCLASS_KEYWORD), _
        (@"STR"		, FB_TK_STR				, FB_TKCLASS_KEYWORD), _
        (@"WSTR"	, FB_TK_WSTR			, FB_TKCLASS_KEYWORD), _
        (@"MID"		, FB_TK_MID				, FB_TKCLASS_KEYWORD), _
 		(@"INSTR"	, FB_TK_INSTR			, FB_TKCLASS_KEYWORD), _
		(@"TRIM"	, FB_TK_TRIM			, FB_TKCLASS_KEYWORD), _
        (@"RTRIM"	, FB_TK_RTRIM			, FB_TKCLASS_KEYWORD), _
        (@"LTRIM"	, FB_TK_LTRIM			, FB_TKCLASS_KEYWORD), _
        (@"BYREF"	, FB_TK_BYREF			, FB_TKCLASS_KEYWORD), _
        (@"OPTION"	, FB_TK_OPTION			, FB_TKCLASS_KEYWORD), _
        (@"BASE"	, FB_TK_BASE			, FB_TKCLASS_KEYWORD), _
        (@"EXPLICIT", FB_TK_EXPLICIT		, FB_TKCLASS_KEYWORD), _
        (@"PASCAL"	, FB_TK_PASCAL			, FB_TKCLASS_KEYWORD), _
        (@"PROCPTR"	, FB_TK_PROCPTR			, FB_TKCLASS_KEYWORD), _
        (@"SADD"	, FB_TK_SADD			, FB_TKCLASS_KEYWORD), _
        (@"RESTORE"	, FB_TK_RESTORE			, FB_TKCLASS_KEYWORD), _
        (@"READ"	, FB_TK_READ			, FB_TKCLASS_KEYWORD), _
        (@"DATA"	, FB_TK_DATA			, FB_TKCLASS_KEYWORD), _
        (@"ABS"		, FB_TK_ABS				, FB_TKCLASS_KEYWORD), _
        (@"SGN"		, FB_TK_SGN				, FB_TKCLASS_KEYWORD), _
        (@"FIX"		, FB_TK_FIX				, FB_TKCLASS_KEYWORD), _
        (@"PRINT"	, FB_TK_PRINT			, FB_TKCLASS_KEYWORD), _
        (@"LPRINT"	, FB_TK_LPRINT			, FB_TKCLASS_KEYWORD), _
        (@"USING"	, FB_TK_USING			, FB_TKCLASS_KEYWORD), _
        (@"LEN"		, FB_TK_LEN				, FB_TKCLASS_KEYWORD), _
        (@"PEEK"	, FB_TK_PEEK			, FB_TKCLASS_KEYWORD), _
        (@"POKE"	, FB_TK_POKE			, FB_TKCLASS_KEYWORD), _
        (@"SWAP"	, FB_TK_SWAP			, FB_TKCLASS_KEYWORD), _
        (@"COMMON"	, FB_TK_COMMON			, FB_TKCLASS_KEYWORD), _
        (@"OPEN"	, FB_TK_OPEN			, FB_TKCLASS_KEYWORD), _
        (@"CLOSE"	, FB_TK_CLOSE			, FB_TKCLASS_KEYWORD), _
        (@"SEEK"	, FB_TK_SEEK			, FB_TKCLASS_KEYWORD), _
        (@"PUT"		, FB_TK_PUT				, FB_TKCLASS_KEYWORD), _
        (@"GET"		, FB_TK_GET				, FB_TKCLASS_KEYWORD), _
        (@"ACCESS"	, FB_TK_ACCESS			, FB_TKCLASS_KEYWORD), _
        (@"WRITE"	, FB_TK_WRITE			, FB_TKCLASS_KEYWORD), _
        (@"LOCK"	, FB_TK_LOCK			, FB_TKCLASS_KEYWORD), _
        (@"INPUT"	, FB_TK_INPUT			, FB_TKCLASS_KEYWORD), _
        (@"OUTPUT"	, FB_TK_OUTPUT			, FB_TKCLASS_KEYWORD), _
        (@"BINARY"	, FB_TK_BINARY			, FB_TKCLASS_KEYWORD), _
        (@"RANDOM"	, FB_TK_RANDOM			, FB_TKCLASS_KEYWORD), _
        (@"APPEND"	, FB_TK_APPEND			, FB_TKCLASS_KEYWORD), _
        (@"ENCODING", FB_TK_ENCODING		, FB_TKCLASS_KEYWORD), _
        (@"NAME"	, FB_TK_NAME			, FB_TKCLASS_KEYWORD), _
        (@"WIDTH"	, FB_TK_WIDTH			, FB_TKCLASS_KEYWORD), _
        (@"PRESERVE", FB_TK_PRESERVE		, FB_TKCLASS_KEYWORD), _
        (@"ON"		, FB_TK_ON				, FB_TKCLASS_KEYWORD), _
        (@"ERROR"	, FB_TK_ERROR			, FB_TKCLASS_KEYWORD), _
        (@"ENUM"	, FB_TK_ENUM			, FB_TKCLASS_KEYWORD), _
        (@"INCLIB"	, FB_TK_INCLIB			, FB_TKCLASS_KEYWORD), _
        (@"ASM"		, FB_TK_ASM				, FB_TKCLASS_KEYWORD), _
        (@"SPC"		, FB_TK_SPC				, FB_TKCLASS_KEYWORD), _
        (@"TAB"		, FB_TK_TAB				, FB_TKCLASS_KEYWORD), _
        (@"LINE"	, FB_TK_LINE			, FB_TKCLASS_KEYWORD), _
        (@"VIEW"	, FB_TK_VIEW			, FB_TKCLASS_KEYWORD), _
        (@"LOCATE"	, FB_TK_LOCATE			, FB_TKCLASS_KEYWORD), _
        (@"UNLOCK"	, FB_TK_UNLOCK			, FB_TKCLASS_KEYWORD), _
        (@"FIELD"	, FB_TK_FIELD			, FB_TKCLASS_KEYWORD), _
        (@"LOCAL"	, FB_TK_LOCAL			, FB_TKCLASS_KEYWORD), _
        (@"ERR"		, FB_TK_ERR				, FB_TKCLASS_KEYWORD), _
        (@"DEFINE"	, FB_TK_DEFINE			, FB_TKCLASS_KEYWORD), _
        (@"UNDEF"	, FB_TK_UNDEF			, FB_TKCLASS_KEYWORD), _
        (@"IFDEF"	, FB_TK_IFDEF			, FB_TKCLASS_KEYWORD), _
        (@"IFNDEF"	, FB_TK_IFNDEF			, FB_TKCLASS_KEYWORD), _
        (@"ENDIF"	, FB_TK_ENDIF			, FB_TKCLASS_KEYWORD), _
        (@"DEFINED"	, FB_TK_DEFINED			, FB_TKCLASS_KEYWORD), _
        (@"RESUME"	, FB_TK_RESUME			, FB_TKCLASS_KEYWORD), _
        (@"PSET"	, FB_TK_PSET			, FB_TKCLASS_KEYWORD), _
        (@"PRESET"	, FB_TK_PRESET			, FB_TKCLASS_KEYWORD), _
        (@"POINT"	, FB_TK_POINT			, FB_TKCLASS_KEYWORD), _
        (@"CIRCLE"	, FB_TK_CIRCLE			, FB_TKCLASS_KEYWORD), _
        (@"WINDOW"	, FB_TK_WINDOW			, FB_TKCLASS_KEYWORD), _
        (@"PALETTE"	, FB_TK_PALETTE			, FB_TKCLASS_KEYWORD), _
        (@"SCREEN"	, FB_TK_SCREEN			, FB_TKCLASS_KEYWORD), _
        (@"SCREENRES", FB_TK_SCREENRES		, FB_TKCLASS_KEYWORD), _
        (@"PAINT"	, FB_TK_PAINT			, FB_TKCLASS_KEYWORD), _
        (@"DRAW"	, FB_TK_DRAW			, FB_TKCLASS_KEYWORD), _
        (@"EXTERN"	, FB_TK_EXTERN			, FB_TKCLASS_KEYWORD), _
        (@"STRPTR"	, FB_TK_STRPTR			, FB_TKCLASS_KEYWORD), _
        (@"WITH"	, FB_TK_WITH			, FB_TKCLASS_KEYWORD), _
        (@"SCOPE"	, FB_TK_SCOPE			, FB_TKCLASS_KEYWORD), _
        (@"NAMESPACE", FB_TK_NAMESPACE		, FB_TKCLASS_KEYWORD), _
        (@"EXPORT"	, FB_TK_EXPORT			, FB_TKCLASS_KEYWORD), _
        (@"IMPORT"	, FB_TK_IMPORT			, FB_TKCLASS_KEYWORD), _
        (@"LIBPATH"	, FB_TK_LIBPATH			, FB_TKCLASS_KEYWORD), _
        (@"CHR"		, FB_TK_CHR				, FB_TKCLASS_KEYWORD), _
        (@"WCHR"	, FB_TK_WCHR			, FB_TKCLASS_KEYWORD), _
        (@"ASC"		, FB_TK_ASC				, FB_TKCLASS_KEYWORD), _
        (@"LSET"	, FB_TK_LSET			, FB_TKCLASS_KEYWORD), _
        (@"IIF"		, FB_TK_IIF				, FB_TKCLASS_KEYWORD), _
        (@"VA_FIRST", FB_TK_VA_FIRST		, FB_TKCLASS_KEYWORD), _
        (@"SIZEOF"	, FB_TK_SIZEOF			, FB_TKCLASS_KEYWORD), _
        (@"SIN"		, FB_TK_SIN				, FB_TKCLASS_KEYWORD), _
        (@"ASIN"	, FB_TK_ASIN			, FB_TKCLASS_KEYWORD), _
        (@"COS"		, FB_TK_COS				, FB_TKCLASS_KEYWORD), _
        (@"ACOS"	, FB_TK_ACOS			, FB_TKCLASS_KEYWORD), _
        (@"TAN"		, FB_TK_TAN				, FB_TKCLASS_KEYWORD), _
        (@"ATN"		, FB_TK_ATN				, FB_TKCLASS_KEYWORD), _
        (@"SQR"		, FB_TK_SQR				, FB_TKCLASS_KEYWORD), _
        (@"LOG"		, FB_TK_LOG				, FB_TKCLASS_KEYWORD), _
        (@"INT"		, FB_TK_INT				, FB_TKCLASS_KEYWORD), _
        (@"ATAN2"	, FB_TK_ATAN2			, FB_TKCLASS_KEYWORD), _
        (@"OVERLOAD", FB_TK_OVERLOAD		, FB_TKCLASS_KEYWORD), _
        (@"CONSTRUCTOR", FB_TK_CONSTRUCTOR	, FB_TKCLASS_KEYWORD), _
        (@"DESTRUCTOR", FB_TK_DESTRUCTOR	, FB_TKCLASS_KEYWORD), _
        (@"PRAGMA"	, FB_TK_PRAGMA			, FB_TKCLASS_KEYWORD), _
        (NULL) _
	}


'':::::
sub symbInitKeywords( ) static
    dim as integer i
    dim as FBSYMBOL ptr s

	for i = 0 to SYMB_MAXKEYWORDS-1
    	if( kwdTb(i).name = NULL ) then
    		exit for
    	end if
    	s = symbAddKeyword( kwdTb(i).name, kwdTb(i).id, kwdTb(i).class )
    	if( s = NULL ) then
    		exit sub
    	end if
    next

end sub

'':::::
function symbAddKeyword _
	( _
		byval symbol as zstring ptr, _
		byval id as integer, _
		byval class as integer _
	) as FBSYMBOL ptr

    dim as FBSYMBOL ptr k

    k = symbNewSymbol( NULL, _
    				   @symbGetGlobalTb( ), NULL, TRUE, _
    				   FB_SYMBCLASS_KEYWORD, _
    				   TRUE, symbol, NULL, _
    				   TRUE )
    if( k = NULL ) then
    	return NULL
    end if

    ''
    k->key.id = id
    k->key.class = class

    function = k

end function

'':::::
function symbDelKeyword _
	( _
		byval s as FBSYMBOL ptr _
	) as integer

    function = FALSE

	if( s = NULL ) then
		exit function
	end if

	symbFreeSymbol( s )

	function = TRUE

end function


