parsing
parse: aString

	^ cases
		at: aString
		ifAbsent: [ ParsingFailed signal: ('"<1s>" is not a valid object' expandMacrosWith: aString) ]