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
CommandsAPIContext >> decode: aJSON encodedAs: aMediaType within: aKeyRepresentingScope [

	^ (mappingRegistry decoderFor: aMediaType within: #commands)
		cull: aJSON
		cull: self
]

{ #category : #'encoding - decoding' }
CommandsAPIContext >> encode: anObject to: aMediaType within: aKeyRepresentingScope [

	^ (mappingRegistry encoderFor: aMediaType within: aKeyRepresentingScope)
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
