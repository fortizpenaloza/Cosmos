"
An IntegerNumbering provides sequential integer numbers.

"
Class {
	#name : #SequentialNumberProvider,
	#superclass : #IdentifierProvider,
	#instVars : [
		'last'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'initialize-release' }
SequentialNumberProvider >> initialize [

	super initialize.
	last := 0
]

{ #category : #providing }
SequentialNumberProvider >> next [

	^ last := last + 1
]
