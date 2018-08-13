"
A SequentialNumberProviderTest is a test class for testing the behavior of SequentialNumberProvider
"
Class {
	#name : #SequentialIdentifierProviderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Identifier-Tests'
}

{ #category : #tests }
SequentialIdentifierProviderTest >> testNext [

	| provider |

	provider := SequentialIdentifierProvider providing: #(1 2 3 5).
	self assert: provider next equals: 1;
		assert: provider next equals: 2;
		assert: provider next equals: 3;
		assert: provider next equals: 5;
		assert: provider next equals: 1
]

{ #category : #tests }
SequentialIdentifierProviderTest >> testSequenceShouldntBeEmpty [

	self
		should: [ SequentialIdentifierProvider providing: #() ]
		raise: InstanceCreationFailed
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Sequence shouldn''t be empty' ]
]
