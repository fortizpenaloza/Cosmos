"
A FixedNumberProviderTest is a test class for testing the behavior of FixedNumberProvider
"
Class {
	#name : #FixedIdentifierProviderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Identifier-Tests'
}

{ #category : #'tests-providing' }
FixedIdentifierProviderTest >> testNext [

	| provider |

	provider := FixedIdentifierProvider providing: 3.
	self assert: provider next equals: 3.
	self assert: provider next equals: 3.
	provider setNextTo: 7.
	self assert: provider next equals: 7
]
