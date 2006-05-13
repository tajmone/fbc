#ifndef __HELP_BI__
#define __HELP_BI__

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


#ifndef FALSE
const FALSE = 0
const TRUE  = -1
#endif

#ifndef INVALID
const INVALID = -1
#endif

''
'' helper module protos
''


declare	sub 		hlpInit					( _
											)

declare	sub 		hlpEnd					( _
											)

declare	function 	hGetDefType				( _
												byval symbol as zstring ptr _
											) as integer

declare	sub 		hSetDefType				( _
												byval ichar as integer, _
												byval echar as integer, _
												byval typ as integer _
											)

declare function 	hMatch					( _
												byval token as integer _
											) as integer

declare function 	hMakeTmpStr 			( _
												byval islabel as integer = TRUE _
											) as zstring ptr

declare function 	hFBrelop2IRrelop		( _
												byval op as integer _
											) as integer

declare function 	hFileExists				( _
												byval filename as zstring ptr _
											) as integer

declare sub 		hClearName				( _
												byval src as zstring ptr _
											)

declare sub 		hUcase					( _
												byval src as zstring ptr, _
												byval dst as zstring ptr _
											)

declare function 	hStripUnderscore		( _
												byval symbol as zstring ptr _
											) as string

declare function 	hStripExt				( _
												byval filename as zstring ptr _
											) as string

declare function 	hStripPath				( _
												byval filename as zstring ptr _
											) as string

declare function 	hStripFilename 			( _
												byval filename as zstring ptr _
											) as string

declare function 	hGetFileExt				( _
												byval fname as zstring ptr _
											) as string

declare function 	hRevertSlash			( _
												byval s as zstring ptr, _
												byval allocnew as integer _
											) as zstring ptr

declare function 	hToPow2					( _
												byval value as uinteger _
											) as uinteger

#ifdef FBVALUE
declare sub 		hConvertValue			( _
												byval src as FBVALUE ptr, _
												byval sdtype as integer, _
												byval dst as FBVALUE ptr, _
												byval ddtype as integer _
											)
#endif

declare function 	hJumpTbAllocSym			( _
											) as any ptr

declare function 	hFloatToStr				( _
												byval value as double, _
												byref typ as integer _
											) as string

declare function 	hCheckFileFormat		( _
												byval f as integer _
											) as integer


#include once "inc\hlp-str.bi"

#endif ''__HELP_BI__
