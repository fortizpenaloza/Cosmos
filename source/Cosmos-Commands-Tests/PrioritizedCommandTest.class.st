Class {
	#name : #PrioritizedCommandTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Commands-Tests-SystemModel'
}

{ #category : #accessing }
PrioritizedCommandTest >> decemberTenthOf2016AtNoon [

	^ (December tenth , 2016) atNoon
]

{ #category : #tests }
PrioritizedCommandTest >> testInstanceCreationAndAccessing [

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand holding: 'TURN_LED_ON' with: QueuePriority high on: self decemberTenthOf2016AtNoon.

	self
		assert: prioritizedCommand command equals: 'TURN_LED_ON';
		assert: prioritizedCommand priority equals: QueuePriority high;
		assert: prioritizedCommand prioritizationDateTime equals: self decemberTenthOf2016AtNoon;
		assert: prioritizedCommand hash
			equals: (prioritizedCommand command hash bitXor: (prioritizedCommand priority hash bitXor: prioritizedCommand prioritizationDateTime hash))
]
