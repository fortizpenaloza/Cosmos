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

{ #category : #initialization }
CommandsAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo:  
	aMappingRegistry [

	cosmos := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #'as yet unclassified' }
CommandsAPIContext >> systemImplementing: anInterfaceName [
	
	^ cosmos systemImplementing: anInterfaceName
]
