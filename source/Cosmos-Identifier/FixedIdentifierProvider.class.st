Class {
	#name : #FixedIdentifierProvider,
	#superclass : #IdentifierProvider,
	#instVars : [
		'identifier'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'instance creation' }
FixedIdentifierProvider class >> providing: anIdentifier [

	^ self new initializeProviding: anIdentifier 
]

{ #category : #'initialize-release' }
FixedIdentifierProvider >> initializeProviding: anIdentifier [  

	identifier := anIdentifier 
]

{ #category : #providing }
FixedIdentifierProvider >> next [

	^ identifier
]

{ #category : #providing }
FixedIdentifierProvider >> setNextTo: anIdentifier [

	identifier := anIdentifier 
]
