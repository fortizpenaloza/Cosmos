Class {
	#name : #UUIDProvider,
	#superclass : #IdentifierProvider,
	#category : #'Cosmos-Identifier'
}

{ #category : #providing }
UUIDProvider >> next [

	^ UUID new
]
