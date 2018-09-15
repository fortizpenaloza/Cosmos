Class {
	#name : #PetsWebService,
	#superclass : #Object,
	#category : #'Cosmos-API-Tests-Example'
}

{ #category : #API }
PetsWebService >> createPetBasedOn: anHttpRequest within: aContext [

	| mediaType pet |

	mediaType := ZnMimeType fromString: anHttpRequest accept.

	pet := aContext decode: anHttpRequest contents encodedAs: mediaType to: #pets.

	self petManagementSystem register: pet.

	^ ZnResponse created: (self locationOf: pet)
]

{ #category : #accessing }
PetsWebService >> specification [

	^ PetsWebServiceSpecification new
]
