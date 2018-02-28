private-parsing
parse: aKey from: aDictionary with: aParser

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ Error signal: ('<s1> is mandatory and must be present' expandMacrosWith: aKey) ]