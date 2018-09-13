Class {
	#name : #CommandsAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRuleSet'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [ 

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #'encoding and decoding' }
CommandsAPIContext >> decode: aJSON encodedAs: aMediaType to: aKeyRepresentingObjectType [

	^ (mappingRuleSet ruleToDecode: aMediaType to: aKeyRepresentingObjectType)
		applyOn: aJSON
		within: self
]

{ #category : #'encoding and decoding' }
CommandsAPIContext >> encode: anObject of: aKeyRepresentingObjectType to: aMediaType [

	^ (mappingRuleSet ruleToEncode: aKeyRepresentingObjectType to: aMediaType)
		applyOn: anObject
		within: self
]

{ #category : #initialization }
CommandsAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRuleSet [

	cosmos := aCosmosSystem.
	mappingRuleSet := aMappingRuleSet
]

{ #category : #systems }
CommandsAPIContext >> systemImplementing: anInterfaceName [
	
	^ cosmos systemImplementing: anInterfaceName
]
