Class {
	#name : #PrioritizedElementTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Commands-Tests'
}

{ #category : #tests }
PrioritizedElementTest >> testInstanceCreationAndAccessing [

	| prioritizedElement |

	prioritizedElement := PrioritizedElement holding: 'a' with: 100.

	self
		assert: prioritizedElement element equals: 'a';
		assert: prioritizedElement priority equals: 100
]
