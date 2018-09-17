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

{ #category : #initialization }
PetsWebService >> initializeWorkingWith: aCompositeSystem [ 

		rootSystem := aCompositeSystem .
		mappingRuleSet := (ReflectiveMappingRuleSetBuilder for: self specification) build
]

{ #category : #spec }
PetsWebService >> specification [

	^ PetsWebServiceSpecification new
]
