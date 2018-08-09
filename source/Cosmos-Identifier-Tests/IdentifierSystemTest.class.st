Class {
	#name : #IdentifierSystemTest,
	#superclass : #TestCase,
	#instVars : [
		'identifierProvider'
	],
	#category : #'Cosmos-Identifier-Tests'
}

{ #category : #initialization }
IdentifierSystemTest >> setUp [

	identifierProvider := FixedNumberProvider providing: self startingIndentifier
]

{ #category : #initialization }
IdentifierSystemTest >> startingIndentifier [

	^ 1
]

{ #category : #initialization }
IdentifierSystemTest >> testNext [

	| identifierSystem |

	identifierSystem := IdentifierSystem using: identifierProvider.
	self assert: identifierSystem next equals: self startingIndentifier 
]
