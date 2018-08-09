Class {
	#name : #PrioritizedCommandTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Commands-Tests-SystemModel'
}

{ #category : #history }
PrioritizedCommandTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 624050000; yourself)); add: (#passed->((Set new) add: #testInstanceCreationAndAccessing; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
PrioritizedCommandTest >> octoberFirstOf2014AtMidnight [

	^ (October second, 2015) atMidnight
]

{ #category : #tests }
PrioritizedCommandTest >> testInstanceCreationAndAccessing [

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand holding: 'TURN_LED_ON' with: QueuePriority high on: self octoberFirstOf2014AtMidnight.

	self
		assert: prioritizedCommand command equals: 'TURN_LED_ON';
		assert: prioritizedCommand priority equals: QueuePriority high;
		assert: prioritizedCommand prioritizationDateTime equals: self octoberFirstOf2014AtMidnight;
		assert: prioritizedCommand hash
			equals: (prioritizedCommand command hash bitXor: (prioritizedCommand priority hash bitXor: prioritizedCommand prioritizationDateTime hash))
]
