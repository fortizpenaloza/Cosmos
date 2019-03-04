Class {
	#name : #CommandWithPriorityTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Commands-Tests'
}

{ #category : #tests }
CommandWithPriorityTest >> testInstanceCreationAndAccessing [

	| commandWithPriority |

	commandWithPriority := CommandWithPriority
		holding: 'TURN_LED_ON'
		and: 100.

	self
		assert: commandWithPriority command equals: 'TURN_LED_ON';
		assert: commandWithPriority priority equals: 100
]

{ #category : #tests }
CommandWithPriorityTest >> testPrintOn [

	| commandWithPriority |

	commandWithPriority := CommandWithPriority holding: 'TURN_ON' and: 1.

	self assert: commandWithPriority printString equals: 'TURN_ON [1]'
]
