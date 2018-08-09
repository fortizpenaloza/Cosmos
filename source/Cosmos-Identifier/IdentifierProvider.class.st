Class {
	#name : #IdentifierProvider,
	#superclass : #Object,
	#category : #'Cosmos-Identifier'
}

{ #category : #providing }
IdentifierProvider >> next [

	^ self subclassResponsibility 
]
