Class {
	#name : #PetsWebService,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'mappingRuleSet'
	],
	#category : #'Cosmos-API-Tests-Example'
}

{ #category : #'instance creation' }
PetsWebService class >> workingWith: aCompositeSystem [ 
	
	^ self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #API }
PetsWebService >> createPetBasedOn: anHttpRequest within: aContext [

	| mediaType pet |

	mediaType := ZnMimeType fromString: anHttpRequest accept.

	pet := aContext decode: anHttpRequest contents encodedAs: mediaType to: #pets.

	self petManagementSystem register: pet.

	^ ZnResponse created: (self locationOf: pet)
]

{ #category : #initialization }
PetsWebService >> initializeWorkingWith: aCompositeSystem [ 

		rootSystem := aCompositeSystem .
		mappingRuleSet := (ReflectiveMappingRuleSetBuilder for: self specification) build
]

{ #category : #accessing }
PetsWebService >> specification [

	^ PetsWebServiceSpecification new
]
