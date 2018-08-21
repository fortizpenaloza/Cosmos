Class {
	#name : #CommandsAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [ 

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #'encoding - decoding' }
CommandsAPIContext >> decode: aJSON encodedAs: aSchema [

	^ (mappingRegistry decoderFor: aSchema at: #commands)
		cull: aJSON
		cull: self
]

{ #category : #'encoding - decoding' }
CommandsAPIContext >> encode: anObject to: aMimeType [

	^ (mappingRegistry encoderFor: aMimeType at: #commands)
		cull: anObject
		cull: self
]

{ #category : #initialization }
CommandsAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo:  
	aMappingRegistry [

	cosmos := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #systems }
CommandsAPIContext >> systemImplementing: anInterfaceName [
	
	^ cosmos systemImplementing: anInterfaceName
]
