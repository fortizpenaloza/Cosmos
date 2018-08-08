Class {
	#name : #IdentifierSystem,
	#superclass : #System,
	#instVars : [
		'identifierProvider'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'system specification' }
IdentifierSystem class >> implementedInterface [

	^ SystemInterface >> #IdentifierSystemInterface
]

{ #category : #'instance creation' }
IdentifierSystem class >> using: anIdentifierProvider [

	^ self new initializeUsing: anIdentifierProvider 
]

{ #category : #initialization }
IdentifierSystem >> initializeUsing: anIdentifierProvider [
	
	super initialize.
	identifierProvider := anIdentifierProvider 
]

{ #category : #providing }
IdentifierSystem >> next [
	
	^identifierProvider next 
]

{ #category : #initialization }
IdentifierSystem >> resolveDependecies [

	"do nothing"
]
