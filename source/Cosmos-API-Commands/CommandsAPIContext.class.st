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
CommandsAPIContext >> decode: aJSON encodedAs: aMediaType to: aKeyRepresentingObjectType [

	^ (mappingRegistry ruleToDecode: aMediaType to: aKeyRepresentingObjectType)
		applyOn: aJSON
		within: self
]

{ #category : #'encoding - decoding' }
CommandsAPIContext >> encode: anObject of: aKeyRepresentingObjectType to: aMediaType [

	^ (mappingRegistry
		ruleToEncode: aKeyRepresentingObjectType
		to: aMediaType) applyOn: anObject within: self
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
