Class {
	#name : #PetsWebServiceSpecification,
	#superclass : #Object,
	#category : #'Cosmos-API-Common-Tests-Example'
}

{ #category : #routes }
PetsWebServiceSpecification >> createPetRoute [

	^ RouteSpecification handling: #POST at: '/pets' sending: #createPetBasedOn:within:
]

{ #category : #routes }
PetsWebServiceSpecification >> getPetsRoute [

	| route |

	route := RouteSpecification handling: #GET at: '/pets' sending: #getPetsBasedOn:within:.

	^ route asCorsAware
]
