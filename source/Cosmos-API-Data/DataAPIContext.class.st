Class {
	#name : #DataAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [ 

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #'encoding - decoding' }
DataAPIContext >> decode: aJSON encodedAs: aMediaType within: aKeyRepresentingScope [

	^ (mappingRegistry ruleToDecode: aMediaType to: aKeyRepresentingScope)
		applyOn: aJSON
		within: self
]

{ #category : #'encoding - decoding' }
DataAPIContext >> encode: anObject of: aKeyRepresentingObjectType to: aMediaType [

	^ (mappingRegistry ruleToEncode: aKeyRepresentingObjectType to: aMediaType) applyOn: anObject within: self
]

{ #category : #initialization }
DataAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo:  
	aMappingRegistry [

	cosmos := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #systems }
DataAPIContext >> metadataSystem [
	
	^ cosmos systemImplementing: #MetadataSystemInterface
]

{ #category : #systems }
DataAPIContext >> systemImplementing: anInterfaceName [
	
	^ cosmos systemImplementing: anInterfaceName
]

{ #category : #systems }
DataAPIContext >> timeSystem [

	^ cosmos systemImplementing: #TimeSystemInterface
]
