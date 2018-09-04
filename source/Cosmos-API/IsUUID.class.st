Class {
	#name : #IsUUID,
	#superclass : #IsObject,
	#category : #'Cosmos-API-Model'
}

{ #category : #'type constraint' }
IsUUID class >> matchesTo: aString [

	^  '[\da-z]+' asRegex matches: aString
]

{ #category : #'type constraint' }
IsUUID class >> parseString: aString [

	^ UUID fromString36: aString
]
