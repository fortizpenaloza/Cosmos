Class {
	#name : #DataAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRuleSet'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [ 

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #'encoding and decoding' }
DataAPIContext >> decode: aJSON encodedAs: aMediaType to: aKeyRepresentingObjectType [

	^ (mappingRuleSet ruleToDecode: aMediaType to: aKeyRepresentingObjectType)
		applyOn: aJSON
		within: self
]

{ #category : #'encoding and decoding' }
DataAPIContext >> encode: anObject of: aKeyRepresentingObjectType to: aMediaType [

	^ (mappingRuleSet ruleToEncode: aKeyRepresentingObjectType to: aMediaType)
		applyOn: anObject
		within: self
]

{ #category : #initialization }
DataAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo:  
	aMappingRuleSet [

	cosmos := aCosmosSystem.
	mappingRuleSet := aMappingRuleSet
]

{ #category : #systems }
DataAPIContext >> systemImplementing: anInterfaceName [
	
	^ cosmos systemImplementing: anInterfaceName
]
