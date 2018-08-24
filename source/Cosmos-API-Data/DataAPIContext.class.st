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

	^ (mappingRegistry decoderFor: aMediaType within: aKeyRepresentingScope)
		cull: aJSON
		cull: self
]

{ #category : #'encoding - decoding' }
DataAPIContext >> encode: anObject to: aMediaType within: aKeyRepresentingScope [

	^ (mappingRegistry encoderFor: aMediaType within: aKeyRepresentingScope)
		cull: anObject
		cull: self
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
