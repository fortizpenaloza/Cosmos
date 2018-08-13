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

	identifierProvider := FixedIdentifierProvider providing: self startingIndentifier
]

{ #category : #accessing }
IdentifierSystemTest >> startingIndentifier [

	^ 1
]

{ #category : #tests }
IdentifierSystemTest >> testNext [

	| identifierSystem |

	identifierSystem := IdentifierSystem using: identifierProvider.
	self assert: identifierSystem next equals: self startingIndentifier 
]
