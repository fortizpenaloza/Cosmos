private - parsing
parse: aKey from: aDictionary with: aParser ifNotFound: aNotFoundBlock

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aParser parse: rawData ]
		ifAbsent: aNotFoundBlock