Class {
	#name : #ActionsAPIContext,
	#superclass : #Object,
	#instVars : [
		'rootSystem'
	],
	#category : 'Cosmos-Actions-API-Core-Model'
}

{ #category : #'instance creation' }
ActionsAPIContext class >> workingWith: aCompositeSystem [ 

	^ self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #systems }
ActionsAPIContext >> actionManagementSystem [

	^ rootSystem systemImplementing: #ActionManagementSystemInterface
]

{ #category : #'private-parsers' }
ActionsAPIContext >> httpRequestParser [

	^ HTTPRequestParser new
]

{ #category : #'initialize-release' }
ActionsAPIContext >> initializeWorkingWith: aCompositeSystem [ 

	rootSystem := aCompositeSystem 
]

{ #category : #'private-parsers' }
ActionsAPIContext >> nullParser [
	
	^ BlockToParserAdapter onParsingEvaluate: [ :string | string ] 
]

{ #category : #'private-parsing' }
ActionsAPIContext >> parse: aKey from: aDictionary with: aParser [

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ Error signal: ('<s1> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private-parsing' }
ActionsAPIContext >> parse: aKey from: aDictionary with: aParser ifNotFound: aNotFoundBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aParser parse: rawData ]
		ifAbsent: aNotFoundBlock
]

{ #category : #parsing }
ActionsAPIContext >> parseNameFrom: rawAction [ 

	^ self parse: #name from: rawAction with: self nullParser
]

{ #category : #parsing }
ActionsAPIContext >> parseRequestFrom: rawAction [ 

	self parse: #request from: rawAction with: self httpRequestParser
]
