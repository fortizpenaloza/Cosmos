Class {
	#name : #PetsWebServiceSpecification,
	#superclass : #Object,
	#category : #'Cosmos-API-Tests-Example'
}

{ #category : #'as yet unclassified' }
PetsWebServiceSpecification >> createPetRoute [

	^ RouteSpecification handling: #POST at: '/pets' sending: #createPetBasedOn:within:
]

{ #category : #'as yet unclassified' }
PetsWebServiceSpecification >> getPetsRoute [

	| route |

	route := RouteSpecification handling: #GET at: '/pets' sending: #getPetsBasedOn:within:.

	^ route asCorsAware
]
