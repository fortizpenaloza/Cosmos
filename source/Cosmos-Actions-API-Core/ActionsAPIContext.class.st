Class {
	#name : #ActionsAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRegistry'
	],
	#category : #'Cosmos-Actions-API-Core-Model'
}

{ #category : #'instance creation' }
ActionsAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #systems }
ActionsAPIContext >> actionManagementSystem [

	^ cosmos systemImplementing: #ActionManagementSystemInterface
]

{ #category : #'private-parsing' }
ActionsAPIContext >> decode: aKey from: aDictionary with: aParser [

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ DecodingFailed signal: ('<s1> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private-parsers' }
ActionsAPIContext >> httpRequestParser [

	^ HTTPRequestParser new
]

{ #category : #initialization }
ActionsAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [

	cosmos := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #'private-parsers' }
ActionsAPIContext >> nullParser [
	
	^ [ :string | string ] 
]

{ #category : #'private-parsing' }
ActionsAPIContext >> parse: aKey from: aDictionary with: aParser ifNotFound: aNotFoundBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aParser value: rawData ]
		ifAbsent: aNotFoundBlock
]

{ #category : #parsing }
ActionsAPIContext >> parseNameFrom: rawAction [ 

	^ self decode: #name from: rawAction with: self nullParser
]

{ #category : #parsing }
ActionsAPIContext >> parseRequestFrom: rawAction [ 

	self decode: #request from: rawAction with: self httpRequestParser
]
