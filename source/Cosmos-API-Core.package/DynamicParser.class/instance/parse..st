parsing
parse: aDictionary

	^ parsers
		at:
			(aDictionary
				at: key
				ifAbsent: [ ParsingFailed signal: ('Key <1s> not found' expandMacrosWith: key) ])
		ifPresent: [ :block | block value: aDictionary ]
		ifAbsent: [ ParsingFailed signal: ('Parser to parse <1s> not found' expandMacrosWith: key) ]