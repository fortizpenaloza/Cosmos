Class {
	#name : #PetsWebService,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'mappingRuleSet'
	],
	#category : #'Cosmos-API-Common-Tests-Example'
}

{ #category : #'instance creation' }
PetsWebService class >> workingWith: aCompositeSystem [ 
	
	^ self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #API }
PetsWebService >> createPetBasedOn: anHttpRequest within: aContext [

	| mediaType pet |

	mediaType := ZnMimeType fromString: anHttpRequest accept.

	pet := self
		decode: anHttpRequest contents
		encodedAs: mediaType
		to: #pets
		within: aContext.

	self petManagementSystem register: pet.

	^ ZnResponse created: (self locationOf: pet)
]

{ #category : #'encoding and decoding' }
PetsWebService >> decode: aJSON encodedAs: aMediaType to: aKeyRepresentingObjectType within: aContext [

	^ (mappingRuleSet ruleToDecode: aMediaType to: aKeyRepresentingObjectType)
		applyOn: aJSON
		within: aContext
]

{ #category : #'encoding and decoding' }
PetsWebService >> encode: anObject of: aKeyRepresentingObjectType to: aMediaType within: aContext [

	^ (mappingRuleSet ruleToEncode: aKeyRepresentingObjectType to: aMediaType)
		applyOn: anObject
		within: aContext
]

{ #category : #initialization }
PetsWebService >> initializeWorkingWith: aCompositeSystem [

	rootSystem := aCompositeSystem.
	mappingRuleSet := (ReflectiveMappingRuleSetBuilder for: self specification) build
]

{ #category : #systems }
PetsWebService >> petManagementSystem [

	^ rootSystem systemImplementing: #PetManagementSystemInterface
]

{ #category : #accessing }
PetsWebService >> specification [

	^ PetsWebServiceSpecification new
]
