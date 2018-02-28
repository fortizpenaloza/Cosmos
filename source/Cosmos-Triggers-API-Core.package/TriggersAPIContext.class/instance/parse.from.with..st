private-parsing
parse: aKey from: aDictionary with: aParser

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ Error signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]