Class {
	#name : #DynamicParser,
	#superclass : #Object,
	#instVars : [
		'key',
		'parsers'
	],
	#category : #'Cosmos-API-Decoding'
}

{ #category : #'instance creation' }
DynamicParser class >> determiningParserBy: aKey [

	^ self new initializeDeterminingParserBy: aKey 
	
	
]

{ #category : #'initialize-release' }
DynamicParser >> initializeDeterminingParserBy: aKey [
	
	key := aKey.
	parsers := Dictionary new
]

{ #category : #parsing }
DynamicParser >> parse: aDictionary [

	^ parsers
		at:
			(aDictionary
				at: key
				ifAbsent: [ DecodingFailed signal: ('Key <1s> not found' expandMacrosWith: key) ])
		ifPresent: [ :block | block value: aDictionary ]
		ifAbsent: [ DecodingFailed signal: ('Parser to parse <1s> not found' expandMacrosWith: key) ]
]

{ #category : #configuring }
DynamicParser >> parsing: aKey with: aBlock [
	
	parsers at: aKey put: aBlock
]

{ #category : #parsing }
DynamicParser >> value: aDictionary [ 

	^ self parse: aDictionary 
]
