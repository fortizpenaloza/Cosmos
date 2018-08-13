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

{ #category : #systems }
DataAPIContext >> dataManagementSystem [
	
	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #decoding }
DataAPIContext >> decode: aJSON encodedAs: aMimeType [

	^ (mappingRegistry decoderFor: aMimeType) cull: aJSON cull: self
]

{ #category : #decoding }
DataAPIContext >> encode: anObject to: aMimeType [

	^ (mappingRegistry encoderFor: aMimeType) cull: anObject cull: self 
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

{ #category : #managing }
DataAPIContext >> register: aValue toStreamNamed: aName [

	^ self dataManagementSystem register: aValue toStreamNamed: aName
]

{ #category : #'private - systems' }
DataAPIContext >> timeSystem [

	^ cosmos systemImplementing: #TimeSystemInterface
]
