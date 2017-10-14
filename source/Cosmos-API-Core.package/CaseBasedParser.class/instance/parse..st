parsing
parse: aString 

	^ cases at: aString ifAbsent: [ Error signal: 'Parsing failed' ]