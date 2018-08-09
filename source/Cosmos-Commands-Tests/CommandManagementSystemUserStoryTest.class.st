Class {
	#name : #CommandManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : 'Cosmos-Commands-Tests-SystemModel'
}

{ #category : #history }
CommandManagementSystemUserStoryTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 625354000; yourself)); add: (#passed->((Set new) add: #testDequeuingCommandsFollowsItsPriority; add: #testQueryingPrioritizedCommands; add: #testDequeuingFromQueueFailsIfEmpty; add: #testEnqueuingAndThenDequeuingCommand; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #running }
CommandManagementSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testDequeuingCommandsFollowsItsPriority [

	self commandManagementSystem enqueue: self turnOnLedCommand with: QueuePriority medium.
	self commandManagementSystem enqueue: self turnOnLedCommand with: QueuePriority low.
	self commandManagementSystem enqueue: self turnOffLedCommand with: QueuePriority high.

	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOffLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime).
	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority medium
				on: self timeSystem dateTime).
	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority low
				on: self timeSystem dateTime)
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testDequeuingFromQueueFailsIfEmpty [

	self
		should:
			[ self commandManagementSystem dequeue ]
		raise: QueueIsEmpty
		withDescription: 'Command priority queue is empty'
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testEnqueuingAndThenDequeuingCommand [

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.

	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime)
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testQueryingPrioritizedCommands [

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.
	self commandManagementSystem
		enqueue: self turnOffLedCommand
		with: QueuePriority medium.

	self
		assert:
			(self commandManagementSystem
				prioritizedCommands)
		hasTheSameElementsInTheSameOrderThat:
			(OrderedCollection
				with:
					(PrioritizedCommand
						holding: self turnOnLedCommand
						with: QueuePriority high
						on: self timeSystem dateTime)
				with:
					(PrioritizedCommand
						holding: self turnOffLedCommand
						with: QueuePriority medium
						on: self timeSystem dateTime))
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOffLedCommand [

	^ LEDCommandsAddOn turnOffLedCommand
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOnLedCommand [

	^ LEDCommandsAddOn turnOnLedCommand
]
